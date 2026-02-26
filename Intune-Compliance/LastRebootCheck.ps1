$LastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$DaysSinceBoot = (New-TimeSpan -Start $LastBoot -End (Get-Date)).Days

if ($DaysSinceBoot -le 14) {
    $result = @{ "LastRebootCheck" = "Compliant" }
} else {
    $result = @{ "LastRebootCheck" = "NonCompliant" }
}

$result | ConvertTo-Json -Compress
