[DSCLocalConfigurationManager()]
Configuration LcmHttpPull 
{
    param
    (
        [Parameter(Mandatory=$true)] [string[]]$ComputerName,
        [Parameter(Mandatory=$true)] [string]$guid
    ) 
         	
	Node $ComputerName
    {
	    Settings
        {
		    AllowModuleOverwrite = $True
            ConfigurationMode = 'ApplyAndAutoCorrect'
			RefreshMode = 'Pull'
			ConfigurationID = $guid
            ConfigurationModeFrequencyMins = 15 
            RebootNodeIfNeeded = $false
        }

        ConfigurationRepositoryWeb DscHttp
        {
            ServerURL = 'http://aloe-2012-dsc:8080/PSDSCPullServer.svc'
            AllowUnsecureConnection = $true
            RegistrationKey = $guid
        }

        PartialConfiguration StandardHVSettings
        {
            Description = 'Configuration for the Base OS'
            ConfigurationSource = '[ConfigurationRepositoryWeb]DscHttp'
            RefreshMode = 'Pull'
        }
           PartialConfiguration HyperVServer
        {
            Description = 'Configuration for the Hyper-V Server'
            DependsOn = '[PartialConfiguration]StandardSettings'
            ConfigurationSource = '[ConfigurationRepositoryWeb]DscHttp'
            RefreshMode = 'Pull'
        }
        PartialConfiguration GuestConfig
        {
            Description = 'Configuration for the Hyper-V Guest Systems'
            DependsOn = '[PartialConfiguration]HyperVConfig'
            ConfigurationSource = '[ConfigurationRepositoryWeb]DscHttp'
            RefreshMode = 'Pull'
        }
	}
}

$ComputerName='aloe-2012-Hv2'
$guid='a9973087-2d40-4495-99da-1594052e00bf'

LcmHttpPull -ComputerName $ComputerName -guid $guid -OutputPath 'C:\Users\Public\Documents\Dsc\Client-Config'

Set-DSCLocalConfigurationManager -Path 'C:\Users\Public\Documents\Dsc\Client-Config' -ComputerName $ComputerName -Verbose

