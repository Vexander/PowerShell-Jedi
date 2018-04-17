#requires -Version 4 -Modules PSDesiredStateConfiguration
#Create a hash table that contains all your shares.
$Shares = 
@(
    @{
        Name            = 'Templates Share'
        Path            = 'C:\DfsRoots\Templates Share'
        ChangeAccess    = 'Aloe-Templates-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Templates-Share-R'
    }, 
    @{
        Name            = 'Public Share'
        Path            = 'C:\DfsRoots\Public Share'
        ChangeAccess    = 'Aloe-Public-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Public-Share-R'
    }, 
    @{
        Name            = 'Admin Share'
        Path            = 'C:\DfsRoots\Department Shares\Admin Share'
        ChangeAccess    = 'Aloe-Admin-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Admin-Share-R'
    }, 
    @{
        Name            = 'Facilities Managment'
        Path            = 'C:\DfsRoots\Department Shares\Facilities Management'
        ChangeAccess    = 'Aloe-Facilities-Managment-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Facilities-Managment-R'
    }, 
    @{
        Name            = 'Finance Share'
        Path            = 'C:\DfsRoots\Department Shares\Finance Share'
        ChangeAccess    = 'Aloe-Finance-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Finance-Share-R'
    }, 
    @{
        Name            = 'Human Resources Share'
        Path            = 'C:\DfsRoots\Department Shares\Human Resources Share'
        ChangeAccess    = 'Aloe-Human-Resources-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Human-Resources-Share-R'
    }, 
    @{
        Name            = 'Information Technology Share'
        Path            = 'C:\DfsRoots\Department Shares\Information Technology Share'
        ChangeAccess    = 'Aloe-Information-Technology-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Information-Technology-Share-R'
    }, 
    @{
        Name            = 'Information Technology Installs'
        Path            = 'C:\DfsRoots\Department Shares\Information Technology Installs'
        ChangeAccess    = 'Aloe-Information-Technology-Installs-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Information-Technology-Installs-R'
    }, 
    @{
        Name            = 'Operations Share'
        Path            = 'C:\DfsRoots\Department Shares\Operations Share'
        ChangeAccess    = 'Aloe-Operations-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Operations-Share-R'
    }, 
    @{
        Name            = 'Sales Share'
        Path            = 'C:\DfsRoots\Department Shares\Sales Share'
        ChangeAccess    = 'Aloe-Sales-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Sales-Share-R'
    }, 
    @{
        Name            = 'Service Share'
        Path            = 'C:\DfsRoots\Department Shares\Service Share'
        ChangeAccess    = 'Aloe-Service-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Service-Share-R'
    }, 
    @{
        Name            = 'Stores Share'
        Path            = 'C:\DfsRoots\Department Shares\Stores Share'
        ChangeAccess    = 'Aloe-Stores-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Stores-Share-R'
    }, 
    @{
        Name            = 'Technical Share'
        Path            = 'C:\DfsRoots\Department Shares\Technical Share'
        ChangeAccess    = 'Aloe-Technical-Share-W'
        Description     = ''
        Ensure          = 'Present'
        EnumerationMode = 'AccessBased'
        ReadAccess      = 'Aloe-Technical-Share-R'
    }
)

Configuration FileServer
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
        #WindowsFeature 'UserInterface'
        #{
        #Name = "User-Interfaces-Infra"
        #Ensure = "Absent"
        #}

#endregion

#region Install Windows Features for File Share
        WindowsFeature FileAndStorageServices
        {
            Name = 'FileAndStorage-Services'
            Ensure = 'Present'
        }

        WindowsFeature FileServices
        {
            Name = 'File-Services'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileAndStorageServices'
        }

        WindowsFeature FSFileServer
        {
            Name = 'FS-FileServer'
            Ensure = 'Present'
            IncludeAllSubFeature = $false
            DependsOn = '[WindowsFeature]FileServices'
        }

        WindowsFeature FsDataDeduplication
        {
            Name = 'FS-Data-Deduplication'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileServices'
        }

        WindowsFeature FsDfsNamespace
        {
            Name = 'FS-DFS-Namespace'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileServices'
        }

        WindowsFeature FsDfsReplication
        {
            Name = 'FS-DFS-Replication'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileServices'
        }

        WindowsFeature FsResourceManager
        {            Name = 'FS-Resource-Manager'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileServices'
        }
    
        WindowsFeature FsVssAgent
        {
            Name = 'FS-VSS-Agent'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileServices'
        }

        WindowsFeature StorageServices
        {
            Name = 'Storage-Services'
            Ensure = 'Present'
            DependsOn = '[WindowsFeature]FileAndStorageServices'
        }
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
New-DscChecksum $dest -Force
