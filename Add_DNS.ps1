# Script to add DNS A record
# Requires RSAT DNS Server Tools to be installed

# DNS Server settings
$DnsServer = "192.168.0.16"
$ZoneName = "local"  # Change this to match your DNS zone name
$HostName = "jellyfin"
$IPAddress = "192.168.0.251"

try {
    # Check if the DNS record already exists
    $existingRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -ErrorAction SilentlyContinue

    if ($existingRecord) {
        Write-Host "DNS record for $HostName already exists. Updating..."
        Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -RRType A -Force
    }

    # Add the new DNS record
    Add-DnsServerResourceRecordA -Name $HostName -ZoneName $ZoneName -ComputerName