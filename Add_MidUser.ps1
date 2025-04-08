# Script to add or update local user 'miduser' on a remote computer

function Add-MidUser {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [string]$Username = "miduser",
        [string]$Password = "miduser",
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.Credential()]
        $Credential = [System.Management.Automation.PSCredential]::Empty
    )

    try {
        # Create script block to execute remotely
        $ScriptBlock = {
            param($Username, $Password)
            
            # Convert password to secure string
            $SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force

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
        }

        # Execute the script block remotely
        $params = @{
            ComputerName = $ComputerName
            ScriptBlock = $ScriptBlock
            ArgumentList = @($Username, $Password)
        }
        if ($Credential -ne [System.Management.Automation.PSCredential]::Empty) {
            $params['Credential'] = $Credential
        }

        Invoke-Command @params
    }
    catch {
        Write-Error "Failed to create/update user on $ComputerName: $_"
    }
}

# Example usage:
# Add-MidUser -ComputerName "RemotePC"
# Or with credentials:
# $cred = Get-Credential
# Add-MidUser -ComputerName "RemotePC" -Credential $cred
Add-MidUser -ComputerName "Mojo" -Credential $cred