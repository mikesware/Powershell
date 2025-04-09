cls
$ZoneName = "mikesware.com"  # DNS zone name for mikesware.com domain
$DnsServer = "192.168.0.16"

# Get credentials for DNS server access
#$Credential = Get-Credential -Message "Enter credentials for DNS server access"

# Get DNS records using credentials and display IP addresses
Get-DnsServerResourceRecord -ZoneName $ZoneName -ComputerName $DnsServer  | 
    Where-Object {$_.RecordType -eq "A"} |
    Select-Object HostName, @{
        Name='IPAddress';
        Expression={$_.RecordData.IPv4Address}
    } |
    Format-Table -AutoSize