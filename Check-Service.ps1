cls
# Check execution environment
$ExecutionEnvironment = if ($host.Name -eq 'Visual Studio Code Host') {
  "Visual Studio Code"
} elseif ($host.Name -eq 'Windows PowerShell ISE Host') {
  "PowerShell ISE"
} elseif ($host.Name -eq 'ConsoleHost') {
  "PowerShell Console"
} else {
  $host.Name
}

Write-Host "Running in: $ExecutionEnvironment"



# Get the current script name
# Check if script is being sourced
$ScriptName = Split-Path $MyInvocation.MyCommand.Path -Leaf
$CallingScript = if ($MyInvocation.PSCommandPath -eq $null) {
    "Being run interactively or dot-sourced"
} elseif ($MyInvocation.PSCommandPath -eq $PSCommandPath) {
    "Running as main script"
} else {
    "Called from: $($MyInvocation.PSCommandPath)"
}

Write-Host "Script execution context: $CallingScript"

# Check PowerShell environment
$PSVersion = $PSVersionTable.PSVersion
$IsCore = $PSVersionTable.PSEdition -eq 'Core'
$RunningPlatform = if ($IsWindows) { "Windows" } elseif ($IsLinux) { "Linux" } elseif ($IsMacOS) { "macOS" } else { "Windows PowerShell" }

Write-Host "Running script: $ScriptName"
Write-Host "PowerShell Version: $PSVersion"
Write-Host "PowerShell Edition: $($PSVersionTable.PSEdition)"
Write-Host "Running on: $RunningPlatform"

# ...existing code...

$serviceName="sshd"
"testing $servicename"
# Check the service status
$service = Get-Service -Name $serviceName

if ($service.Status -ne 'Running') {
    $subject = "Alert: Service '$($serviceName)' is NOT running"
    $body = "Service '$($serviceName)' status is: $($service.Status). Please check immediately."

}
else {
    $subject = "Service '$($serviceName)' is running"
    $body = "Service '$($serviceName)' status is: $($service.Status). No action required."
}
$subject 
$body