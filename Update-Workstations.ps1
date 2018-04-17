$filepath = 'C:\temp\_Computers.csv'
$NetworkCredential = Import-CliXml 'C:\temp\SecureCredentials.xml'

Import-CSV $filepath -Header CurrentName,NewName,Description,user | Foreach-Object{
    Get-ADComputer -Identity $_.CurrentName | Set-ADComputer -Description $_.Description
    if(Test-Connection -ComputerName $_.CurrentName -Count 2 -Quiet){
        Try{
            if(!($_.CurrentName -eq $_.NewName)){
                # Rename the computer
                $_.CurrentName.Rename($_.NewName,$NetworkCredential.GetNetworkCredential().Password,$NetworkCredential.Username)
            }
            $OSValues = Get-WmiObject -class Win32_OperatingSystem -computername $_.CurrentName
            $OSValues.Description = $_.Description
            $OSValues.put()
        }
        catch{}
    }
}