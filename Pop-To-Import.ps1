#---------------------------------------------------------[Initialisations]--------------------------------------------------------

#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. "C:\Users\adm-rgottwald\Documents\WindowsPowerShell\Scripts\Logging_Functions.ps1"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Log File Info
$sLogPath = "C:\Logs"
$sLogName = "PopToImport.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#-----------------------------------------------------------[Functions]-----------------------------------------------------------

function Random-String {
    <#
    .Synopsis
       Generates a Random Number
    .DESCRIPTION
       Long description
    .EXAMPLE
       Random-String -Length 12
    .INPUTS
       System.Int32
    .OUTPUTS
       System.String
    .NOTES
       General notes
    #>
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [int]$Length
    )

    $set    = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
        $result += $set | Get-Random
    }
    return $result
}

function Count-Messages {
    <#
    .Synopsis
       Count emails sent to the FMAudit Server
    .DESCRIPTION
       Long description
    .EXAMPLE
       Count-Messages -Credential $cred -objMessages $Messages
    .INPUTS
       System.Management.Automation.PSCredential
       System.Object[]
    .OUTPUTS
       System.Int32
    .NOTES
       General notes
    #>
    Param
    (
        # The username of the email box to query.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]$Credential,

        # The username of the email box to query.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        $objMessages
    )
        [int]$Count = 0

        foreach ($message in $objMessages.value) { 
            # Get attachment on the email.
            $query = $url + "/" + $message.Id + "/attachments" 
            $attachments = Invoke-RestMethod  -Uri $query -Credential $cred 

            foreach ($attachment in $attachments.value) 
            { 
                # If the attachments name is 'Data.fma' save the file with a random name to the import folder
                if ($attachment.Name -eq "Data.fma") {
                    $Count++
                }
            } 
        } 

        Return $Count
}

function FMAudit-Import {
<#
    .Synopsis
        Get email attachments sent to the FMAudit email account
    .DESCRIPTION
        Long description
    .EXAMPLE
        FMAudit-Import -sUsername xxx@yyy.onmicrosoft.com -sPassword zzzzzzzz
    .EXAMPLE
        FMAudit-Import -sUsername xxx@yyy.onmicrosoft.com -sPassword zzzzzzzz -$sImportPath c:\inetpub\wwwroot\Fmacentral\Imports
    .INPUTS
        System.String
    .NOTES
        General notes
#>

    [CmdletBinding()]
    [Alias()]
    Param
    (
        # The username of the email box to query.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$sUsername,

        # The username of the email box to query.
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$sPassword,

        # The folder to save the file to.
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [string]$sImportPath = "\\aloe-2016-web\Imports\"
    )

    Begin { 
        Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
     }

    Process {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            Try {
                $password = ConvertTo-SecureString $sPassword -AsPlainText -Force 
                $cred = New-Object System.Management.Automation.PSCredential $sUsername, $password
                $url = "https://outlook.office365.com/api/v1.0/me/messages" 
                $messageQuery = "" + $url + "?`$select=Id&`$filter=HasAttachments eq true"

                # Get a list of the emails with attachments in the mailbox.
                $messages = Invoke-RestMethod  -Uri $messageQuery -Credential $cred 

                # Count the emails that are in the Mail Box.
                $iCount = 0
                $iCount = Count-Messages -Credential $cred -objMessages $messages

                # Loop through the emails retrieved above.
                $cCount = 1
                foreach ($message in $messages.value) 
                { 
                    # Get attachment on the email.
                    $query = $url + "/" + $message.Id + "/attachments" 
                    $attachments = Invoke-RestMethod  -Uri $query -Credential $cred 

                    # In case of multiple attachments in email, loop through the attachments. 
                    foreach ($attachment in $attachments.value) 
                    { 
                        # If the attachments name is 'Data.fma' save the file with a random name to the import folder
                        if ($attachment.Name -eq "Data.fma") {
                            # Start Logging and Verbose.
                            Log-Write -LogPath $sLogFile -LineValue "Processeing email $cCount of $iCount..."
                            Write-Verbose -Message "Processeing email $cCount of $iCount..."
                            # End Logging and Verbose.

                            $randomstring = Random-String 12
                            $path = $sImportPath + "\" + $randomstring + ".fma"
                            
                            # Start Logging and Verbose.
                            Log-Write -LogPath $sLogFile -LineValue "Exporitng attachment..."
                            Write-Verbose -Message "Exporitng attachment..."
                            # End Logging and Verbose.

                            $Content = [System.Convert]::FromBase64String($attachment.ContentBytes) 
                            Set-Content -Path $path -Value $Content -Encoding Byte 

                            # Start Logging and Verbose.
                            Log-Write -LogPath $sLogFile -LineValue "Deleting email $cCount of $iCount..."
                            Write-Verbose -Message "Deleting email $cCount of $iCount..."
                            # End Logging and Verbose.
                            
                            # Delete the email.
                            $queryDelete = $url + "/" + $message.Id
                            Invoke-RestMethod -Uri $queryDelete -Method Delete -Credential $cred

                            # Start Logging and Verbose.
                            Log-Write -LogPath $sLogFile -LineValue "Completed processing email $cCount of $iCount."
                            Write-Verbose -Message "Completed processing email $cCount of $iCount."
                            # End Logging and Verbose.

                            $cCount++
                        } # End If
                    } # End ForEach
                } # End ForEach
            }# End Try
            
            Catch {
                Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
                Break
            }# End Catch
        }
    }

    End {
        If($?){
          Log-Write -LogPath $sLogFile -LineValue "Completed Successfully."
          Log-Write -LogPath $sLogFile -LineValue " "
          Log-Finish -LogPath $sLogFile
        } # End If
    }
}

FMAudit-Import -sUsername xerox@aloesolutions.co.za -sPassword Topo9400