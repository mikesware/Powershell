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
  $thisScriptfull= $MyInvocation.MyCommand.Path 
  $thisScriptpath=Split-Path $MyInvocation.MyCommand.Path -Parent
  $thisScriptName = Split-Path $MyInvocation.MyCommand.Path -Leaf
  $calledfromscript=$false
  $CallingScript = if ($MyInvocation.PSCommandPath -eq $null) {
      "Being run interactively or dot-sourced"
  } elseif ($MyInvocation.PSCommandPath -eq $PSCommandPath) {
      "Running as main script"
  } else {
        $calledfromscript=$true
      $CallerPath = $MyInvocation.PSCommandPath
      $CallerName = Split-Path $CallerPath -Leaf
      "Called from: $CallerName (Full path: $CallerPath)"
      $thisScriptfull=$CallerPath
      $thisScriptpath =split-path $CallerPath -Parent
      $thisScriptName = $CallerName
    }
    Write-Host "Script execution context: $CallingScript"
    Write-Host "calledfromscript        : $calledfromscript"
    Write-Host "thisscriptfull          : $thisScriptfull"
    Write-Host "thisScriptpath          : $thisScriptpath"
    Write-Host "thisScriptName          : $thisScriptName"
  
  # Check PowerShell environment
  $PSVersion = $PSVersionTable.PSVersion
  $IsCore = $PSVersionTable.PSEdition -eq 'Core'
  $RunningPlatform = if ($IsWindows) { "Windows" } elseif ($IsLinux) { "Linux" } elseif ($IsMacOS) { "macOS" } else { "Windows PowerShell" }
  
  Write-Host "Running script: $thisScriptfull"
  Write-Host "PowerShell Version: $PSVersion"
  Write-Host "PowerShell Edition: $($PSVersionTable.PSEdition)"
  Write-Host "Running on: $RunningPlatform"

