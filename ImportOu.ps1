Function Impot_Ou
{
    $StrOU = Import-Csv $strOUTree

    $StrOU | foreach {
        $DN=$_.DistinguishedName
        $OUName="OU="+$_.Name+","
        $OUParent=$DN -replace $OUName,""
        Try {
            Write-Host "Processing OU Object " $DN
            New-ADOrganizationalUnit -Name $_.name -Path $OUParent
            }
        Catch
        {
            write-host "Already exsits or Error found..:" $_ -fore Red
        }

    }
}