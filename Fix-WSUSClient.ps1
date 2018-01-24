<#
.SYNOPSIS
   Fixes client settings for WSUS agent on Windows Workstations
.DESCRIPTION
   <A detailed description of the script>
.EXAMPLE
   Fix-WSUSClient
#>

Function Fix-WSUSClient {
	get-service wuauserv | Stop-Service -Force
	get-service cryptSvc | Stop-Service -Force
	get-service bits | Stop-Service -Force
	get-service msiserver | Stop-Service -Force
	
	if (Test-Path -Path C:\Windows\SoftwareDistribution) {
		If (Test-Path -Path C:\Windows\SoftwareDistribution.bak) {
			Remove-Item -Path C:\Windows\SoftwareDistribution.bak -Force
		}
		
		Rename-Item C:\Windows\SoftwareDistribution SoftwareDistribution.bak
	}
	
	if (Test-Path -Path C:\Windows\System32\catroot2) {
		If (Test-Path -Path C:\Windows\System32\catroot2.bak) {
			Remove-Item -Path C:\Windows\System32\catroot2.bak -Force
		}
		
		Rename-Item C:\Windows\System32\catroot2 catroot2.bak
	}
	
	Get-Item -Path HKLM:Software\Microsoft\Windows\CurrentVersion\WindowsUpdate | Remove-Item -Recurse -Verbose
	Get-Item -Path ("$Env:ALLUSERSPROFILE\Application Data\Microsoft\Network\Downloader") -Filter qmgr*.dat | Remove-Item  -Verbose
	
	Start-Process -FilePath sc -ArgumentList ('sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)')
	Start-Process -FilePath sc -ArgumentList ('sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)')
	
	$dlls = "atl.dll", "urlmon.dll", "mshtml.dll", "shdocvw.dll", "browseui.dll", "jscript.dll", "vbscript.dll", "scrrun.dll", "msxml.dll", "msxml3.dll", "msxml6.dll", 
	"actxprxy.dll", "softpub.dll", "wintrust.dll", "dssenh.dll", "rsaenh.dll", "gpkcsp.dll", "sccbase.dll", "slbcsp.dll", "cryptdlg.dll", "oleaut32.dll", "ole32.dll", "shell32.dll",
	" initpki.dll", "wuapi.dll", "wuaueng.dll", "wuaueng1.dll", "wucltui.dll", "wups.dll", "wups2.dll", "wuweb.dll", "qmgr.dll", "qmgrprxy.dll", "wucltux.dll", "muweb.dll", "wuwebv.dll"
	
	foreach ($dll in $dlls) {
		$dll
		Start-Process -FilePath regsvr32.exe -ArgumentList $dll
	}
	
	Start-Process -FilePath netsh -ArgumentList 'winsock reset'

	get-service wuauserv | Start-Service
	get-service cryptSvc | Start-Service
	get-service bits | Start-Service
	get-service msiserver | Start-Service
	
	Start-Process -FilePath wuauclt -ArgumentList ('/resetauthorization', '/detectnow ')
	Start-Process -FilePath wuauclt -ArgumentList ('/reportnow')
}