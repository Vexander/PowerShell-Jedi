<#
.Synopsis
   This script is used to update an AD users profile based on the OU they are in.
.DESCRIPTION
   This script builds a set of hash tables which containt all the relavant information with which to update the users.  This hash tables are then pulled into the function Set-OUMembers
   to update the users accordingly.  This script can be set to run on a schedule to ensure that all users are configured corretly based on thier location and department.
.NOTES
   This script assumes that each department has its separate OU and that each department had a group which contains all the departments employees as Members.
   Written By: Rhys Gottwald
   Version:    1
   Released:   21/04/2016
#>

#region 'Build Hash Tables'
# This has table contains the path to the ou that contains the Users & Groups for each department.
$tUserPath = @{
    1="OU=Users & Groups,OU=Department 1,DC=Contoso,DC=com";
    2="OU=Users & Groups,OU=Department 2,DC=Contoso,DC=com";
    3="OU=Users & Groups,OU=Department 3,DC=Contoso,DC=com";
}

# This has table contains the path to the primary security group for each department.
$tGroupPath = @{
    1="CN=Department-1-Group,OU=Users & Groups,OU=Department 1,DC=Contoso,DC=com";
    2="CN=Department-2-Group,OU=Users & Groups,OU=Department 2,DC=Contoso,DC=com";
    3="CN=Department-3-Group,OU=Users & Groups,OU=Department 3,DC=Contoso,DC=com";
}

# This table contains all the conact information for locatin one.
$Location1 = @{
    TelephoneNumber = '+XX XXX XXX XXXX';
    
    Company='Company Name';
    
    physicalDeliveryOfficeName = 'Office';
        
    StreetAddress='Street Address';
    l = 'City';
    PostalCode='YYYY';
    St='State';
    Co = 'Country';
    c = 'Country Code'
}

# This table contains all the conact information for locatin two.
$Location2 = @{
    TelephoneNumber = '+XX XXX XXX XXXX';
    
    Company='Company Name';
    
    physicalDeliveryOfficeName = 'Office';
        
    StreetAddress='Street Address';
    l = 'City';
    PostalCode='YYYY';
    St='State';
    Co = 'Country';
    c = 'Country Code'
}

# These tables contain the unique information for each department.
$Department1 = @{Manager= 'CN=Manager 1,OU=Users & Groups,OU=Department 1,DC=Contoso,DC=com' ; Department='Department 1'; Division='Division 1'}
$Department2 = @{Manager= 'CN=Manager 2,OU=Users & Groups,OU=Department 2,DC=Contoso,DC=com' ; Department='Department 2'; Division='Division 2'}
$Department1 = @{Manager= 'CN=Manager 3,OU=Users & Groups,OU=Department 3,DC=Contoso,DC=com' ; Department='Department 3'; Division='Division 3'}

#endregion

#region 'Credential Saving for Scheduled runs'
function Export-Credential{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String] $Path,

        [System.Management.Automation.Credential()]
        [Parameter(Mandatory=$true)]
        [PsCredential] $Credential
    )

    Begin { }

    Process {
        $ExportCredential = $Credential | Select-Object *    
        $ExportCredential.Password = $ExportCredential.Password | ConvertFrom-SecureString    
        $ExportCredential | Export-Clixml $Path
    }

    End {
        Remove-Variable -Name Path, Credential, ExportCredential -Force
    }
}

function Import-Credential{

    [CmdletBinding(SupportsShouldProcess=$true)]
    param
    (
        [Parameter(Mandatory=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [String] $Path
    )

    Begin { Import-Module ActiveDirectory }
    
    Process {
        $ImportCredential = Import-Clixml $path    
        $ImportCredential.password = $ImportCredential.Password | ConvertTo-SecureString    
        New-Object system.Management.Automation.PSCredential($ImportCredential.username, $ImportCredential.password)
    }

    End { 
        Remove-Variable -Name Path, ImportCredential
     }
}
#endregion

function Set-OUMembers {
<#
.Synopsis
   Updates users profile in based on the OU they are in.
.DESCRIPTION
   This is the fucntion that ensures that all users in a specific OU have all the relative organisational and contact information configured on thier profile relative to thier department.
   The functin then adds the users the departments group, and sets the department group as the users primary group.
.EXAMPLE
   Set-OUMembers -DeptId 1 -DepartmentTable $Department1 -LocationTable $Location1
.INPUTS
   System.Int32
   System.Collections.Hashtable
.OUTPUTS
   Nothing
.NOTES
   General notes
#>
    Param(
        [Int32] $DeptId,
        [System.Collections.Hashtable] $DepartmentTable,
        [System.Collections.Hashtable] $LocationTable
    )

    Begin { 
        [PsCredential]$DomainCredential = Import-Credential -Path 'C:\Users\Public\Documents\SecureCredentials.xml'
    }

    Process {
        Try {
            [string]$UserPath = $tUserPath.Get_Item($DeptId)
            [string]$GroupPath = $tGroupPath.Get_Item($DeptId)

            # Set the users depatmental properties
            Get-ADUser -Filter * -SearchBase "$UserPath" -Credential $DomainCredential | Set-ADUser -replace $DepartmentTable -Credential $DomainCredential 
            # Set the users location properties
            Get-ADUser -Filter * -SearchBase "$UserPath" -Credential $DomainCredential | Set-ADUser -replace $LocationTable -Credential $DomainCredential 

            # Add the users to the departmenta group.
            $Users = Get-ADUser -Filter * -SearchBase "$UserPath" -Credential $DomainCredential 
            $Group = Get-ADGroup -Filter * -SearchBase "$GroupPath" -Credential $DomainCredential 
            Add-ADGroupMember $Group -Members $User -Credential $DomainCredential 
            
            # Set the departmental group as the users primary group.
            $GroupSid = $Group.sid
            [int]$GroupId = $GroupSid.Value.Substring($GroupSid.Value.LastIndexOf("-")+1)
            Get-ADUser -Filter * -SearchBase "$UserPath" -Credential $DomainCredential  | Set-ADUser -Replace @{primaryGroupID="$GroupId"} -Credential $DomainCredential 
        }
        Catch {

        }
    }

    End { 
        Remove-Variable -Name DeptId, DepartmentTable, LocationTable, DomainCredential, UserPath, GroupPath, Users, Group, GroupSid, GroupId
    }
}

# Call the function per department
Set-OUMembers -DeptId 1 -DepartmentTable $Department1 -LocationTable $Location1
Set-OUMembers -DeptId 2 -DepartmentTable $Department2 -LocationTable $Location1
Set-OUMembers -DeptId 3 -DepartmentTable $Department3 -LocationTable $Location2

# Configure the Directors for the departmental managers.
[PsCredential]$DomainCredential = Import-Credential -Path 'C:\Users\Public\Documents\SecureCredentials.xml'
Get-ADUser 'Manager 1' -Credential $DomainCredential | Set-ADUser -Manager 'CN=Director 1,OU=Users & Groups,OU=Directors,DC=Contoso,DC=com' -Credential $DomainCredential 
Get-ADUser 'Manager 1' -Credential $DomainCredential | Set-ADUser -Manager 'CN=Director 2,OU=Users & Groups,OU=Directors,DC=Contoso,DC=com' -Credential $DomainCredential 
Get-ADUser 'Manager 1' -Credential $DomainCredential | Set-ADUser -Manager 'CN=Director 3,OU=Users & Groups,OU=Directors,DC=Contoso,DC=com' -Credential $DomainCredential 

