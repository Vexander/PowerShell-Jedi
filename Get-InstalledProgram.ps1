<<<<<<< HEAD
﻿<#PSScriptInfo

.VERSION 1.0.1

.GUID 46e23916-6dbe-4ad6-87d5-1a183df64758

.AUTHOR Chris Carter

.COMPANYNAME 

.COPYRIGHT 2016 Chris Carter

.TAGS InstalledPrograms PowerShellRemoting

.LICENSEURI http://creativecommons.org/licenses/by-sa/4.0/

.PROJECTURI https://gallery.technet.microsoft.com/Get-Programs-Installed-on-0e93f152

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES 


#>

<#
.SYNOPSIS
Gets the programs installed on a local or remote machine.
.DESCRIPTION
Get-InstalledProgram retrieves the programs installed on a local or remote machine. To specify a remote computer, use the ComputerName parameter. If the Name parameter is specified, the script gets information on any matching program's DisplayName property, and wildcards are permitted.

By default, the objects returned will only include the "DisplayName" and "DisplayVersion" properties of the installed program. This can be overridden by specifying the properties desired to the Property parameter, or all properties can be retrieved by using the All switch parameter.
.PARAMETER Name
The name of the installed program to get. Wildcards are accepted.
.PARAMETER Property
The name of the property or properties to get of the installed program. The keyword "All" can be used to retrieve all the properties of an installed program.
.PARAMETER ComputerName
Specifies the target computer to get installed programs from. Enter a fully qualified domain name, a NetBIOS name, or an IP address. When the remote computer is in a different domain than the local computer, the fully qualified domain name is required.
        
The default is the local computer. To specify the local computer, such as in a list of computer names, use "localhost", the local computer name, or a dot (.).

This parameter relies on Windows PowerShell remoting, which uses WS-Management, and the target computer must be configured to run WS-Management commands.
.PARAMETER All
Tells the script to get all properties of a returned object. 
.INPUTS
System.String

You can pipe System.String objects to Get-InstalledProgram of computers to target.
.OUTPUTS
PSCustomObject
.EXAMPLE
Get-InstalledProgram

This command will get all of the installed programs on the local computer.
.EXAMPLE
Get-InstalledProgram -ProgramName "Java 8*"

This command will get all of the installed programs whose DisplayName starts with "Java 8" on the local computer.
.EXAMPLE
"Server1","Server2" | Get-InstalledProgram -PN "Adobe Acrobat*"

This command will get all of the installed programs whose DisplayName starts with "Adobe Acrobat*" on the computers named Server1 and Server2.
.EXAMPLE
Get-InstalledProgram -ProgramName "Microsoft Office*" -Property DisplayName,DisplayVersion,Publisher,InstallLocation

This command will get all of the installed programs whose DisplayName starts with "Microsoft Office" on the local computer and will only return the DisplayName, DisplayVersion, Publisher, and InstallLocation properties of the PSCustomObject.
.EXAMPLE
Get-InstalledProgram -All

This command will get all of the installed programs on the local machine and return all of the properties retrieved by the command.
.NOTES
This script uses Get-ItemProperty and the Registry provider to retrieve keys from HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ on 32 and 64 bit computers. On 64 bit it also gets the keys from HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\.

Remote commands are run using Invoke-Command, so the remote computer must be set up for PowerShell remoting. Locally, Invoke-Command is not used due to the fact that in later versions of PowerShell running Invoke-Command on the local machine required the session to be running as an administrator.

Filtering properties is done using Select-Object.

.LINK
Get-ItemProperty
.LINK
Select-Object
.LINK
Invoke-Command
#>

#Requires -Version 2.0
[CmdletBinding(HelpURI='https://gallery.technet.microsoft.com/Get-Programs-Installed-on-0e93f152')]

Param(
    [Parameter(Position=0)]
    [Alias("ProgramName","PN")]
        [String[]]$Name,

    [Parameter(Position=1,ParameterSetName="UserDefined")]
        [String[]]$Property=@("DisplayName","DisplayVersion"),
    
    [Parameter(Position=2,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("CN")]
        [String[]]$ComputerName=$env:COMPUTERNAME,

    [Parameter(Mandatory=$true,ParameterSetName="All")]
        [Switch]$All
)

Begin {
    $ProgCmd = {
        Param($prog,$props)
        $programs = @()
        $Is64Bit = (Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq "64-bit"

        if ($prog) {
            if ($Is64Bit) {
                $tempProgs = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
                foreach ($tp in $tempProgs) {
                    if ($tp.DisplayName -like $prog) {$programs += $tp}
                }
            }
            else {
                $tempProgs = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
                foreach ($tp in $tempProgs) {
                    if ($tp.DisplayName -like $prog) {$programs += $tp}
                }
            }
        }
        else {
            if ($Is64Bit) {$programs += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*}
            else {$programs += Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*}
        }

        if ($props -eq "All" -or $props -contains "All" -or $All) {$programs}
        else {$programs | Select-Object -Property $props}
    }

    Function Choose-Invocation($ProgName, $CompName) {
        if ($CompName -eq "." -or $CompName -eq "localhost" -or $CompName -eq $env:COMPUTERNAME) {
            & $ProgCmd $ProgName $Property
        }
        else {Invoke-Command -ScriptBlock $ProgCmd -ArgumentList $ProgName,$Property -ComputerName $CompName}
    }

    Function Get-ProgramFromRegistry ($ProgName, $CompName) {
        if ($ProgName) {
            foreach ($n in $ProgName) {
                Choose-Invocation -ProgName $n -CompName $CompName
            }
        }
        else {
            Choose-Invocation -CompName $CompName
        }
    }
}

Process {
    foreach ($comp in $ComputerName) {
        Get-ProgramFromRegistry -ProgName $Name -CompName $comp
    }
=======
﻿<#PSScriptInfo

.VERSION 1.0.1

.GUID 46e23916-6dbe-4ad6-87d5-1a183df64758

.AUTHOR Chris Carter

.COMPANYNAME 

.COPYRIGHT 2016 Chris Carter

.TAGS InstalledPrograms PowerShellRemoting

.LICENSEURI http://creativecommons.org/licenses/by-sa/4.0/

.PROJECTURI https://gallery.technet.microsoft.com/Get-Programs-Installed-on-0e93f152

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES 


#>

<#
.SYNOPSIS
Gets the programs installed on a local or remote machine.
.DESCRIPTION
Get-InstalledProgram retrieves the programs installed on a local or remote machine. To specify a remote computer, use the ComputerName parameter. If the Name parameter is specified, the script gets information on any matching program's DisplayName property, and wildcards are permitted.

By default, the objects returned will only include the "DisplayName" and "DisplayVersion" properties of the installed program. This can be overridden by specifying the properties desired to the Property parameter, or all properties can be retrieved by using the All switch parameter.
.PARAMETER Name
The name of the installed program to get. Wildcards are accepted.
.PARAMETER Property
The name of the property or properties to get of the installed program. The keyword "All" can be used to retrieve all the properties of an installed program.
.PARAMETER ComputerName
Specifies the target computer to get installed programs from. Enter a fully qualified domain name, a NetBIOS name, or an IP address. When the remote computer is in a different domain than the local computer, the fully qualified domain name is required.
        
The default is the local computer. To specify the local computer, such as in a list of computer names, use "localhost", the local computer name, or a dot (.).

This parameter relies on Windows PowerShell remoting, which uses WS-Management, and the target computer must be configured to run WS-Management commands.
.PARAMETER All
Tells the script to get all properties of a returned object. 
.INPUTS
System.String

You can pipe System.String objects to Get-InstalledProgram of computers to target.
.OUTPUTS
PSCustomObject
.EXAMPLE
Get-InstalledProgram

This command will get all of the installed programs on the local computer.
.EXAMPLE
Get-InstalledProgram -ProgramName "Java 8*"

This command will get all of the installed programs whose DisplayName starts with "Java 8" on the local computer.
.EXAMPLE
"Server1","Server2" | Get-InstalledProgram -PN "Adobe Acrobat*"

This command will get all of the installed programs whose DisplayName starts with "Adobe Acrobat*" on the computers named Server1 and Server2.
.EXAMPLE
Get-InstalledProgram -ProgramName "Microsoft Office*" -Property DisplayName,DisplayVersion,Publisher,InstallLocation

This command will get all of the installed programs whose DisplayName starts with "Microsoft Office" on the local computer and will only return the DisplayName, DisplayVersion, Publisher, and InstallLocation properties of the PSCustomObject.
.EXAMPLE
Get-InstalledProgram -All

This command will get all of the installed programs on the local machine and return all of the properties retrieved by the command.
.NOTES
This script uses Get-ItemProperty and the Registry provider to retrieve keys from HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ on 32 and 64 bit computers. On 64 bit it also gets the keys from HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\.

Remote commands are run using Invoke-Command, so the remote computer must be set up for PowerShell remoting. Locally, Invoke-Command is not used due to the fact that in later versions of PowerShell running Invoke-Command on the local machine required the session to be running as an administrator.

Filtering properties is done using Select-Object.

.LINK
Get-ItemProperty
.LINK
Select-Object
.LINK
Invoke-Command
#>

#Requires -Version 2.0
[CmdletBinding(HelpURI='https://gallery.technet.microsoft.com/Get-Programs-Installed-on-0e93f152')]

Param(
    [Parameter(Position=0)]
    [Alias("ProgramName","PN")]
        [String[]]$Name,

    [Parameter(Position=1,ParameterSetName="UserDefined")]
        [String[]]$Property=@("DisplayName","DisplayVersion"),
    
    [Parameter(Position=2,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
    [Alias("CN")]
        [String[]]$ComputerName=$env:COMPUTERNAME,

    [Parameter(Mandatory=$true,ParameterSetName="All")]
        [Switch]$All
)

Begin {
    $ProgCmd = {
        Param($prog,$props)
        $programs = @()
        $Is64Bit = (Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq "64-bit"

        if ($prog) {
            if ($Is64Bit) {
                $tempProgs = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
                foreach ($tp in $tempProgs) {
                    if ($tp.DisplayName -like $prog) {$programs += $tp}
                }
            }
            else {
                $tempProgs = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*
                foreach ($tp in $tempProgs) {
                    if ($tp.DisplayName -like $prog) {$programs += $tp}
                }
            }
        }
        else {
            if ($Is64Bit) {$programs += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*}
            else {$programs += Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*}
        }

        if ($props -eq "All" -or $props -contains "All" -or $All) {$programs}
        else {$programs | Select-Object -Property $props}
    }

    Function Choose-Invocation($ProgName, $CompName) {
        if ($CompName -eq "." -or $CompName -eq "localhost" -or $CompName -eq $env:COMPUTERNAME) {
            & $ProgCmd $ProgName $Property
        }
        else {Invoke-Command -ScriptBlock $ProgCmd -ArgumentList $ProgName,$Property -ComputerName $CompName}
    }

    Function Get-ProgramFromRegistry ($ProgName, $CompName) {
        if ($ProgName) {
            foreach ($n in $ProgName) {
                Choose-Invocation -ProgName $n -CompName $CompName
            }
        }
        else {
            Choose-Invocation -CompName $CompName
        }
    }
}

Process {
    foreach ($comp in $ComputerName) {
        Get-ProgramFromRegistry -ProgName $Name -CompName $comp
    }
>>>>>>> 0f3c83aa9f59e04e820fe300a3e09b45f05b4953
}