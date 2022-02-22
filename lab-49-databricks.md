# Lab: Azure Data Factory integration with Azure Databricks

## Lab overview

Students will provision an Azure Databricks instance and will then create a workspace that will be used to perform a simple task.

> Note 1: The next Azure resources might be very expensive. Especially when running for long periods of time. If you destroy the resources at the end of this exercise, expenses will stat at a minimum. If you forget to delete the resources at the end of this exercises, it might deplete your balance very quickly!

> Note 2: Azure Databricks is a big topic to cover. Since the topic of Databricks is not discussed in this course, we only focus in integrating between Azure Data Factory and Azure Databricks. In Azure Databricks we will run an arbitrary notebook. As soon as the integration works, you can imagine any Azure Databricks notebook to run within Azure Data Factory.


## Task 1: Create and configure an Azure Databricks instance.

1. In the Azure portal, at the top left of the screen, click on the **Home** hyperlink.

2. In the Azure portal, click on the **+ Create a resource** icon.

3. In the New screen, click in the **Search services and marketplace** text box, and type the word **Azure databricks**. Click **Azure Databricks** in the list that appears.

4. In the **Azure Databricks** blade, click **Create**.

5. In the **Azure Databricks Service** blade, create an Azure Databricks Workspace with the following settings:

    - **Subscription**: the name of the subscription you are using in this lab

    - **Resource group**: **ADF**.

    - **Workspace name**: **databricks**.

    - **Region**: **West Europe**.

    - **Pricing Tier**: **Standard** or **Premium (+ Role-based access controls)**.

        ![Creating Azure Databricks in the Azure portal](Linked_Image_Files/M03-E02-T01-img01.png)

6. In the **Azure Databricks Service** blade, click **Review +create**. Then click **Create**

   > **Note**: The Databricks Runtime is built on top of Apache Spark and is natively built for the Azure cloud. Azure Databricks completely abstracts out the infrastructure complexity and the need for specialized expertise to set up and configure your data infrastructure. For data engineers, who care about the performance of production jobs, Azure Databricks provides a Spark engine that is faster and performant through various optimizations at the I/O layer and processing layer (Databricks I/O). The provision will take approximately 3 minutes. Please wait for it since the next task involves a more time-consuming deployment. 


## Task 2: Open Azure Databricks. Launch the Databricks Workspace and create a Spark Cluster.

1. Confirm that the Azure Databricks service has been created.

2. In the Azure portal, navigate to the **Resource group** screen.

3. In the Resource groups screen, click on the ****ADF** resource group.

4. In the **ADF** screen, click **databricks** to open Azure Databricks. This will open your Azure Databricks service.

    ![Azure Databricks Service in the Azure portal](Linked_Image_Files/M03-E02-T02-img01.png)

5. In the Azure portal, click on the button **Launch Workspace**.

    > **Note**: You will be signed into the Azure Databricks Workspace in a separate tab in the web browser.

6. In the left panel, click **Create**, click **Cluster**.

7. In the **Create Cluster** screen, under New Cluster, create a Databricks Cluster with the following settings

    - **Cluster name**: **cluster1**.

    - **Cluster Mode**: **Standard**

    - **Databricks Runtime Version**: **Runtime: 9.1 LTS**    or 8.3 (Scala 2.12, Spark 3.1.1)

    - Make sure you select and set the **Terminate after 60** minutes of inactivity check box.

    - **Min Workers**: **1**

    - **Max Workers**: **2**

    - Leave all the remaining options to their current settings, and then click on **Create Cluster**:

        ![Creating an Azure Databricks Cluster in the Azure portal](Linked_Image_Files/M03-E02-T03-img01.png)

8. In the **Create Cluster** screen, click on **Create Cluster** and leave the Microsoft Edge screen open.

> **Note**: The creation of the Azure Databricks instance will take approximately 10 minutes as the creation of a Spark cluster is simplified through the graphical user interface. You will note that the **State** of **Pending** whilst the cluster is being created. This will change to **Running** when the Cluster is created.

> **Note**: Now might be a great time for a cup of coffee!


## Task 3: Generate a Databricks Access Token.

1. Still in the databricks workspace, in the bottom section of the left bar, click the **Settings** icon.

2. Click **User Settings**.

3. Make sure the **Access Tokens** tab is selected, and click the **Generate New Token** button.

4. Enter a description in the **comment** "For ADF Integration" and set the **lifetime** period of 10 days and click on **Generate**

5. Notice the warning message. Copy the generated token and store in Notepad, and then click on **Done**.


## Task 4: Generate a Databricks Notebook

1. On the left of the screen, click on the **Workspace** icon, then click on the arrow next to the word Workspace, and click on **Create** and then click on **Folder**. Name the folder **adftutorial**, and click on **Create Folder**. The adftutorial folder appears in the Workspace.

2. Click on the drop down arrow next to adftutorial, and then click **Create**, and then click **Notebook**.

3. In the Create Notebook dialog box, type the name of **mynotebook**, and ensure that the language states **Python**, and then click on **Create**. The notebook with the title of mynotebook appears/

4. In the newly created notebook "mynotebook'" add the following code and click **run**.

    ```Python
    # Creating widgets for leveraging parameters, and printing the parameters

    dbutils.widgets.text("input", "","")
    dbutils.widgets.get("input")
    y = getArgument("input")
    print ("Param -\'input':")
    print (y)
    ```

    > **Note** that the notebook path is **/adftutorial/mynotebook**


## Task 5: Create Linked Services

1. Return to Azure Data Factory tab in the web browser.

2. On the left hand side of the screen, click on the **Manage** icon. 

3. In the **Connections** pane, go to **Linked Services**, and then click on **+ New**.

4. In the **New Linked Service**, at the top of the screen, click on **Compute**, and then click on **Azure Databricks**, and then click on **Continue**.

5. In the **New Linked Service (Azure Databricks)** screen, fill in the following details and click on **Finish**
    - **Name**: AzureDatabricks1
    - **Account selection method**: **From Azure subscription**
    - **Azure subscription**: select the subscription you use for this lab
    - **Databricks Workspace**: databricks
    - **Select cluster**: **Existing interactive cluster**
    - **Access Token**: Copy the access token from Notepad and paste into this field
    - **Choose from existing cluster**: cluster1
    - Leave other options to their default settings

6. Click the **Test connection** button next to the dataset. Only proceed if the connection is succesfull.

7. Click **Create**

    > **Note**: When you click on create, you are returned to the **Linked services** screen where the dbls has been created, with the other linked services created in the previous exercise.


## Task 6: Create a pipeline that uses Databricks Notebook Activity.

1. On the left hand side of the screen, select the **pencil** icon to author a pipeline.

2. Under Factory Resources, click on the **+** icon, and then click on **Pipeline**, and click **Pipeline**. This opens up a tab with a Pipeline designer.

2. At the bottom of the pipeline designer, click on the parameters tab, and then click on **+ New**

3. Create a parameter with the Name of **name**, with a type of **string**

4. Under the **Activities** menu, expand out **Databricks**.

5.  Click and drag **Notebook** onto the canvas.

6. In the properties for the **Notebook1** window at the bottom, complete the following steps:
    - Switch to the **Azure Databricks** tab.
    - Select **AzureDatabricks1** which you created in the previous procedure.
    - Switch to the **Settings** tab, click Browse and select the **/adftutorial/mynotebook** Notebook path.
    - Expand **Base Parameters**, and then click on **+ New**
    - Create a parameter with the Name of **input**, with a value of **@pipeline().parameters.name**

7. In the **Notebook1**, click on **Validate**, next to the Save as template button. As window appears on the right of the screen that states "Your Pipeline has been validated. No errors were found." Click on the >> to close the window.

8. Click on the **Publish All** to publish the linked service and pipeline. Then click on **Publish**.

    > **Note**: A message will appear to state that the publishing was completed and successful.


## Task 7: Trigger a Pipeline Run

1. In the **Notebook1**, click on **Add trigger**, and click on **Trigger Now** next to the Debug  button.

2. The **Pipeline Run** dialog box asks for the name parameter. Use **/path/filename** as the parameter here. Click Finish. A red circle appear above the Notebook1 activity in the canvas.


## Task 8: Monitor the Pipeline

1. On the left of the screen, click on the **Monitor** icon. Confirm that you see a pipeline run. It takes approximately 5-8 minutes to create a Databricks job cluster, where the notebook is executed.

2. Select **Refresh** periodically to check the status of the pipeline run.


## Task 9 : Verify the output

1. In the web browser, click on the tab **mynotebook - Databricks** 

2. In the **Azure Databricks** workspace, click on **Clusters** and you can see the Job status as pending execution, running, or terminated.

3. Click on the cluster **cluster1**, and then click on the **Event Log** to view the activities.

    > **Note**: You should see an Event Type of **Starting** with the time you triggered the pipeline run.



## Task 10: Clean up

1. Return to the Azure portal tab in the web browser.

1. Click **Resource Groups** in the left panel. Verify that a new resource group has been created that starts with the name **databricks-rg-**. Click it to inpsect the contents.

1. Many resources exist in the resource group for the databricks spark cluster.

1. Return to the **Databricks** tab in the web browser.

1. In the left panel click the **Compute** icon.

1. Click **cluster1** you previously created.

1. Click the **Delete** button. Click **Delete** to confirm.

1. Still in the Azure portal, click the **ADF** resource group, and select the Databricks resource to open it.

1. Click the **delete** button to delete the databricks resource.

1. Return to the Azure portal and click **Resource Groups** in the left panel. Click the resource group that starts with the name **databricks-rg-**. Click it to inpsect the contents.

