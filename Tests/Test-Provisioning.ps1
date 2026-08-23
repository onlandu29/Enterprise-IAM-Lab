Write-Host "===== ACCESS PROVISIONING CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/Provisioning-AccessReport.csv"

$passed = $true

$provisioned = ($report | Where-Object {
    $_.ProvisioningStatus -eq "Provisioned"
}).Count

$notProvisioned = ($report | Where-Object {
    $_.ProvisioningStatus -eq "Not Provisioned"
}).Count

$req002 = $report | Where-Object {
    $_.RequestID -eq "REQ002"
}

$blockedProvisioned = ($report | Where-Object {
    $_.FinalDecision -ne "Approved" -and
    $_.ProvisioningStatus -eq "Provisioned"
}).Count

if ($provisioned -eq 1) {
    Write-Host "[PASS] Provisioned requests: $provisioned"
} else {
    Write-Host "[FAIL] Provisioned requests: $provisioned"
    $passed = $false
}

if ($notProvisioned -eq 3) {
    Write-Host "[PASS] Not provisioned requests: $notProvisioned"
} else {
    Write-Host "[FAIL] Not provisioned requests: $notProvisioned"
    $passed = $false
}

if ($req002.SecurityGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] REQ002 security group: GG-Marketing-Users"
} else {
    Write-Host "[FAIL] REQ002 security group: $($req002.SecurityGroup)"
    $passed = $false
}

if ($req002.ProvisioningStatus -eq "Provisioned") {
    Write-Host "[PASS] REQ002 provisioning status: Provisioned"
} else {
    Write-Host "[FAIL] REQ002 provisioning status: $($req002.ProvisioningStatus)"
    $passed = $false
}

if ($blockedProvisioned -eq 0) {
    Write-Host "[PASS] Blocked/denied requests provisioned: 0"
} else {
    Write-Host "[FAIL] Blocked/denied requests provisioned: $blockedProvisioned"
    $passed = $false
}

Write-Host ""

if ($passed) {
    Write-Host "ACCESS PROVISIONING TEST RESULT: PASS"
    exit 0
} else {
    Write-Host "ACCESS PROVISIONING TEST RESULT: FAIL"
    exit 1
}
