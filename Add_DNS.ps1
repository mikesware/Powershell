# Script to add DNS A record for jellyfin
# Requires RSAT DNS Server Tools to be installed

# DNS Server settings
$DnsServer = "192.168.0.16"
$ZoneName = "local"  # Change this to match your DNS zone name
$HostName = "jellyfin"
$IPAddress = "192.168.0.251"

try {
    # Get DNS Zone information
    $dnsZone = Get-DnsServerZone -ComputerName $DnsServer -Name $ZoneName -ErrorAction Stop
    Write-Host "Found DNS Zone: $($dnsZone.ZoneName) [Type: $($dnsZone.ZoneType)]"

    # Check if the DNS record already exists
    $existingRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -ErrorAction SilentlyContinue

    if ($existingRecord) {
        Write-Host "DNS record for $HostName already exists. Updating..."
        Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -RRType A -Force
    }

    # Add the new DNS record
    Add-DnsServerResourceRecordA -Name $HostName -ZoneName $ZoneName -ComputerName $DnsServer -IPv4Address $IPAddress

    Write-Host "Successfully added DNS A record for $HostName.$ZoneName pointing to $IPAddress"
} catch {
    Write-Error "Failed to add DNS record: $_"
    exit 1
}

# Verify the record was added
try {
    $newRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName
    Write-Host "Verification: Found record for $($newRecord.HostName) with IP $($newRecord.RecordData.IPv4Address)"
} catch {
    Write-Error "Failed to verify DNS record: $_"
}