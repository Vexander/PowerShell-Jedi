<#
	.SYNOPSIS
		Disables users and computers who have not logged on to the domain in XX days.

	.DESCRIPTION
		A detailed description of the $Name$ function.

	.PARAMETER sSearchBase
		The path the to search base to interigated by the functon.
	.PARAMETER sDisabledOu
		The path to the OU where the disabled accounts are to be moved to.
	.PARAMETER $iTimeSpan
		The the time span of inactive days to search for.

	.EXAMPLE
		PS C:\> Clean-ADS
		This example uses the default values for the function.
		
	.EXAMPLE
		PS C:\> Clean-ADS -sSearchBase -sDisabledOu -iTimeSpan
		This example uses the default values for the function.
	.INPUTS
		System.String
		System.String
		System.Int32

	.NOTES
		For more information about advanced functions, call Get-Help with any
		of the topics in the links listed below.

#>

function Clean-ADS {
	[CmdletBinding()]
	param(
		[Parameter(Position=0)]
		[System.String]$sSearchBase = '',
		[Parameter(Position=1)]
		[System.String]$sDisabledOu = '',
		[Parameter(Position=2)]
		[System.Int32]$iTimeSpan = 60
	)
	
	begin {
		Get-ADObject -Filter * -Properties ProtectedFromAccidentalDeletion -SearchBase $sSearchBase | where {$_.ProtectedFromAccidentalDeletion -eq $true} | Set-ADObject -ProtectedFromAccidentalDeletion $false -Verbose
		Get-ADOrganizationalUnit -filter * -Properties ProtectedFromAccidentalDeletion -SearchBase $sSearchBase | where {$_.ProtectedFromAccidentalDeletion -eq $true} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $false -Verbose
	}
	process {
		$user = Search-ADAccount -AccountInactive -UsersOnly -SearchBase $sSearchBase -TimeSpan $iTimeSpan
		$computer = Search-ADAccount -AccountInactive -ComputersOnly -SearchBase $sSearchBase -TimeSpan $iTimeSpan
		
		foreach ($u in $user) {
			Get-ADUser -Identity $u | Disable-ADAccount -Verbose
			Get-ADUser -Identity $u | Move-ADObject -TargetPath $sDisabledOu -Verbose
		}
		
		foreach ($c in $computer) {
			Get-ADObject -Identity $c | Disable-ADAccount -Verbose
			Get-ADObject -Identity $c | Move-ADObject -TargetPath $sDisabledOu -Verbose
		}
	}
	end {
		Get-ADObject -Filter * -Properties ProtectedFromAccidentalDeletion -SearchBase $sSearchBase | where {$_.ProtectedFromAccidentalDeletion -eq $false} | Set-ADObject -ProtectedFromAccidentalDeletion $true -Verbose
		Get-ADOrganizationalUnit -filter * -Properties ProtectedFromAccidentalDeletion -SearchBase $sSearchBase | where {$_.ProtectedFromAccidentalDeletion -eq $false} | Set-ADOrganizationalUnit -ProtectedFromAccidentalDeletion $true -Verbose	
	}
}