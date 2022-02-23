# Lab: Implement Azure Key Vault

# Task 1: Create an Azure Key Vault 

1. Sign in to the [Azure portal](https://portal.azure.com).

2. From the **All services** blade, search for and select **Key vaults**, then select **+Add +New +Create **.

3. Configure the key vault (replace **xxxx** in the name of the key vault with letters and digits such that the name is globally unique). Leave the defaults for everything else.

    | Setting | Value | 
    | --- | --- |
    | Subscription | **Use default supplied** |
    | Resource group | **ADF** |
    | Key vault name | **keyvaultxxxxx** |
    | Location | **West Europe** |
    | Pricing tier | **Standard** |
    
    **Note** replace **xxxxx** to find a unique name.

4. Click **Review + create**, and then click **Create**. 

5. Once the new key vault is provisioned, click **Go to resource**. Or you can locate your new key vault by searching for it. 

6. Click on the key vault **Overview** tab and take note of the **Vault URI**. Applications that use your vault through the REST APIs will need this URI.

7. Take a moment to browse through some of the other key vault options. Under **Settings** review **Keys**, **Secrets**, **Certificates**, **Access Policies**, **Firewalls and virtual networks**.

    **Note**: Your Azure account is the only one authorized to perform operations on this new vault. You can modify this if you wish in the **Settings** and then the **Access policies** section.

# Task 2: Add a secret to the Key Vault
        
In this task, we will add a password to the key vault. 

1. Under **Settings** click **Secrets**, then click **+ Generate/Import**.

2. Configure the secret. Leave the other values at their defaults. Notice you can set an activation and expiration date. Notice you can also disable the secret.

    | Setting | Value | 
    | --- | --- |
    | Upload options | **Manual** |
    | Name | **SQLPassword** |
    | Value | **the password to your SQL DB PaaS Server form previous exercises** |

3. Click **Create**.

4. Once the secret has been successfully created, click on the **SQLPassword**, and note it has a status of **Enabled**

5. Select the secret you just created, note the the **Secret Identifier**. This is the url value that you can now use with applications. It provides a centrally managed and securely stored password. 

6. Click the button **Show Secret Value**, to display the password you specified earlier.




# Task policy

1. Open the properties of your data factory and copy the Managed Identity Application ID value.



# Task key van functions opnemen in vault


# Task

1. Return to the Azure Data Factory Studio tab in the web browser.

1. Open the pipeline that contains your Azure Function from the previous exercise.

1. At the **Settings** tab, click the **Edit** button to edit the Azure Function linked service.

1. In the flyout window that appears, click Azure Key Vault.

1. From **AKV linked service**, click **+ New**.

1. In the flyout window that appears, select your key vault from the **Azure Key Vault name** section.

1. Click the **Test connection** button in the lower right corner of the screen. If the test is successful, click on **Create**.


1. 

, to specify the key we just created in the key vault.



Congratulations! You have created an Azure Key vault and then created a password secret in that key vault, providing a securely stored, centrally managed password for use with applications.


