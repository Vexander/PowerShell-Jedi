#Install AD DS, DNS and DHCP 
$featureLogPath = “c:\temp\featurelog.txt” 
start-job -Name addFeature -ScriptBlock { 
Add-WindowsFeature -Name “ad-domain-services” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “dns” -IncludeAllSubFeature -IncludeManagementTools 
Add-WindowsFeature -Name “dhcp” -IncludeAllSubFeature -IncludeManagementTools } 
Wait-Job -Name addFeature 
Get-WindowsFeature | Where installed >>$featureLogPath

# Create New Forest, add Domain Controller 
$domainname = “aloe-test.local” 
$netbiosName = “ALOE-TEST” 
Import-Module ADDSDeployment 
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainMode 'Win2012' -DomainName $domainname -DomainNetbiosName $netbiosName -ForestMode 'Win2012' -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoRebootOnCompletion:$false -SysvolPath 'C:\Windows\SYSVOL' -Force:$true