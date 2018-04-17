#set static IP address 
$ipaddress = “192.168.20.1” 
$ipprefix = “24” 
$ipgw = “192.168.20.254” 
$ipdns = “192.168.20.1” 
$ipif = (Get-NetAdapter).ifIndex 
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -InterfaceIndex $ipif -DefaultGateway $ipgw 

#rename the computer 
$newname = 'test-2012-dc1' 
Rename-Computer -NewName $newname -force 

#install features 
$featureLogPath = “c:\temp\featurelog.txt” 
New-Item $featureLogPath -ItemType file -Force 
$addsTools = 
Add-WindowsFeature $addsTools 
Get-WindowsFeature | Where installed >>$featureLogPath 

#restart the computer 
Restart-Computer