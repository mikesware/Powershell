# Script to add DNS A record for jellyfin
# Requires RSAT DNS Server Tools to be installed

# DNS Server settings
$DnsServer = "192.168.0.16"
$ZoneName = "mikesware.com"  # DNS zone name for mikesware.com domain

# Define DNS records as hashtable
$DnsRecords = @{
    "jellyfin" = "192.168.0.251"
    "plex"="192.168.0.30"
    "watch your lan"="192.168.0.30"
    "Homeassistant"="192.168.0.71"
    "w11"="192.168.0.234"
    "ubuntu3"="192.168.0.116"
    "ubuntu2"="192.168.0.253"
    "prestige1"="192.168.0.209"
    "midserver"="192.168.0.211"
    "pve"="192.168.0.14"
    
}

try {
    # Get DNS Zone information
    $allzones = Get-DnsServerZone -ComputerName $DnsServer -ErrorAction SilentlyContinue
    $allzones
    $dnsZone = Get-DnsServerZone -ComputerName $DnsServer -Name $ZoneName -ErrorAction Stop
    Write-Host "Found DNS Zone: $($dnsZone.ZoneName) [Type: $($dnsZone.ZoneType)]"

    foreach ($HostName in $DnsRecords.Keys) {
        $IPAddress = $DnsRecords[$HostName]
        
        # Check if the DNS record already exists
        $existingRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -ErrorAction SilentlyContinue

        if ($existingRecord) {
            Write-Host "DNS record for $HostName already exists. Updating..."
            Remove-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName -RRType A -Force
        }

        # Add the new DNS record
        Add-DnsServerResourceRecordA -Name $HostName -ZoneName $ZoneName -ComputerName $DnsServer -IPv4Address $IPAddress
        Write-Host "Successfully added DNS A record for $HostName.$ZoneName pointing to $IPAddress"

        # Verify the record was added
        try {
            $newRecord = Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer -Name $HostName
            Write-Host "Verification: Found record for $($newRecord.HostName) with IP $($newRecord.RecordData.IPv4Address)"
        } catch {
            Write-Error "Failed to verify DNS record: $_"
        }
    }
} catch {
    Write-Error "Failed to add DNS record: $_"
    exit 1
}


Get-DnsServerResourceRecord -ZoneName $ZoneName