<#
Write-Host ""
Write-Host ($(if ($IsAdmin) { 'Elevated ' } else { '' })) -BackgroundColor DarkRed -ForegroundColor White -NoNewline
Write-Host " USER:$($CmdPromptUser.Name.split("\")[1]) " -BackgroundColor DarkBlue -ForegroundColor White -NoNewline
If ($CmdPromptCurrentFolder -like "*:*")
        {Write-Host " $CmdPromptCurrentFolder "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
        else {Write-Host ".\$CmdPromptCurrentFolder\ "  -ForegroundColor White -BackgroundColor DarkGray -NoNewline}
Write-Host " $date " -ForegroundColor White
Write-Host "[$elapsedTime] " -NoNewline -ForegroundColor Green
return "> "
#>



<#
set profile
function cddata { set-location "C:\DATA" }
new-alias cdt cddata
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Not running as administrator."
} else {
    Write-Host "Running as administrator."
cdt
}
#>

$Location = Get-Item -Path (Get-Location)
    if ($Location.PSChildName) {
        $LocationName = $Location.PSChildName
    } else {
        $LocationName = $Location.BaseName
    }
    Write-Host -Object "$Location>" -NoNewLine -ForegroundColor Green

    Write-Host -Object "$LocationName>" -NoNewLine -ForegroundColor Green



