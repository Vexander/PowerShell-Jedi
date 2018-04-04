<#
 .Synopsis
    Shuts down Hyper-V guests and applies configurations to the guests and reboots the guest.
 .DESCRIPTION
    Long description
 .EXAMPLE
    Confgure-Guest -$HyperVHost hyerpv1
 .NOTES
    General notes
 .COMPONENT
    The component this cmdlet belongs to
 .ROLE
    The role this cmdlet belongs to
 .FUNCTIONALITY
    The functionality that best describes this cmdlet
 #>

$Configs = @{}
$Configs = @{'Aloe-2012-Dc1' ='Domain Controller';'Aloe-2012-Dsc' ='Management';'Aloe-2012-Mail' ='Mail';'Aloe-2012-Prn' ='Print';'Aloe-2012-Ts1' ='RDS'}

Function Default{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 512MB
    $MemoryMinimumBytes = 1GB
    $MemoryMaximumBytes = 4GB
    $ProcessorCount = 1
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 90
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
    
}

Function DomainController{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 1GB
    $MemoryMinimumBytes = 1GB
    $MemoryMaximumBytes = 8GB
    $ProcessorCount = 1
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 0
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
}

Function Management{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 512MB
    $MemoryMinimumBytes = 512MB
    $MemoryMaximumBytes = 4GB
    $ProcessorCount = 1
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 90
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
}

Function Mail{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 4GB
    $MemoryMinimumBytes = 3GB
    $MemoryMaximumBytes = 8GB
    $ProcessorCount = 2
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 90
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
}

Function Print{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 512MB
    $MemoryMinimumBytes = 512MB
    $MemoryMaximumBytes = 4GB
    $ProcessorCount = 1
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 90
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
}

Function RDS{
    param 
    (
        $Vm
    )

    $AutomaticCriticalErrorAction = Pause `
    $AutomaticCriticalErrorActionTimeout = 90 `
    $MemoryStartupBytes = 512MB
    $MemoryMinimumBytes = 2GB
    $MemoryMaximumBytes = 6GB
    $ProcessorCount = 2
    $StartOrder = @("IDE","CD","LegacyNetworkAdapter","Floppy")
    $AutomaticStartAction = Start
    $AutomaticStartDelay = 90
    $AutomaticStopAction = ShutDown
    $CheckpointType = Production 
    $LockOnDisconnect = On
        
    Set-VM -VM $Vm `
    -AutomaticCriticalErrorAction $AutomaticCriticalErrorAction `
    -AutomaticCriticalErrorActionTimeout $AutomaticCriticalErrorActionTimeout `
    -AutomaticStartAction $AutomaticStartAction `
    -AutomaticStartDelay $AutomaticStartDelay `
    -AutomaticStopAction $AutomaticStopAction `
    -CheckpointType $CheckpointType `
    -DynamicMemory `
    -LockOnDisconnect $LockOnDisconnect `
    -MemoryMaximumBytes $MemoryMaximumBytes `
    -MemoryMinimumBytes $MemoryMinimumBytes `
    -MemoryStartupBytes $MemoryStartupBytes `
    -ProcessorCount $ProcessorCount

    Set-VMBios -VM $Vm -EnableNumLock -StartupOrder @("IDE","CD","LegacyNetworkAdapter","Floppy")
}
  
Function Confgure-Guest
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNull()]
        [ValidateNotNullOrEmpty()]
        [string]$HyperVHost)

        $Vm = Get-VM -ComputerName $HyperVHost

        ForEach ($v in $Vm)
        { 
            $VmName = $v.name

            # Provide shutdown command
            If ($V.State -ne "Off") 
            {
                Write-Host (Get-Date)": Waiting for $VmName to shutdown"

                Stop-VM -Name $v.Name -ComputerName $HyperVHost
                   
                While ((Get-VM -ComputerName $HyperVHost -Name $v.Name ).State -ne 'Off')
                {
                    Write-Host "." -NoNewLine
                    Start-Sleep -Seconds 5
                }

                Write-Host (Get-Date)": $VmName is is down."
            }
                
            Write-Host (Get-Date)": Configuring $VmName."

            #Apply the changes.
            $Role = $Configs.$VmName
            $Role
            Switch ($Role)
            {
                'Domain Controller' {DomainController -Vm $v};
                'Management ' {Management -Vm $v};
                'Mail' {Mail -Vm $v};
                'Print' {Print -Vm $v};
                'RDS' {RDS -Vm $v};
                Default {Default -Vm $v};
            }
           
            Get-VMIntegrationService -VMName $VmName | ForEach-Object {Enable-VMIntegrationService -Name $_.Name -VMName $VmName}
                
            #Boot the VM. 
            Start-VM -ComputerName $HyperVHost -Name $V.Name

            # Wait until VM is runnin
            Write-Host (Get-Date)": Waiting for $VMName to turn on."
            do {Start-Sleep -milliseconds 100} until 
            (
                (Get-VMIntegrationService $v | ?{$_.name -eq "Heartbeat"}).PrimaryStatusDescription -eq "OK"
            )

            Write-Host (Get-Date)": $VMName has booted."
        }
    }