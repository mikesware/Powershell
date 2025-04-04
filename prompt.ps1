function prompt {

    #Assign Windows Title Text
    $host.ui.RawUI.WindowTitle = "Current Folder: $pwd"

    #Configure current user, current folder and date outputs
    $CmdPromptCurrentFolder = Split-Path -Path $pwd -Leaf
    $CmdPromptUser = [Security.Principal.WindowsIdentity]::GetCurrent();
    $Date = Get-Date -Format 'dddd hh:mm:ss tt'

    # Test for Admin / Elevated
    $IsAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)

    #Calculate execution time of last cmd and convert to milliseconds, seconds or minutes
    $LastCommand = Get-History -Count 1
    if ($lastCommand) { $RunTime = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime).TotalSeconds }

    if ($RunTime -ge 60) {
        $ts = [timespan]::fromseconds($RunTime)
        $min, $sec = ($ts.ToString("mm\:ss")).Split(":")
        $ElapsedTime = -join ($min, " min ", $sec, " sec")
    }
    else {
        $ElapsedTime = [math]::Round(($RunTime), 2)
        $ElapsedTime = -join (($ElapsedTime.ToString()), " sec")
    }

    #Decorate the CMD Prompt
    Write-Host ""
    Write-Host $env:computername -NoNewline -ForegroundColor Magenta
        Write-Host "-" -NoNewline -ForegroundColor Magenta
    $ip = (Test-Connection -ComputerName (hostname) -Count 1).IPV4Address.IPAddressToString
    Write-Host "$ip" -NoNewline -ForegroundColor Yellow
    
    Write-host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
    Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
    If ($CmdPromptCurrentFolder -like "*:*")
        {Write-Host " $CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
        else {Write-Host ".\$CmdPromptCurrentFolder\ "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
   $mydocs=[Environment]::GetFolderPath('MyDocuments')
    Write-Host -Object "$mydocs>" -NoNewLine -ForegroundColor DarkGreen -BackgroundColor Cyan
    
    $Location = Get-Item -Path (Get-Location)
     #Write-Host -Object "$Location>" -NoNewLine -ForegroundColor Green
    Write-Host " "
    Write-Host " $date " -NoNewline -ForegroundColor White
    Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
     Write-Host -Object "$Location" -NoNewLine -ForegroundColor Green
    return ">"
} #end prompt function