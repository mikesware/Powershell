cls 
if([Environment]::Is64BitProcess -eq $true)
                    {
                    write-output "64bit NO GO" 
                    BREAK
                    } 
            else {
                        write-output "32bit OK"
                        } #because you have a 64-bit PowerShell
