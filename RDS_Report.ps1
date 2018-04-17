<#
.SYNOPSIS
   This script will search a servers log file for any external IP addresses and emails the results to the administrator.
.DESCRIPTION
   
.PARAMETER Server
   
.PARAMETER ReportPeriod
   
.EXAMPLE
   Get-RemoteConnections -server "Aloe-2012-Dc1","Aloe-2012-Sql1","Aloe-2012-Mail","Aloe-2012-Fs1","Aloe-2012-Hv1","Aloe-2008-Ts1" -ReportPeriod 1
#>

function Get-ErrorEvents {
	[CmdletBinding()] 
     param(
	 	[Parameter(Mandatory=$True, 
                   Position = 0, 
                   ValueFromPipeline=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   HelpMessage="Please the name of the servers to check.")] 
        [string[]]$Server,
		[Parameter(Mandatory=$True, 
                   Position = 0, 
                   ValueFromPipeline=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   HelpMessage="Please enter the period to report ovrer.")] 
        [int]$ReportPeriod
	)
   	begin { }
    process 
    {
		if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
			foreach ($s in $server) {
				$LogName = 'Microsoft-Windows-TerminalServices-LocalSessionManager/Operational'
				$Results = @()
				$Events = Get-WinEvent -LogName $LogName -ComputerName $s
				# Cycle through the event log.
				Write-Verbose "Compiling evnet XML object."	
				$Today = Get-Date
				foreach ($Event in $Events) {
					$EventXml = [xml]$Event.ToXML()
					$DateDiff = NEW-TIMESPAN –Start $Today –end $Event.TimeCreated
					$ResultHash = @{
						Time        = $Event.TimeCreated.ToString()
						Diff        = $DateDiff.Days
						'Desc'      = ($Event.Message -split "`n")[0]
						UserName    = $EventXml.Event.UserData.EventXML.User
						'Source IP' = $EventXml.Event.UserData.EventXML.Address
					}
					Write-Verbose "Filtering events."
					$Ip = $ResultHash.'Source IP' | Out-String
					if ($Ip -notlike '192.168.0.*') {
						if ($Ip) {
							if ($DateDiff.Days -gt -$ReportPeriod) {
								$Results += (New-Object PSObject -Property $ResultHash)
							}
						}
					}
				}
				
				if ($Results) {
					Write-Verbose "Email Results."
					Send-HTMLEmail -InputObject $Results  -Subject $s
				}
			}
    	}
	}
    end { }
}#Get-RemoteConnections

function Send-HTMLEmail { 
    #Requires -Version 2.0 
    [CmdletBinding()] 
     param  
       ([Parameter(Mandatory=$True, 
                   Position = 0, 
                   ValueFromPipeline=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   HelpMessage="Please enter the Inputobject")] 
        $InputObject, 
        [Parameter(Mandatory=$True, 
                   Position = 1, 
                   ValueFromPipeline=$true, 
                   ValueFromPipelineByPropertyName=$true, 
                   HelpMessage="Please enter the Subject")] 
        [String]$Subject,     
        [Parameter(Mandatory=$False, 
                   Position = 2, 
                   HelpMessage="Please enter the To address")]     
        [String[]]$To = "rhys@aloesolutions.co.za", 
        [String]$From = "xerox@aloesolutions.co.za",     
        [String]$SmtpServer ="192.168.0.11" 
       )#End Param 
 
if (!$CSS) 
{ 
# Please use the download link to get the CSS it may not display correctly here.     
$CSS = @" 

<style>         
            table { 
            font-family: Verdana; 
            border-style: dashed; 
            border-width: 1px; 
            border-color: #FF6600; 
            padding: 5px; 
            background-color: #FFFFCC; 
            table-layout: auto; 
            text-align: left; 
            font-size: 8pt; 
            width=100%
            } 
 
            table th { 
            border-bottom-style: solid; 
            border-bottom-width: 1px; 
            font: bold 
            text-align: center; 
            } 
            table td { 
            border-top-style: solid; 
            border-top-width: 1px; 
            } 
            .style1 { 
            font-family: Courier New, Courier, monospace; 
            font-weight:bold; 
            font-size:small; 
            } 
</style>             
"@ 
}#End if 
      


    $HTMLDetails = @{ 
        Title = $Subject
        Head = $CSS 
        } 
     
    $Splat = @{ 
        To         =$To 
        Body       ="$($InputObject | ConvertTo-Html @HTMLDetails)" 
        Subject    =$Subject 
        SmtpServer =$SmtpServer 
        from       =$From 
        BodyAsHtml =$True 
        } 
        Send-MailMessage @Splat 
     
}#Send-HTMLEmail

Get-RemoteConnections -server "Aloe-2012-Dc1","Aloe-2012-Sql1","Aloe-2012-Mail","Aloe-2012-Fs1","Aloe-2012-Hv1","Aloe-2008-Ts1" -ReportPeriod 1