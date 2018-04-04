<#
.SYNOPSIS
   <A brief description of the script>
.DESCRIPTION
   <A detailed description of the script>
.PARAMETER <paramName>
   <Description of script parameter>
.EXAMPLE
   <An example of using the script>
#>

$UserCredential = Get-Credential
Set-ExecutionPolicy RemoteSigned
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$UpdateDetails = Import-Csv C:\Users\adm-rhys\Desktop\ExchangeOnlineUpdate.csv

foreach ($detail in $UpdateDetails) {
    $Manager = Get-user $detail.Manager
    Get-User -Identity $detail.accountname | Set-User -WebPage 'http://www.aloesolutions.co.za' -City $detail.CITY -Company $detail.COMPANY -CountryOrRegion $detail.COUNTRY -Office $detail.OFFICE -Department $detail.DEPARTMENT -Fax $detail.FAX -FirstName $detail.FIRSTNAME -LastName $detail.LASTNAME -Manager $Manager.Id -Phone $detail.PHONE -PostalCode $detail.POSTALCODE -StateOrProvince $detail.STATE -StreetAddress $detail.StreetAddress -Title $detail.TITLE -MobilePhone $detail.MOBILEPHONE 
    $detail.accountname
    $detail.TITLE
    $user = Get-User -Identity $detail.accountname
    $user
}
