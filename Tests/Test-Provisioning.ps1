Write-Host "===== ACCESS PROVISIONING CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/Provisioning-AccessReport.csv"
$failed = $false

$activeProvisioning = @(
    $report | Where-Object {
        $_.ProvisioningStatus -eq "Provisioned" -or
        $_.ProvisioningStatus -eq "Already Provisioned"
    }
).Count

$notProvisioned = @(
    $report | Where-Object {
        $_.ProvisioningStatus -eq "Not Provisioned"
    }
).Count

if ($activeProvisioning -eq 1) {
    Write-Host "[PASS] Active provisioning records: 1"
}
else {
    Write-Host "[FAIL] Active provisioning records: $activeProvisioning"
    $failed = $true
}

if ($notProvisioned -eq 3) {
    Write-Host "[PASS] Not provisioned requests: 3"
}
else {
    Write-Host "[FAIL] Not provisioned requests: $notProvisioned"
    $failed = $true
}

$req002 = $report | Where-Object {
    $_.RequestID -eq "REQ002"
}

if ($req002.SecurityGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] REQ002 security group: GG-Marketing-Users"
}
else {
    Write-Host "[FAIL] REQ002 security group: $($req002.SecurityGroup)"
    $failed = $true
}

if ($req002.ProvisioningStatus -eq "Already Provisioned") {
    Write-Host "[PASS] REQ002 duplicate access prevented"
}
else {
    Write-Host "[FAIL] REQ002 provisioning status: 
$($req002.ProvisioningStatus)"
    $failed = $true
}

$blockedProvisioned = @(
    $report | Where-Object {
        $blocked = $_.FinalDecision -eq "Blocked"
        $denied = $_.FinalDecision -eq "Denied"
        $provisioned = $_.ProvisioningStatus -eq "Provisioned"
        $already = $_.ProvisioningStatus -eq "Already Provisioned"

        (($blocked -or $denied) -and ($provisioned -or $already))
    }
).Count

if ($blockedProvisioned -eq 0) {
    Write-Host "[PASS] Blocked/denied requests provisioned: 0"
}
else {
    Write-Host "[FAIL] Blocked/denied requests provisioned: 
$blockedProvisioned"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "ACCESS PROVISIONING TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "ACCESS PROVISIONING TEST RESULT: PASS"
    exit 0
}
