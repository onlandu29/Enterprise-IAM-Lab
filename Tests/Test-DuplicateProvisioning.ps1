Write-Host "===== DUPLICATE PROVISIONING CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/Provisioning-AccessReport.csv"
$failed = $false

$alreadyProvisioned = @(
    $report | Where-Object {
        $_.ProvisioningStatus -eq "Already Provisioned"
    }
).Count

if ($alreadyProvisioned -eq 1) {
    Write-Host "[PASS] Duplicate access prevented: 1"
}
else {
    Write-Host "[FAIL] Duplicate access prevented: $alreadyProvisioned"
    $failed = $true
}

$req002 = $report | Where-Object {
    $_.RequestID -eq "REQ002"
}

if ($req002.ProvisioningStatus -eq "Already Provisioned") {
    Write-Host "[PASS] REQ002 duplicate provisioning prevented"
}
else {
    Write-Host "[FAIL] REQ002 duplicate provisioning was not prevented"
    $failed = $true
}

if ($req002.Reason -eq "Access already exists") {
    Write-Host "[PASS] REQ002 duplicate reason recorded"
}
else {
    Write-Host "[FAIL] REQ002 duplicate reason incorrect"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "DUPLICATE PROVISIONING TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "DUPLICATE PROVISIONING TEST RESULT: PASS"
    exit 0
}


