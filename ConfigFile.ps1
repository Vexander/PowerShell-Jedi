Import-DscResource -Module xNetworking
Import-DscResource -module xDHCpServer
Import-DscResource -Module xComputerManagement 
Import-DscResource -Module xSqlServer
Import-DscResouece -Module xSmbShare
Import-DscREsource -Module xHyper-V

#region Hash Table Creation.
$ServerConfig = @{
    AllNodes = @(
        @{NodeName = "Aloe-2012-Dc1";      Role = "Domain-Controller";     ServerType = "VM"},
        @{NodeName = "Aloe-2012-Dc2";      Role = "Domain-Controller";     ServerType = "VM"},
        @{NodeName = "Aloe-2012-Prn1";     Role = "Print-Server";          ServerType = "VM"},
        @{NodeName = "Aloe-2012-Prn2";     Role = "Print-Server";          ServerType = "VM"},
        @{NodeName = "Aloe-2012-Sql1";     Role = "Sql-Server";            ServerType = "VM"},
        @{NodeName = "Aloe-2012-Mail";     Role = "Mail-Server";           ServerType = "VM"},
        @{NodeName = "Aloe-2012-Fs1";      Role = "File-Server";          ServerType = "VM"},
        @{NodeName = "Aloe-2012-Fs2";      Role = "File-Server";          ServerType = "VM"},
        @{NodeName = "Aloe-2012-Hv1";      Role = "HyperV-Host";           ServerType = "VM"},
        @{NodeName = "Aloe-2012-Hv2";      Role = "HyperV-Host";           ServerType = "VM"},
        @{NodeName = "Aloe-2012-Sw";       Role = "Managment-Server";      ServerType = "VM"},
        @{NodeName = "Aloe-2012-Ts1";      Role = "Terminal-Server";       ServerType = "VM"}
    );
} 
#endregion

#region Base Configuration
configuration BaseServer
{
    WindowsFeature Snmp
    {
        Ensure = "Present"
        Name = 'SNMP-Service'
    }

    WindowsFeature SnmpWmi
    {
        Ensure = "Present"
        Name = 'SNMP-WMI-Provider'
        DependsOn= '[WindowsFeature]snmp'
    }

    WindowsFeature DotNet45 
    {
        Ensure = "Present"
        Name = "NET-Framework-45-Core"
    }

    Registry IEEnhanchedSecurity
    {
        # When "Present" then "IE Enhanced Security" will be "Disabled"
        Ensure = "Present"
        Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
        ValueName = "IsInstalled"
        ValueType = "DWord"
        ValueData = "0"
    }

    # Disables Shutdown tracking (asking for a reason for shutting down the server)
    Script DisableShutdownTracking-LogEvent
    {
        SetScript = 
        {
            eventcreate /t INFORMATION /ID 7 /L APPLICATION /SO "DSC-Client" /D "Disabled Shutdown Tracking"
        }      
        TestScript = 
        {
            if ((Get-ItemProperty -Path 'HKLM:\\SOFTWARE\Policies\Microsoft\Windows NT\Reliability').ShutdownReasonOn -ne "0") 
            {
                $false
            } 
            else 
            {
                $true
            }
      }
        GetScript = 
        {
            # Do Nothing
        }
    }

    Registry DisableShutdownTracking
    {
      Ensure = "Present"
      Key = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows NT\Reliability"
      ValueName = "ShutdownReasonOn"
      ValueData = "0"
      ValueType = "Dword"
      Force = $true
    }
  
   # Verifies Windows Remote Management is Configured or Configures it
    Script EnableWinrm
    {
        SetScript = 
        {
            Set-WSManQuickConfig -Force -SkipNetworkProfileCheck
            eventcreate /t INFORMATION /ID 4 /L APPLICATION /SO "DSC-Client" /D "Enabled Windows Remote Management"
        }
        TestScript = 
        {
            try
            {
                # Use to remove a listener for testing
                # Remove-WSManInstance winrm/config/Listener -selectorset @{Address="*";Transport="http"}
                Get-WsmanInstance winrm/config/listener -selectorset @{Address="*";Transport="http"}
                return $true
            } 
            catch 
            {
                #$wsmanOutput = "WinRM doesn't seem to be configured or enabled."
                return $false
            }
        }
        GetScript = 
        {
            # Do Nothing
        }
    }

   # Enables remote desktop access to the server
    Registry EnableRDP-Step1
    {
        Ensure = "Present"
        Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server"
        ValueName = "fDenyTSConnections"
        ValueData = "0"
        ValueType = "Dword"
        Force = $true
    }

    Registry EnableRDP-Step2
    {
        Ensure = "Present"
        Key = "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
        ValueName = "UserAuthentication"
        ValueData = "1"
        ValueType = "Dword"
        Force = $true
    }

    Script EnableRDP
    {
        SetScript = 
        {
            Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
            eventcreate /t INFORMATION /ID 2 /L APPLICATION /SO "DSC-Client" /D "Enabled Remote Desktop access"
        }
        TestScript = 
        {
            if ((Get-NetFirewallRule -Name "RemoteDesktop-UserMode-In-TCP").Enabled -ne "True") 
            {
                $false
            } 
            else 
            {
                $true
            }
        }
        GetScript = 
        {
            # Do Nothing
        }
    }
}
#endregion

#region Install Service Desk Managment Agent
Configuration SDAgment {

   Package SCOMAgentPackage {
      Ensure = "Present"
      Name = "Microsoft Management Agent"
      Path = "C:\Installs\SCOM\Agent\MOMAgent.msi"
      Arguments = "USE_SETTINGS_FROM_AD=0 MANAGEMENT_GROUP=OM_Diginerve MANAGEMENT_SERVER_DNS=PDC-SC-OMMS01.diginerve.net ACTIONS_USE_COMPUTER_ACCOUNT=1 USE_MANUALLY_SPECIFIED_SETTINGS=1 SET_ACTIONS_ACCOUNT=1 AcceptEndUserLicenseAgreement=1"
      productId = "8B21425D-02F3-4B80-88CE-8F79B320D330"
      LogPath = "C:\Files\SCOMAgentInstallLog.txt"
      DependsOn = '[File]SCOMAgentInstaller'
   }
}
#endregion

#region HyperV Host Servers
Configuration HyperVHost
{
    WindowsFeature "UserInterface"
    {
        Name = "User-Interfaces-Infra"
        Ensure = "Absent"
    }

    WindowsFeature "Hyper-V"
    {
        Name = "Hyper-V"
        Ensure = "Present"
    }

    WindowsFeature "Hyper-V-Powershell" 
    {
        Ensure="Present"
        Name="Hyper-V-Powershell"
    }

File VMsDirectory 
{

Ensure = "Present"
Type = "Directory"
DestinationPath = "$($env:SystemDrive)\VMs"

}

xVMSwitch LabSwitch 
{
    DependsOn = "[WindowsFeature]Hyper-V"
    Name = "LabSwitch"
    Ensure = "Present"
    Type = "Internal"

}
}
#endregion

#region File Servers
Configuration FileServer
{
    WindowsFeature UserInterface
    {
        Name = "User-Interfaces-Infra"
        Ensure = "Absent"
    }

    WindowsFeature FileAndStorageServices
    {
        Name = "FileAndStorage-Services"
        Ensure = "Present"
    }

    WindowsFeature FileServices
    {
        Name = "File-Services"
        Ensure = "Present"
        DependsOn= "[WindowsFeature]FileAndStorage-Services"
    }

    WindowsFeature FSFileServer
    {
        Name = "FS-FileServer"
        Ensure = "Present"
        IncludeAllSubFeature = $false
        DependsOn= "[WindowsFeature]File-Services"
    }

    WindowsFeature FsDfsNamespace
    {
        Name = "FS-DFS-Namespace"
        Ensure = "Present"
        DependsOn= "[WindowsFeature]File-Services"
    }

    WindowsFeature FsDfsReplication
    {
        Name = "FS-DFS-Replication"
        Ensure = "Present"
        DependsOn= "[WindowsFeature]File-Services"
    }

    WindowsFeature FileServerResourceManager
    {
        Name = "File Server Resource Manager"
        Ensure = "Present"
        DependsOn= "[WindowsFeature]File-Services"
    }

    WindowsFeature StorageServices
    {
        Name = "Storage-Services"
        Ensure = "Present"
        DependsOn= "[WindowsFeature]FileAndStorage-Services"
    }

    xSmbShare AdminShare
    {
        Ensure = "present"
        Name   = "Admin Share"
        Path = "C:\DFSRoots\Departmental Shares\Admin" 
        Description = "This is a share provisioned for the Admin Department"         
    }
}
#endregion

#region Domain Controllers
Configuration DomainController1
{

# Remove the GUI
    WindowsFeature UserInterface
    {
        Name = "User-Interfaces-Infra"
        Ensure = "Absent"
    }

# Set a static Ip Address
    xIPAddress NewIPAddress
    {
        IPAddress      = "192.168.0.1"
        InterfaceAlias = "Ethernet"
        SubnetMask     = 24
        AddressFamily  = "IPV4"
     }

# Install ADDS
    WindowsFeature ADDSInstall
    { 
        Ensure = 'Present'
        Name = 'AD-Domain-Services'
        IncludeAllSubFeature = $true
    }

 #Install RSAT
    WindowsFeature RSATTools
    {
        DependsOn= '[WindowsFeature]ADDSInstall'
        Ensure = 'Present'
        Name = 'RSAT-AD-Tools'
        IncludeAllSubFeature = $true
    }

# DHCP  
    WindowsFeature DHCP 
    {
        DependsOn = '[xIPAddress]NewIpAddress'
        Name = 'DHCP'
        Ensure = 'PRESENT'
        IncludeAllSubFeature = $true                                                                                                                              
    }  
 
    WindowsFeature DHCPTools
    {
        DependsOn= '[WindowsFeature]DHCP'
        Ensure = 'Present'
        Name = 'RSAT-DHCP'
        IncludeAllSubFeature = $true
    }  
 
    xDhcpServerScope Scope
    {
        DependsOn = '[WindowsFeature]DHCP'
        Ensure = 'Present'
        IPEndRange = '192.168.0.250'
        IPStartRange = '192.168.0.15'
        Name = 'Aloe-Berea-Scope'
        SubnetMask = '255.255.255.0'
        LeaseDuration = '00:08:00'
        State = 'Active'
        AddressFamily = 'IPv4'
    } 
 
    xDhcpServerOption Option
    {
        Ensure = 'Present'
        ScopeID = '192.168.0.0'
        DnsDomain = 'AloeOffice.local'
        DnsServerIPAddress = '192.168.0.1'
        AddressFamily = 'IPv4'
    }

#DNS
}
#endregion
