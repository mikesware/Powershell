Clear-Host
$tname="TestTask"
$toutfile="C:\data\code\powershell\ts.txt"
$trigger = New-ScheduledTaskTrigger -Weekly -At 3AM -DaysOfWeek Sunday -WeeksInterval 1
$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument -File $toutfile
$principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest

if (!(Get-ScheduledTask -TaskName $tname))
{
    #Unregister-ScheduledTask -TaskName $tname -Confirm:$false
    Register-ScheduledTask -TaskName $tname -Trigger $trigger -Action $action -Principal $principal -Description "Test Task" -Force
}   
else {
    write-host $tname "already exists" -ForegroundColor Green
    Get-ScheduledTask -TaskName $tname| Get-ScheduledTaskInfo

}
$taskrun=Start-ScheduledTask -TaskName $tname
$taskrun
(Get-Content -Path $toutfile).Length

<#
$splat = @{
    TaskName = 'Run PowerShell Script'
    Trigger = $trigger
    Action = $action
    Settings = $settings
    Principal = $principal
    TaskPath = '\TechTarget\'
}
#>
#Register-ScheduledTask @splat