function New-AzDataFactoryDemoEnvironment {
    [cmdletbinding()]
    param(
        [switch]$CleanUpADFResourceGroup,
        [string]$Location = 'westeurope',
        [string]$StorageSkuName = 'Standard_LRS',
        [string]$ResGroupName = 'ADF',

        [string]$StorageAccountName  = "stor1$(Get-Random -maximum 100000000)",   # min 3 max 24 chars
        [string]$StorageAccountName2 = "stor2$(Get-Random -maximum 100000000)",
        [string]$ContainerNamePrefix = 'container',

        [string]$KeyVaultName = "vault1$(Get-Random -maximum 100000000)",

        [string]$AdfName = "factory1$(Get-Random -maximum 10000)",

        [string]$SqlServerName = "sqlserver1$(Get-Random -maximum 100000000)".ToLower(), # max 63 chars
        [string]$SqlDatabaseName = 'AdventureWorksLT',  # also name of the Sample database, so non-configurable yet
        # GeneralPurpose ($200/month) for serverless or Basic ($4/month)?
        [string]$SqlEdition = 'Basic',

        [string]$UserName = 'Dimitri',
        [parameter(Mandatory=$true)]
        [Security.SecureString]$Password,

        [ValidatePattern('^[a-z0-9]+(-[a-z0-9]+)*')]
        [string]$CosmosAccountName = "cosmos1$(Get-Random -maximum 100000000)",   # max 44 chars?
        [string]$CosmosDatabaseName = 'DB1',
        [string]$CosmosContainerName = 'Container1'
    )

    # begin
    if ($CleanUpADFResourceGroup) {
        Remove-AzResourceGroup -Name $ResGroupName
    } else {
        $cred = New-Object System.Management.Automation.PSCredential ($userName, $Password)

        # process
        if (Get-AzStorageAccountNameAvailability -Name $StorageAccountName) {
            $PSDefaultParameterValues=@{
                "*:ResourceGroupName"=$ResGroupName
                "*:Location"=$Location                
            }

            # Simple resources
            New-AzResourceGroup -Name $ResGroupName -Location $Location
            New-AzDataFactoryV2 -Name $AdfName -Location $Location
            New-AzKeyVault -Name $KeyVaultName -Location $Location
            $s1 = New-AzStorageAccount -Location $Location -SkuName $StorageSkuName -Name $StorageAccountName #-AsJob
            $s2 = New-AzStorageAccount -Location $Location -SkuName $StorageSkuName -Name $StorageAccountName2 #-AsJob

            # SQL Database
            $SqlServer = Get-AzSqlServer -ResourceGroupName $ResGroupName
            if (!($SqlServer)) {
                New-AzSqlServer -ServerName $SqlServerName -SqlAdministratorCredentials $cred -Location $Location #-AsJob
            } else {
                $SqlServerName = $SqlServer.ServerName
            }
            New-AzSqlDatabase -DatabaseName $SqlDatabaseName -Edition $SqlEdition -ServerName $SqlServerName -SampleName $SqlDatabaseName #-ComputeModel Serverless -ComputeGeneration Gen5 -MinVcore 0.5 -MaxVcore 2 -AutoPauseDelayInMinutes (4*60)
            New-AzSqlServerFirewallRule -ServerName $SqlServerName -FirewallRuleName 'AllowAllWindowsAzureIps' -StartIpAddress '0.0.0.0' -EndIpAddress '0.0.0.0'

            # Cosmos DB
            $cdb = Get-AzCosmosDBAccount
            if (!($cdb)) {
                New-AzCosmosDBAccount -EnableFreeTier $true -ApiKind Sql -Name $CosmosAccountName #-AsJob
            } else { $CosmosAccountName = $cdb.Name }

            Write-Verbose $CosmosAccountName
            New-AzCosmosDBSqlDatabase -AccountName $CosmosAccountName -Name $CosmosDatabaseName
            New-AzCosmosDBSqlContainer -Name $CosmosContainerName -AccountName $CosmosAccountName -DatabaseName $CosmosDatabaseName -PartitionKeyKind 'Hash' -PartitionKeyPath '/id' # -ResourceGroupName $ResGroupName

            # SQL VM for SSMS and ADF on-prem integration runtime

            # finish without specific parameters
            $PSDefaultParameterValues=@{}
            New-AzStorageContainer -Name "$($ContainerNamePrefix)a" -Context $s1.context
            New-AzStorageContainer -Name "$($ContainerNamePrefix)b" -Context $s1.context
            New-AzStorageContainer -Name "$($ContainerNamePrefix)c" -Context $s2.context
        } else {
            Write-Error "Storage account name not available: $StorageAccountName"
        }
    }
}




function New-AzDataFactoryVM {
<#
.SYNOPSIS
This command can create a SQL Server VM in Azure. It can be used to perform tests and demos with Azure Data Platform products, like Azure Data Factory.
.NOTES
To do: download and install SQL Database, like AdventureWorks
#>

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceGroupName,

        [string]$Location = 'westeurope',

        [string]$VMName = 'DP' + (Get-Random -Maximum 1000000),

        [string]$UserName = 'Student',
        [Security.SecureString]$Password,

        [string]$VnetPrefix = '10.0.0.0/16',
        [string]$SubnetPrefix = '10.0.0.0/24',

        [string]$VMSize = 'Standard_DS2_v2', # (1 vcpus, 3.5 GiB memory)
        # Standard_DS1_v2, Standard_DS13_V2, Get-AzVMSize -location westeurope | where numberofcores -eq 2 | sort MemoryInMB

        [string]$Image = 'SQL2017-WS2016'   # liever SQL 2019!
    )

    $SubnetName = $ResourceGroupName + '-subnet'
    $VnetName = $ResourceGroupName + '-vnet'
    $PipName = $ResourceGroupName + '-pip' + $(Get-Random -Maximum 1000)

    # Create a subnet configuration
    $SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $SubnetPrefix

    # Rule to allow remote desktop (RDP)
    $NsgRuleRDP = New-AzNetworkSecurityRuleConfig -Name 'RDP' -Protocol Tcp `
    -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

    # create credential object
    #$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
    $Cred = New-Object System.Management.Automation.PSCredential ($username, $Password)

    $PSDefaultParameterValues=@{
        "*:ResourceGroupName"=$ResourceGroupName
        "*:Location"=$Location                
    }

    # Simple resources
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location

    # Create a virtual network
    $Vnet = New-AzVirtualNetwork -Name $VnetName -AddressPrefix $VnetPrefix -Subnet $SubnetConfig

    # Create a public IP address and specify a DNS name
    $Pip = New-AzPublicIpAddress -AllocationMethod Static -IdleTimeoutInMinutes 4 -Name $PipName

    # Create the network security group
    $NsgName = $ResourceGroupName + "nsg"
    $Nsg = New-AzNetworkSecurityGroup -Name $NsgName -SecurityRules $NsgRuleRDP

    # Create the network interface
    $InterfaceName = $ResourceGroupName + "int"
    $Interface = New-AzNetworkInterface -Name $InterfaceName `
       -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $Pip.Id `
       -NetworkSecurityGroupId $Nsg.Id

    # finish without specific parameters
    $PSDefaultParameterValues=@{}

    # Create a virtual machine configuration
    $VMConfig = New-AzVMConfig -VMName $VMName -VMSize $VMSize |
    Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate |
    Set-AzVMSourceImage -PublisherName 'MicrosoftSQLServer' -Offer $Image -Skus 'SQLDEV' -Version 'latest' |
    Add-AzVMNetworkInterface -Id $Interface.Id

    # Create the VM
    New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig
}


$pw = ConvertTo-SecureString -String 'Pa55w.rd' -AsPlainText -Force
New-AzDataFactoryDemoEnvironment -Password $pw -Verbose #-CleanUpADFResourceGroup

$pw = ConvertTo-SecureString -String 'Pa55w.rd1234' -AsPlainText -Force
#New-AzDataFactoryVM -ResourceGroupName 'ADF-VM4' -Password $pw -Verbose

# deze werken uitsluitend met definition files  :(
#New-AzDataFactoryV2LinkedService
#New-AzDataFactoryV2Dataset
#New-AzDataFactoryV2Pipeline
