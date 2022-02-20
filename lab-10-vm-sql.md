# Lab: Using the Azure Portal and SQL Server Management Studio
 
## Lab Overview 

Students will explore the Azure Portal and use it to create an Azure VM with SQL Server 2019 installed. Then they will connect to the virtual machine through Remote Desktop Protocol and use the SQL Server Management Studio. 


## Task 1: Explore the Azure Portal

1. From the lab virtual machine, if you are not already in the portal, start a browser session and navigate to [https://portal.azure.com](https://portal.azure.com/). 

	![Picture 1](images/dp-3300-module-11-lab-01.png)

 

2. In the Azure Portal, type subscription in the search bar at the top of the screen. Click on the subscriptions icon. (You may need to log in first.)

	![Picture 2](images/dp-3300-module-11-lab-02.png)

 

3. On the Subscriptions blade, you will have one or more subscriptions. Review your Subscription name, subscription ID, and your role. 

	![Picture 3](images/dp-3300-module-11-lab-03.png)

4. Launch the left navigation pane by clicking the horizontal lines next to Microsoft Azure in the top left of the portal. Then select All resources. 

	![Picture 4](images/dp-3300-module-11-lab-04.png)

	![Picture 5](images/dp-3300-module-11-lab-05.png)

 

5. The All resources page will list all Azure resources within your selected subscriptions. 

 

6. Select Resource groups in the left navigation.

	![Picture 6](images/dp-3300-module-11-lab-06.png)

	

	The Resource groups blade will list all Azure resource groups within your selected subscriptions. 


7. On the Resource groups blade, select the Create button. 

	![Picture 7](images/dp-3300-module-11-lab-07.png)

 
8. Ensure you have selected the appropriate subscription for the lab. Name the resource group Sql2019. Select the nearest Azure region to your location. Select the Review + Create button. Once the review completes, select the Create button. 

	![Picture 8](images/dp-3300-module-11-lab-08.png)

9. Locate the search bar at the top of the page. Search for Azure SQL. Select the search result for Azure SQL that appears in the results under Services.

	![Picture 9](images/dp-3300-module-11-lab-09.png)

 

## Task 2: Provision a SQL Server on an Azure Virtual Machine

1. On the Azure SQL blade, select the Create button. 

	![Picture 10](images/dp-3300-module-11-lab-10.png)


2. On the Select SQL deployment option blade, open the drop-down box under SQL virtual machines. Select the option labeled Free SQL Server License: SQL 2019 Developer on Windows Server 2019. Then select the Create button.
	
	![Picture 11](images/dp-3300-module-11-lab-11.png)

3. On the Create a virtual machine blade, enter the following information: 

	- Subscription: **Your subscription**

	- Resource group: **Sql2019**

	- Virtual machine name:  **Sql2019**

	- Region: **West Europe**

	- Availability Options: **No infrastructure redundancy required**
	
	- Image: **Free SQL Server License: SQL 2019 Developer on Windows Server 2019 - Gen1**

	- Azure spot instance: **No**

	- Size: Standard **D2s_v3** (2 vCPUs, 8 GiB memory; you may need to select the "See all sizes" link to see this option)

	- Administrator account username: **your first name**

	- Administrator account password: **Pa55w.rd1234** (or your own password that meets the criteria)

	- Select inbound ports: **RDP (3389)**

	- Would you like to use an existing Windows Server license?: **No**

	Make note of the username and password for later use.

	![Picture 12](images/dp-3300-module-11-lab-12.png)


4. Navigate to the Disks tab and review the configuration. 

	![Picture 13](images/dp-3300-module-11-lab-13.png)

 
5. Navigate to the Networking tab and review the configuration. 

	![Picture 14](images/dp-3300-module-11-lab-14.png)
 

6. Navigate to the Management tab and review the configuration. 

	![Picture 15](images/dp-3300-module-11-lab-15.png)

	Please leave the auto shutdown optioen enabled at 19:00. If you forget to shut down the VM at the end of the day, it will automatically shut down at 19:00 and save you a lot of money. Understand that this is **not** desirable in a production environment! ;-)


7. Navigate to the Advanced tab and review the configuration. 

	![Picture 16](images/dp-3300-module-11-lab-16.png)


8. Navigate to the SQL Server settings tab and review the configuration. 

	![Picture 17](images/dp-3300-module-11-lab-17.png)

	By default, the SQL Server Azure VM templates create one premium disk with read caching for data, one premium disk without caching for transaction log, and uses the local SSD (D:\ on Windows) for tempdb.

	Reconfigure both data and transaction log disks for 8 GB of disk space. 

	**Please notice!** If you fail to reconfigure the disks, it will cost you a lot of money since the default size per disk is 1 TB. This might stop you from performing additional exercises.


9. Select the Review + create button. Then select the Create button.  

    ![Picture 18](images/dp-3300-module-11-lab-18.png)


10. On the deployment blade, wait until the deployment is complete. The VM will take approximate 5-10 minutes to deploy. Then select the Go to resource button. 

	![Picture 19](images/dp-3300-module-11-lab-19.png)

 
11. On the overview page for the virtual machine, scroll through the menu options for the resource to review what is available.

	![Picture 20](images/dp-3300-module-11-lab-20.png)


## Task 3: Connect to the Virtual Machine

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


7. A Remote Desktop window will open. On the right, select the No button to indicate you do not want the computer to be discoverable by other devices on the network. Close the small Server Manager popup dialog by clicking the X in the top right of the box. Keep the big Server Manager Window open.

	![Picture 27](images/dp-3300-module-11-lab-27.png)

 
8. In the Server Manager window, select Local Server on the left and then select On next to IE Enhanced Security Configuration. 

	![Picture 28](images/dp-3300-module-11-lab-28.png)

 
9. When the Internet Explorer Enhanced Security Configuration dialog appears, set Administrators to Off. Then select the OK button.

	![Picture 29](images/dp-3300-module-11-lab-29.png)

 

 

## Task 4: Install Storage Explorer

1. From the Sql2019 Azure VM, open the Microsoft Edge web browser and navigate to this page for [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/).

5. In the Microsoft Edge dialog box click **Save**, when the download is complete, click on **View downloads**, in the download screen in Microsoft Edge, click on **Open folder**. This will open the Downloads folder.

6. Double click the file **StorageExplorer.exe**, in the User Account Control dialog box click on **Yes**.

7. In the License Agreement screen, select the radio button next to **I agree the agreement**, and then click on **Install**.

   > **Note**: The installation of Storage Explorer can take a few minutes. Azure Storage Explorer allows you to easily manage the contents of your storage account with Azure Storage Explorer. Upload, download, and manage blobs, files, queues, tables, and Cosmos DB entities. It also enables you to gain easy access to manage your virtual machine disks.

8. On completion of the installation, ensure that the checkbox next to **Launch Microsoft Azure Storage Explorer** is selected and then click **Finish**.

9. Microsoft Azure Storage Explorer opens up. Right click the Storage Explorer in the taskbar and select **"Pin to taskbar"**.


 
## Task 5: Restore the Database and Verify its Availability

1. Open Internet Explorer by selecting the icon from the task bar. 

	![Picture 30](images/dp-3300-module-11-lab-30.png)

1. In Internet Explorer, navigate to the following URL: 

	[https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorksDW2017.bak)


	A dialog will appear asking if you would like to run or save the file.   
	![Picture 31](images/dp-3300-module-11-lab-31.png)
 

1. In the dialog, select the dropdown next to Save and choose Save As. 

	![Picture 32](images/dp-3300-module-11-lab-32.png)

 
1. Select the Windows Start button and type SSMS. Select Microsoft SQL Server Management Studio 18 from the list.  

	![Picture 34](images/dp-3300-module-11-lab-34.png)


2. When Management Studio opens, the Connect to Server dialog will be pre-populated to the local machine. Select the Connect button. 

	![Picture 35](images/dp-3300-module-11-lab-35.png)
 

3. In the Object Explorer, right-click on the Databases node and choose Restore Database…

	![Picture 36](images/dp-3300-module-11-lab-36.png)

 

4. In the Restore Database dialog, Select Device under Source, and select the button to the right of device labeled with an ellipsis. 

	![Picture 37](images/dp-3300-module-11-lab-37.png)



5. In the Select backup devices dialog, select Add. 

	![Picture 38](images/dp-3300-module-11-lab-38.png)


6. In the Local Backup File dialog, select AdventureWorksDW2017.bak and select the OK button. 

	![Picture 39](images/dp-3300-module-11-lab-39.png)

 
7. Verify that there is now one item listed under Backup media in the Select backup devices dialog. Then select the OK button.

	![Picture 40](images/dp-3300-module-11-lab-40.png)


8. Verify that there is one item listed under Backup sets to restore in the Restore Database dialog. Then select the OK button. 

	![Picture 41](images/dp-3300-module-11-lab-41.png)

 
9. Once the database restore completes, a dialog box will appear with the message "Database 'AdventureWorksDW2017' restored successfully". Select the OK button.

	![Picture 42](images/dp-3300-module-11-lab-42.png)

 

10. In the Object Explorer, expand the Databases node, then expand the AdventureWorksDW2017 node, then expand the Tables node. Verify that the database contains several tables including dbo.DimAccount.

	![Picture 43](images/dp-3300-module-11-lab-43.png)

 
11. In Management Studio, select the AdventureWorksDW2017 node in the Object Explorer. Then select the New Query button. 

	![Picture 44](images/dp-3300-module-11-lab-44.png)


12. Copy and paste the following statement into the new query window: 

	```SQL
	SELECT CalendarYear, Sum(SalesAmount) SalesAmount 

	FROM dbo.FactInternetSales FS

	INNER JOIN dbo.DimDate DD ON FS.OrderDateKey = DD.DateKey

	GROUP BY CalendarYear
	```

	![Picture 45](images/dp-3300-module-11-lab-45.png)


13. Select the Execute button execute the query. Verify that the sales amount for 2010 is **43421.0364**. 

	![Picture 46](images/dp-3300-module-11-lab-46.png)

 