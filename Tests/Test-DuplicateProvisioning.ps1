Write-Host "===== DUPLICATE PROVISIONING CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/Provisioning-AccessReport.csv"

$duplicateRecord = $report | Where-Object {
    $_.RequestID -eq "REQ002"
}

if ($duplicateRecord.ProvisioningStatus -eq "Already Provisioned") {
    Write-Host "[PASS] Existing access was not provisioned again"
}
else {
    Write-Host "[FAIL] Duplicate access was provisioned"
    exit 1
}

if ($duplicateRecord.Reason -eq "Access already exists") {
    Write-Host "[PASS] Duplicate provisioning reason recorded"
}
else {
    Write-Host "[FAIL] Duplicate provisioning reason missing"
    exit 1
}


Write-Host ""
Write-Host "DUPLICATE PROVISIONING TEST RESULT: PASS"

exit 0
