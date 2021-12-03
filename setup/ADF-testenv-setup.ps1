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

$pw = ConvertTo-SecureString -String 'Pa55w.rd' -AsPlainText -Force
New-AzDataFactoryDemoEnvironment -Password $pw -Verbose #-CleanUpADFResourceGroup

# deze werken uitsluitend met definition files  :(
#New-AzDataFactoryV2LinkedService
#New-AzDataFactoryV2Dataset
#New-AzDataFactoryV2Pipeline
