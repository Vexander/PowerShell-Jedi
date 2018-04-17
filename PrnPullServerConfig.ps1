#requires -Version 4 -Modules PSDesiredStateConfiguration
#Create a hash table that contains all your shares.

Configuration PrintServer
{
    param
    (
        [Parameter(Mandatory = $true)] [string[]]$ComputerName,
        [Parameter(Mandatory = $true)] [string[]]$IpAddress
    )

    Import-DscResource -ModuleName 'xSmbShare'
    Import-DscResource -ModuleName 'xNetworking'
    Import-DscResource -ModuleName 'xPowerShellExecutionPolicy'
    Import-DscResource –ModuleName ’PSDesiredStateConfiguration'
       
    Node $ComputerName
    {
#region Configure the Network Card
        #xNetConnectionProfile ConfigureNicAlias
        #{
        #IPv4Connectivity = 'LocalNetwork'
        #InterfaceAlias = 'File Server Nic'
        #IPv6Connectivity ='Disconnected'
        #}
        
        #xIPAddress NicIpAddress
        #{
        #IPAddress = $IpAddress
        #SubnetMask = 24
        #AddressFamily = 'IPv4'
        #InterfaceAlias = 'File Server NIC'
        #}

        #xDefaultGatewayAddress DefaultGateway 
        #{
        #AddressFamily = 'IPv4'
        #InterfaceAlias = 'File Server NIC'
        #Address = '192.168.0.254'
        #}

        #xDNSServerAddress DnsServerIpAddress
        #{
        #Address = '192.168.0.1'
        #AddressFamily = 'IPv4'
        #InterfaceAlias = 'File Server NIC'
        #}
#endregion    

        #region Configure Firewall Rules
        # TODO:
        #endregion

#region Standard Server Configurations
        xPowerShellExecutionPolicy PSExecutionPolicy
        {
            ExecutionPolicy = 'Bypass'
        }

        WindowsFeature 'Snmp'
        {
            Ensure = 'Present'
            Name = 'SNMP-Service'
        }

        WindowsFeature 'SnmpWmi'
        {
            Ensure = 'Present'
            Name = 'SNMP-WMI-Provider'
            DependsOn = '[WindowsFeature]snmp'
        }

        WindowsFeature 'DotNet45' 
        {
            Ensure = 'Present'
            Name = 'NET-Framework-45-Core'
        }

        WindowsFeature PowerShell
        {
            Ensure = 'Present'
            Name = 'Powershell'
        }
    
        WindowsFeature DscService
        {
            Ensure = 'Present'
            Name = 'Dsc-Service'
        }
    
        WindowsFeature PowerShellWebAccess
        {
            Ensure = 'Present'
            Name = 'WindowsPowerShellWebAccess'
        }

        WindowsFeature WinRMIisExt
        {
            Ensure='Present'
            Name='WinRM-IIS-Ext'
        }
        WindowsFeature 'UserInterface'
        {
            Name = "User-Interfaces-Infra"
            Ensure = "Absent"
        }

#endregion

#region Install Windows Features for File Share
        
#endregion    
    }
}

# Computer list 
$ComputerName = 'Aloe-2012-Fs3'
$IpAddress = '192.168.0.6'

# Create the Computer.Meta.Mof in folder
FileServer -ComputerName $ComputerName -IpAddress $IpAddress -OutputPath 'C:\Users\Public\Documents\Dsc\Client-Config'
#endregion

# Rename config with GUID and Checksum
# Get the guid, that is is already assigned to the LCM.
$guid = Get-DscLocalConfigurationManager -CimSession $ComputerName | Select-Object -ExpandProperty ConfigurationID

# Specify source folder of configuration
$source = "C:\Users\Public\Documents\Dsc\Client-Config\$ComputerName.mof"
# Specify destination of the pull serververs config folder.
$dest = "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration\$guid.mof"
#Copy the config file with a new name.
Copy-Item -Path $source -Destination $dest
#Then on Pull server make checksum
New-DscChecksum $dest