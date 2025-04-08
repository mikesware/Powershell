$vmName = "midserver"
$vm = Get-VM -Name $vmName

if ($vm.State -eq "Off") {
    Write-Host "VM '$vmName' is off. Starting it..."
    Start-VM -Name $vmName
    Write-Host "VM '$vmName' started."
} else {
    Write-Host "VM '$vmName' is running or in a different state: $($vm.State)."
}