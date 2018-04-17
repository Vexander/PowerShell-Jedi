    $Shares = 
    @(
        @{
            Name = 'Templates Share' 
            Path = 'C:\DfsRoots\Templates Share' 
            ChangeAccess = 'Aloe-Templates-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Templates-Share-R'
        },
        @{
            Name = 'Public Share' 
            Path = 'C:\DfsRoots\Public Share' 
            ChangeAccess = 'Aloe-Public-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Public-Share-R'
        },
        @{
            Name = 'Admin Share' 
            Path = 'C:\DfsRoots\Department Shares\Admin Share' 
            ChangeAccess = 'Aloe-Admin-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Admin-Share-R'
        },
        @{
            Name = 'Facilities Managment' 
            Path = 'C:\DfsRoots\Department Shares\Facilities Management' 
            ChangeAccess = 'Aloe-Facilities-Managment-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Facilities-Managment-R'
        },
        @{
            Name = 'Finance Share' 
            Path = 'C:\DfsRoots\Department Shares\Finance Share'
            ChangeAccess = 'Aloe-Finance-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Finance-Share-R'
        },
        @{
            Name = 'Human Resources Share' 
            Path = 'C:\DfsRoots\Department Shares\Human Resources Share' 
            ChangeAccess = 'Aloe-Human-Resources-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Human-Resources-Share-R'
        },
        @{
            Name = 'Information Technology Share' 
            Path = 'C:\DfsRoots\Department Shares\Information Technology Share' 
            ChangeAccess = 'Aloe-Information-Technology-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Information-Technology-Share-R'
        },
        @{
            Name = 'Information Technology Installs' 
            Path = 'C:\DfsRoots\Department Shares\Information Technology Installs' 
            ChangeAccess = 'Aloe-Information-Technology-Installs-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Information-Technology-Installs-R'
        },
        @{
            Name = 'Operations Share' 
            Path = 'C:\DfsRoots\Department Shares\Operations Share' 
            ChangeAccess = 'Aloe-Operations-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Operations-Share-R'
        },
        @{
            Name = 'Sales Share' 
            Path = 'C:\DfsRoots\Department Shares\Sales Share' 
            ChangeAccess = 'Aloe-Sales-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Sales-Share-R'
        },
        @{
            Name = 'Service Share' 
            Path = 'C:\DfsRoots\Department Shares\Service Share' 
            ChangeAccess = 'Aloe-Service-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Service-Share-R'
        },
        @{
            Name = 'Stores Share' 
            Path = 'C:\DfsRoots\Department Shares\Stores Share' 
            ChangeAccess = 'Aloe-Stores-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased'
            ReadAccess = 'Aloe-Stores-Share-R'
         },
        @{
            Name = 'Technical Share' 
            Path = 'C:\DfsRoots\Department Shares\Technical Share' 
            ChangeAccess = 'Aloe-Technical-Share-W' 
            Description = '' 
            Ensure = 'Present' 
            EnumerationMode = 'AccessBased' 
            ReadAccess = 'Aloe-Technical-Share-R'
         }
    )

    foreach ($Share in $Shares)
    {
        if (!(Test-Path -Path $share.Path))
        {
            New-Item -Path $Share -ItemType Directory
        }
        else
        {
            Write-Host 'The path already exsits.'
        }
    }


    ForEach ($Share in $Shares) 
    {
        if (Test-Path  $share.Path)
        {
            New-SmbShare -Name $Share.Name -Path $Share.Path -CachingMode Documents -ChangeAccess $Share.ChangeAccess -ContinuouslyAvailable $true -Description $Share.Description -FolderEnumerationMode $Share.EnumerationMode -ReadAccess $Share.ReadAccess
        }
        else
        {
            Write-Host 'The path does not exsist.'
        }
    }