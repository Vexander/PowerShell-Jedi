#######################################################
##
## Create-New-Vm-Server.ps1, v0.8, 2016
##
## Created by Rhys Gottwald
##
#######################################################
 
<#
.SYNOPSIS
    Creates a new VM and configures it as a File Server.
 
.DESCRIPTION
 
.PARAMETER HyperVServer
    The name of your Hyper-V Server that you want to create the VM on.

.PARAMETER VMName
    The Name of the new VM you want create.
 
.PARAMETER VmMemory
    The minimum amount of memory to use on this VM.

.PARAMETER VHDSize
    The size of the Virtual Hard Drive for the new VM.

.PARAMETER SwitchName
    The name of the Virtual Switch that this VM must use.

.EXAMPLE
 
.EXAMPLE
 
.INPUTS
 
.OUTPUTS

 
.NOTES
There is a problem running SYSPREP.  Cannot log on to server.
Cannot add server to domain remotley, but I have only tried once.
Last line has not been tested.

#>
<#
        1. Copy the standard Disk. - Done
        2. Resize the disk. - Done
        3. Resize the RAM - Done
        4. Start the VM. - Done
        6. Add the new VM to the Domain. - Done
        7. Create the Folders.
        8. Share the new the folders.
        9. Copy existing files form old server.
#>

Function CreateVm
{
    Param
    (
        [Parameter(Mandatory=$true)] [string]$HyperVServer,
        [Parameter(Mandatory=$true)] [string]$VMName,
        [Parameter(Mandatory=$true)] [string]$VmMemory = 512MB,
        [Parameter(Mandatory=$true)] [string]$VHDSize,
        [Parameter(Mandatory=$true)] [string]$SwitchName
    )

    #Constants
	$TemplateDiskPath = 'F:\Templates\Windows Server 2012 R2.vhdx'
    $LocalCred = Get-Credential -Credential "LOCAL-ADMIN-INFO"
    $DomainCred = Get-Credential -Credential "DOMAIN-ADMIN-INFO"

	# Variabels built from parameters.
	$LiveDiskPath = "F:\$VMName.vhdx"

    #Copy the standard HDD to the VDisk folder and rename it
    Import-VM -Path "F:\Templates\Aloe-2012-Srv\Virtual Machines\9D6B774F-4974-4454-8BD8-14A38F5A6EC8.XML" -ComputerName $HyperVServer

    #Add the new VM to an Object.
    $objNewVm = Get-VM -ComputerName $HyperVServer -Name $VMName

    #Resize the VDisk.
    Resize-VHD -ComputerName $HyperVServer -Path "F:\$VMName.vdhx" -SizeBytes 750GB

    #Resize the VM's RAM
    Set-VMMemory -VMName $objNewVm.Name -ComputerName $HyperVServer -DynamicMemoryEnabled $true -MinimumBytes 512MB

	#Start the new VM
    Start-VM -ComputerName $HyperVServer -Name $objNewVm.Name
    
    #Wait for the VM to start.
    do 
    {
        Start-Sleep -Milliseconds 100
    } 
    until ((Get-VMIntegrationService -ComputerName $objNewVm.Name | Where-Object -FilterScript {$_.name -eq 'Heartbeat'}).PrimaryStatusDescription -eq 'OK')

    # Problem 1 #
	#Run Sysprep.
 	Invoke-Command -ComputerName aloe-2012-srv -ScriptBlock {Invoke-Expression 'C:\Windows\System32\Sysprep\Sysprep.exe /generalize /oobe /reboot /quiet'} -Credential administrator@aloe-2012-srv

    # Problem 2 #
    #Add the VM to the domain and rename it.
    Add-Computer -DomainName $domain -Credential $DomainCred -ComputerName $objNewVm.ComputerName -NewName $NewVm -Options JoinWithNewName, AccountCreate -LocalCredential $LocalCred -OUPath 'OU=File Servers,OU=Windows Servers,OU=Member Servers,DC=AloeOffice,DC=local' -Force
    
	#Reboot the VM.
    Restart-VM -Name $objNewVm.ComputerName -ComputerName $HyperVServer

    #Recreate the NewVm Object.
    $objNewVm = Get-VM -ComputerName $HyperVServer -Name $VMName
	    
    #Wait for the VM to start.
    do 
    {
        Start-Sleep -Milliseconds 100
    } 
    until ((Get-VMIntegrationService -ComputerName $objNewVm.Name | Where-Object -FilterScript {$_.name -eq 'Heartbeat'}).PrimaryStatusDescription -eq 'OK')

    Invoke-Command  C:\users\public\Documents\File-Server-Folders.ps1 -VMName $objNewVm.ComputerName -Credential $DomainCred 
}
