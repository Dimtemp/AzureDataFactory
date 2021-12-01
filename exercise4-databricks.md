## Exercise 4: Azure Data Factory and Databricks
  
Estimated Time: 15 minutes

Individual exercise
  
The main tasks for this exercise are as follows:

1. Generate a Databricks Access Token.

2. Generate a Databricks Notebook

3. Create Linked Services

4. Create a Pipeline that uses Databricks Notebook Activity.

5. Trigger a Pipeline Run.

### Task 1: Generate a Databricks Access Token.

1. In the Azure portal, click on **Resource groups** and then click on **awrgstudxx**, and then click on **awdbwsstudxx** where xx are the initials of your name.

2. Click on **Launch Workspace**

3. Click the user **profile icon** in the upper right corner of your Databricks workspace.

4. Click **User Settings**.

5. Go to the Access Tokens tab, and click the **Generate New Token** button.

6. Enter a description in the **comment** "For ADF Integration" and set the **lifetime** period of 10 days and click on **Generate**

7. Copy the generated token and store in Notepad, and then click on **Done**.

### Task 2: Generate a Databricks Notebook

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

### Task 3: Create Linked Services

1.  In the Azure portal, return to Azure Data Factory and click **author and monitor** to open Azure Data Factory in the browser.

2. In the **xx-data-factory** screen, click on **Manage** tab. Another tab opens up to author an Azure Data Factory solution.

3. On the left hand side of the screen, click on the **Manage** icon. 

4. In the **Connections** pane, go to **Linked Services**, and then click on **+ New**.

5. In the **New Linked Service**, at the top of the screen, click on **Compute**, and then click on **Azure Databricks**, and then click on **Continue**.

6. In the **New Linked Service (Azure Databricks)** screen, fill in the following details and click on **Finish**
    - **Name**: xx_dbls, where xx are your initials
    - **Account selection method**: **From Azure subscription**
    - **Azure subscription**: select the subscription you use for this lab
    - 
    - **Databricks Workspace**: awdbwsstudxx, where xx are your initials
    - **Select cluster**: **Existing interactive cluster**
    - **Access Token**: Copy the access token from Notepad and paste into this field
    - **Choose from existing cluster**: awdbclstudxx, where xx are your initials
    - Leave other options to their default settings
    - Click **Create**

    > **Note**: When you click on create, you are returned to the **Linked services** screen where the xx_dbls has been created, with the other linked services created in the previous exercise.

### Task 5: Create a pipeline that uses Databricks Notebook Activity.

1. On the left hand side of the screen, select the **Author** item to create a pipeline. Under Factory Resources, click on the **+** icon, and then click on **Pipeline**. This opens up a tab with a Pipeline designer.

2. At the bottom of the pipeline designer, click on the parameters tab, and then click on **+ New**

3. Create a parameter with the Name of **name**, with a type of **string**

4. Under the **Activities** menu, expand out **Databricks**.

5.  Click and drag **Notebook** onto the canvas.

6. In the properties for the **Notebook1** window at the bottom, complete the following steps:
    - Switch to the **Azure Databricks** tab.
    - Select **xx_dbls** which you created in the previous procedure.

    - Switch to the **Settings** tab, and put **/adftutorial/mynotebook** in Notebook path.
    - Expand **Base Parameters**, and then click on **+ New**
    - Create a parameter with the Name of **input**, with a value of **@pipeline().parameters.name**

7. In the **Notebook1**, click on **Validate**, next to the Save as template button. As window appears on the right of the screen that states "Your Pipeline has been validated.
No errors were found." Click on the >> to close the window.

8. Click on the **Publish All** to publish the linked service and pipeline. Then click on **Publish**.

    > **Note**: A message will appear to state that the publishing was completed and successful.

### Task 6: Trigger a Pipeline Run

1. In the **Notebook1**, click on **Add trigger**, and click on **Trigger Now** next to the Debug  button.

2. The **Pipeline Run** dialog box asks for the name parameter. Use **/path/filename** as the parameter here. Click Finish. A red circle appear above the Notebook1 activity in the canvas.

### Task 7: Monitor the Pipeline

1. On the left of the screen, click on the **Monitor** tab. Confirm that you see a pipeline run. It takes approximately 5-8 minutes to create a Databricks job cluster, where the notebook is executed.

2. Select **Refresh** periodically to check the status of the pipeline run.


### Task 8: Verify the output

1. In Microsoft Edge, click on the tab **mynotebook - Databricks** 

2. In the **Azure Databricks** workspace, click on **Clusters** and you can see the Job status as pending execution, running, or terminated.

3. Click on the cluster **awdbclstudxx**, and then click on the **Event Log** to view the activities.

    > **Note**: You should see an Event Type of **Starting** with the time you triggered the pipeline run.
