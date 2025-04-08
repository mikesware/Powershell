$localpwd="miduser"
$username="miduser"

            # Convert password to secure string
            $SecurePassword = ConvertTo-SecureString $localpwd -AsPlainText -Force

            # Check if user exists
            $UserExists = Get-LocalUser -Name $Username -ErrorAction SilentlyContinue

            if ($UserExists) {
                Write-Host "User $Username exists on $env:COMPUTERNAME. Updating password..."
                Set-LocalUser -Name $Username -Password $SecurePassword
            }
            else {
                Write-Host "Creating new user $Username on $env:COMPUTERNAME..."
                New-LocalUser -Name $Username -Password $SecurePassword -Description "MID Server Service Account" -PasswordNeverExpires
            }

            # Ensure user is enabled
            Enable-LocalUser -Name $Username
            Write-Host "User $Username has been created/updated successfully on $env:COMPUTERNAME"
        
