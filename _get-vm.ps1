$vms=get-vm 
$vms|ForEach-Object {get-vmharddiskdrive -VMName $_.Name|select Path}
#get-vm -Name "Ubuntu 22.04 LTS"
#Get-VMHardDiskDrive -VMName "Ubuntu 22.04 LTS"