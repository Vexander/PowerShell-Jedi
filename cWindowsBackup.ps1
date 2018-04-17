Function New-SystemStateBackup
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Destination,
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName

    )

    Begin
    {
        $date =Get-Date -format d
        $m_Date = $date.Replace("/","")
    }

    Process
    {
        ForEach($m_Name in $ComputerName)
        {
            if (!($Destination.EndsWith('\')))
            {
                $Destination = "$Destination\$m_Name-$m_Date"
            }
            else
            {
                $Destination = "$Destination$m_Name-$m_Date"
            }

            Invoke-Command -ScriptBlock {param($m_Destination) wbadmin start systemstatebackup -backupTarget:$m_Destination -quiet} -ArgumentList $Destination -AsJob -ComputerName $m_Name -JobName SystemStateBackup
        }
    }

    End
    {}
}

Function New-Backup
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Destination,
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName,
        [parameter(mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies the comma-delimited list of items to include in the backup. You can include multiple files, folders, or volumes.")]
        [string]
        $include,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies the non-recursive, comma-delimited list of items to include in the backup. You can include multiple files, folders, or volumes.")]
        [string]$nonRecurseInclude,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies the comma-delimited list of items to exclude from the backup. You can exclude files, folders, or volumes.")]
        [string]$exclude, 
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies the non-recursive, comma-delimited list of items to exclude from the backup. You can exclude files, folders, or volumes.")]
        [string]$nonRecurseExclude,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies that all critical volumes (volumes that contain operating system's state) be included in the backups.")]
        [switch]$allCritical,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Creates a backup that includes the system state in addition to any other items that you specified with the -include parameter.")]
        [switch]$systemState,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies that backups saved to removable media (such as a DVD) are not verified for errors.")]
        [switch]$noVerify,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="If the backup is saved to a remote shared folder, specifies the user name with write permission to the folder.")]
        [switch]$UserName,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Specifies the password for the user name that is provided by the parameter -UserName.")]
        [switch]$Password,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Applies the access control list (ACL) permissions that correspond to the credentials provided by the -username and -password parameters to the folder that contains the backup.")]
        [switch]$noInheritAcl,
        [parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Performs a full back up using the Volume Shadow Copy Service.")]
        [switch]$vssFull

    )

    Begin
    {}

    Process
    {
        Invoke-Command -ScriptBlock {param($m_Destination) wbadmin start backup -backupTarget:$m_Destination -quiet} -ArgumentList $Destination -AsJob -ComputerName $ComputerName -JobName SystemStateBackup
    }

    End
    {}
}

Function New-HyoerVBackup
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string]
        $Destination,
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [string[]]
        $ComputerName

    )
    wbadmin start backup –backupTarget:<location to backup to> –hyperv:<list of virtual machines to backup>
}