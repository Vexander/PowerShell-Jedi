function Get-Errors {
	$servers = 'Aloe-2012-Dc1','Aloe-2012-Sql1'
	$logs = 'System','Security','Application'
	
	foreach ($server in $servers) {
    	foreach ($log in $logs) {
        	$results = @()
        	$events = Get-EventLog -LogName $LogName -After ([datetime]'01/05/2017 23:59:59') -Before 01/07/2017 -ComputerName $s -EntryType Error
	
			foreach ($Event in $Events) {
            	$ResultHash = @{
		        	'objEventDate'  = $Event.TimeGenerated
		        	'objDetails'     = ($Event.Message -split "`n")[0]
                	'objSource'   = $Event.Source
                	'objInstanceId'   = $Event.InstanceId
	        	}
	            $results += (New-Object PSObject -Property $ResultHash)
        	}
	    
			$emailbody = $results | Group-Object objDetails
        	Send-HTMLEmail -InputObject $emailBody -Subject $server " - " $log
        	$Results.Clear()
        	$Events.Clear()
    	}
	}
}

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