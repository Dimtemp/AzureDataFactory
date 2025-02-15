# Lab: Ingest data using the Copy Activity

## Task 1: download the CSV file and inspect it's contents.

1. Sign in to the Azure portal.

1. In the left pane, select **Virtual Machines**.

1. Select the **Sql2019** virtual machine.

1. On the Overview page for the virtual machine, select the Connect button and choose RDP. 

	![Picture 21](images/dp-3300-module-11-lab-21.png)

 
2. On the RDP tab, select the Download RDP File button. 

	![Picture 22](images/dp-3300-module-11-lab-22.png)

3. Open the RDP file that was just downloaded. When a dialog appears asking if you want to connect, select the Connect button.   
	![Picture 23](images/dp-3300-module-11-lab-23.png)

 
4. In the Windows Security dialog if you receive the PIN dialog, select More choices. Then choose Use a different account. If you don’t receive the PIN dialog, you can proceed to Step 5.

	![Picture 24](images/dp-3300-module-11-lab-24.png)

 
5. Enter the username and password selected during the virtual machine provisioning process. Then select the OK button.

	![Picture 25](images/dp-3300-module-11-lab-25.png)

 
6. When the Remote Desktop Connection dialog appears asking if you want to connect, select the Yes button. 

	![Picture 26](images/dp-3300-module-11-lab-26.png)


7. A Remote Desktop window will open.

8. In the VM, open a web browser and open this URL:

    https://github.com/Dimtemp/AzureDataFactory/tree/main/labfiles

9. Click the **moviesDB.csv** file and inspect the contents.

10. Click the **Raw** button to show the source CSV file.

11. Right click the browser window and select **Save as...". Save the file on your desktop.


## Task 2: Add the Copy Activity to the designer

1. Sign in to the Azure portal.

1. In the left pane, select **Resource Groups**.

1. Select the **ADF** resource group.

1. In the ADF resource group, select your Azure Data Factory to open it.

1. Select the **Open Azure Data Factory Studio** link.

1. Alternatively, for the previous steps, you can open the Azure Data Factory by visiting the link https://adf.azure.com/ and signing in.

1. Click on the **pencil icon** on the left sidebar and select the **+** button, select **pipeline**, and select **pipeline** to open the authoring canvas.

    ![Adding a new pipeline to Azure Data Factory in the Azure Portal](images/M07-E02-T01-img02.png)

1. In the Activities pane, open the **Move and Transform** section and drag the **Copy data** activity onto the pipeline canvas.

    ![Adding the Copy Activity to Azure Data Factory in the Azure Portal](images/M07-E02-T01-img01.png)


## Task 3: Create a new HTTP dataset to use as a source

1. In the Source tab of the Copy activity settings, click **+ New**

2. In the data store list, scroll down to select the **HTTP** tile and click **continue**

3. In the file format list, select the **DelimitedText** format tile and click **continue**

4. In **Set properties** blade, give your dataset a name such as **HTTPSource** and click on the **Linked Service** dropdown. Select **New**.

5. In the **New Linked Service (HTTP)** screen, copy the URL of the moviesDB csv file below in the **Base URL** textbox.  You can access the data with no authentication required using the following endpoint:

    https://raw.githubusercontent.com/Dimtemp/AzureDataFactory/master/labfiles/moviesDB.csv

6. In the **Authentication type** drop down, select **Anonymous**.

7. Click the **Test connection** button in the lower right corner of the screen. If the test is successful, click on **Create**.

    -  Once you have created and selected the linked service, specify the rest of your dataset settings. These settings specify how and where in your connection we want to pull the data. As the url is pointed at the file already, no relative endpoint is required. As the data has a header in the first row, set **First row as header** to be true and select Import schema from **connection/store** to pull the schema from the file itself. Select **GET** as the request method. You will see the following screen

        ![Creating a linked service and dataset in Azure Data Factory in the Azure Portal](images/M07-E02-T02-img01.png)
           
    - Click **OK** once completed.
   
    a. To verify your dataset is configured correctly, click **Preview data** in the Source tab of the copy activity to get a small snapshot of your data.
   
   ![Previewing in Azure Data Factory in the Azure Portal](images/M07-E02-T02-img02.png)


### Task 3: Create a new ADLS Gen2 dataset sink

1. Click on the **Sink tab**, and the click **+ New**

2. Select the **Azure Data Lake Storage Gen2** tile and click **Continue**. Please make sure you **did not** select **Gen1** in this step.

3. Select the **DelimitedText** format tile and click **Continue**.

4. In Set Properties blade, give your dataset this name: **ADLS** and click on the **Linked Service** dropdown. Select **New**.

5. In the New linked service (Azure Data Lake Storage Gen2) blade, select your authentication method as **Account key**

6. Select your **Azure Subscription** and select your Storage account that start with **adlsxxxxx**, where xxxxx is your random number. You will see a screen as follows:

   ![Create a Sink in Azure Data Factory in the Azure Portal](images/M07-E02-T03-img01.png)

6. Click the **Test connection** button in the lower right corner of the screen. If the test is succesfull, click on **Create**.

7. Once you have configured your linked service, you enter the set properties blade. As you are writing to this dataset, you want to point the folder where you want moviesDB.csv copied to. In the example below, I am writing to folder **output** in the file system **logs**. While the folder can be dynamically created, the file system must exist prior to writing to it.

8. Set **First row as header** to be true. Select Import Schema: **From sample file**.

9. Browse to the moviesDB.csv file on your desktop.

   ![Setting properties of a Sink in Azure Data Factory in the Azure Portal](images/M07-E02-T03-img02.png)

10. Click **OK** once completed.





### Task 4: Test the Copy Activity

At this point, you have fully configured your copy activity. Let's test it out.

1. Click the **Publish all** button in the top section of the data factory to save your changes. Review the summary and click **Publish**.

1. Click on the **Debug** button at the top of the pipeline canvas. This will start a pipeline debug run.

1. To monitor the progress of a pipeline debug run, click on the **Output** tab of the pipeline

1. To view a more detailed description of the activity output, click on the **eyeglasses** icon. This will open up the copy monitoring screen which provides useful metrics such as Data read/written, throughput and in-depth duration statistics.

   ![Monitoring a pipeline in Azure Data Factory in the Azure Portal](images/M07-E02-T04-img01.png)

1. Close the Details window by clikcking the cross in the upper right corner.

1. Return to the Azure Portal tab in the web browser.

1. In the left pane, select **Resource Groups**.

1. Select the **ADF** resource group.

1. In the ADF resource group, select your **adlsxxxxx** Azure Storage Account to open it.

1. Click containers. Click the **logs** container, click the output folder and check to see your file was written as expected.
