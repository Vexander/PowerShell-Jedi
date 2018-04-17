function TakeSnapShot {
[CmdletBinding()]
    [Alias()]

    param
    (
        # Param1 help description
        [Parameter(Mandatory = $true)]
        [string]
		$HyperVHost,
		[Parameter(Mandatory = $true)] 
		$SnapshotDays
    )
	
	begin {
		$VirtualMachine = Get-VM -ComputerName $HyperVHost
	}
	process {
		if ($pscmdlet.ShouldProcess("Target", "Operation")){
			foreach ($VM in $VirtualMachine) {
                $VmName = $Vm.Name
        		Write-verbose "Creating snapshot of $VmName"
				$DateFormat = Get-Date -Format dd.MM.yyyy
				$Snapshot = $VmName  + "-" + $DateFormat

				CheckPoint-VM -ComputerName $HyperVHost -Name $VmName -Snapshotname $Snapshot 
				Start-Sleep -Seconds 90
				
				Write-verbose "Deleting old snapshots on $VmName"
				Remove-VMSnapshot (Get-VMSnapshot -ComputerName $HyperVHost -VMName $VmName | Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-$SnapshotDays)})
			}
		}
	}
end {
	
	}
}

TakeSnapShot -HyperVHost 'Aloe-2012-hv1' -SnapshotDays 5