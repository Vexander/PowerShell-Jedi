function Show-Menu
{
     param (
           [string]$Title = 'My Menu'
     )

     cls
    Write-Host '================ $Title ================'
     
    Write-Host '1: Add MAC to filter.'
    Write-Host '2: Reset Password.'
    Write-Host '3: Create new user.'
    Write-Host '4: Add workstation to domain.'
    Write-Host ' '
    Write-Host '7: Install WMF.'
    Write-Host '8: Edit DSC.'
    Write-Host ' '
    Write-Host "Q: Press 'Q' to quit."
    Write-Host " "
}