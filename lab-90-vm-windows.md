# Lab - Virtual Machine setup

## Lab overview

Students will create a virtual machine in Azure that will include tooling to perform lab exercises.


## Exercise 1: Create an Azure Virtual Machine




# 01 - Create a virtual machine in the portal (10 min)

In this walkthrough, we will create a virtual machine in the Azure portal, and connect to the virtual machine. 


# Task 1: Create the virtual machine 
1. Sign-in to the Azure portal: **https://portal.azure.com**

3. From the **All services** blade in the Portal Menu, search for and select **Virtual machines**, and then click **+Add, +Create, +New** and choose **+Virtual machine** from the drop down.

4. On the **Basics** tab, fill in the following information (leave the defaults for everything else):

    | Settings | Values |
    |  -- | -- |
    | Subscription | **Use default supplied** |
    | Resource group | **Create new resource group: Sql2019** |
    | Virtual machine name | **Sql2019** |
    | Region | **West Europe**|
    | Availability options | No infrastructure redundancy options required|
    | Image | **SQL 2019 on Windows Server 2019 Datacenter**|
    | Size | **Standard D2s v3**|
    | Administrator account username | **azureuser** |
    | Administrator account password | **Pa$$w0rd1234**|
    | Inbound port rules - | **Allow select ports **|
    | Select inbound ports | **RDP (3389)** | 

7. Leave the remaining values on the defaults and then click the **Review + create** button at the bottom of the page.

8. Once Validation is passed click the **Create** button. It can take several minutes to deploy the virtual machine.

9. You will receive updates on the deployment page and via the **Notifications** area (the bell icon in the top menu bar).


# Task 2: Connect to the virtual machine

In this task, we will connect to our new virtual machine using RDP (Remote Desktop Protocol). 

1. Click on bell icon from the upper blue toolbar, and select 'Go to resource' when your deployment has succeded. 

    **Note**: You could also use the **Go to resource** link on the deployment page 

2. On the virtual machine **Overview** blade, click **Connect** button and choose **RDP** from the drop down.

    ![Screenshot of the virtual machine properties with the Connect button highlighted.](../Linked_Image_Files/0101.png)

    **Note**: The following directions tell you how to connect to your VM from a Windows computer. On a Mac, you need an RDP client such as this Remote Desktop Client from the Mac App Store and on a Linux computer you can use an open source RDP client.

2. On the **Connect to virtual machine** page, keep the default options to connect with the public IP address over port 3389 and click **Download RDP File**. A file will download on the bottom left of your screen.

3. **Open** the downloaded RDP file (located on the bottom left of your lab machine) and click **Connect** when prompted. 

    ![Screenshot of the virtual machine properties with the Connect button highlighted. ](../Linked_Image_Files/0102.png)

4. In the **Windows Security** window, sign in using the Admin Credentials you used when creating your VM **azureuser** and the password **Pa$$w0rd1234**. 

5. You may receive a warning certificate during the sign-in process. Click **Yes** or to create the connection and connect to your deployed VM. You should connect successfully.

    ![Screenshot of the Certificate warning dialogue informing the user of an untrusted certificate, with the Yes button highlighted. ](../Linked_Image_Files/0104.png)

A new Virtual Machine (Sql2019) will launch inside your Lab. Close the Server Manager and dashboard windows that pop up (click "x" at top right). You should see the blue background of your virtual machine. **Congratulations!** You have deployed and connected to a Virtual Machine running Windows Server and SQL Server. 


**Congratulations!** You have created a new VM running a web server that is accessible via its public IP address. If you had a web application to host, you could deploy application files to the virtual machine and host them for public access on the deployed virtual machine.






Install Data Studio
https://go.microsoft.com/fwlink/?linkid=2183280
