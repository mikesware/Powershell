# filepath: c:\DATA\SendEmail.ps1

<#
SendEmail-config.json
{
    "email_username": "mike@mikesware.com",
    "email_password": "xxxxxx",
    "email_smtp_host": "mail.privateemail.com",
    "email_smtp_port": 587,
    "email_smtp_SSL": true,
    "email_from_address": "mike@mikesware.com",
    "email_to_addressArray": ["mredmanr@gmail.com", "mike@prestigeelectricalinpections.com"],
    "email_attachment": "",
    "email_subject": "Custom Email Subject",
    "email_body": "This is the custom email body content.\n\nBest regards,\n"
}
#>
function Send-CustomEmail {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$ConfigFilePath = "c:\DATA\email-config.json"
    )

    # Get current timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Clear screen and initialize config
    Clear-Host
    $config = $null

    # Load configuration from file or use defaults
    if (Test-Path $ConfigFilePath) {
        $config = Get-Content $ConfigFilePath | ConvertFrom-Json
        Write-Host "[$timestamp] Loading configuration from $ConfigFilePath"
    } else {
        Write-Host "[$timestamp] Configuration file not found. Using hardcoded defaults."
        $config = @{
            email_username = "mike@mikesware.com"
            email_password = ""
            email_smtp_host = "mail.privateemail.com"
            email_smtp_port = 587
            email_smtp_SSL = $true
            email_from_address = "mike@mikesware.com"
            email_to_addressArray = @("mredmanr@gmail.com", "mike@prestigeelectricalinspections.com")
            email_attachment = ""
            email_subject = "Default Subject"
            email_body = "Default email body content"
        }
    }

    # Prompt for password if not provided
    if (-not $config.email_password -or $config.email_password -eq "") {
        $email_password = Read-Host "Enter your email password" -AsSecureString
        $email_password_plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($email_password))
    } else {
        $email_password_plain = $config.email_password
    }

    # Initialize email parameters
    $toaddress = @($config.email_to_addressArray)
    $fromaddress = $config.email_from_address
    $attachment = $config.email_attachment
    $smtp_port = $config.email_smtp_port
    $smtp_SSL = [bool]$config.email_smtp_SSL
    $email_username = $config.email_username
    $email_smtp_host = $config.email_smtp_host

    # Send email logic here
    try {
        $message = New-Object Net.Mail.MailMessage
        $message.From = $fromaddress
        foreach ($to in $toaddress) {
            $message.To.Add($to)
        }
        $message.Subject = $config.email_subject+" [$timestamp]"
        $message.Body = "Email sent at: $timestamp`n`n" + $config.email_body

        if ($attachment -ne "" -and (Test-Path $attachment)) {
            $attachmentObj = New-Object Net.Mail.Attachment($attachment)
            $message.Attachments.Add($attachmentObj)
        }

        $smtp = New-Object Net.Mail.SmtpClient($email_smtp_host, $smtp_port)
        $smtp.EnableSSL = $smtp_SSL
        $smtp.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password_plain)
        $smtp.Send($message)
        Write-Host "[$timestamp] Email sent successfully to: $($toaddress -join ', ')"
    }
    catch {
        Write-Error "[$timestamp] Failed to send email: $_"
    }
    finally {
        if ($message) { $message.Dispose() }
        if ($attachmentObj) { $attachmentObj.Dispose() }
    }
}

# Example usage:
 Send-CustomEmail -ConfigFilePath "c:\DATA\email-config.json"

