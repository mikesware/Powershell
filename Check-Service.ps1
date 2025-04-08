. .\this.ps1



$serviceName="sshd"
"testing $servicename"
# Check the service status
$service = Get-Service -Name $serviceName

if ($service.Status -ne 'Running') {
    $subject = "Alert: Service '$($serviceName)' is NOT running"
    $body = "Service '$($serviceName)' status is: $($service.Status). Please check immediately."

}
else {
    $subject = "Service '$($serviceName)' is running"
    $body = "Service '$($serviceName)' status is: $($service.Status). No action required."
}
$subject 
$body