Write-Host "===== ACCESS REMEDIATION CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/AccessRemediationReport.csv"
$failed = $false

$compliant = @(
    $report | Where-Object {
        $_.Status -eq "Compliant"
    }
).Count

$remediationRequired = @(
    $report | Where-Object {
        $_.Status -eq "Remediation Required"
    }
).Count

if ($compliant -eq 2) {
    Write-Host "[PASS] Compliant access records: 2"
}
else {
    Write-Host "[FAIL] Compliant access records: $compliant"
    $failed = $true
}

if ($remediationRequired -eq 1) {
    Write-Host "[PASS] Remediation candidates detected: 1"
}
else {
    Write-Host "[FAIL] Remediation candidates detected: 
$remediationRequired"
    $failed = $true
}

$employee1003 = $report | Where-Object {
    $_.EmployeeID -eq "1003"
}

if ($employee1003.RemoveGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] Employee 1003 removal group identified"
}
else {
    Write-Host "[FAIL] Employee 1003 removal group incorrect"
    $failed = $true
}

if ($employee1003.AddGroup -eq "GG-Finance-Accountants") {
    Write-Host "[PASS] Employee 1003 required group identified"
}
else {
    Write-Host "[FAIL] Employee 1003 required group incorrect"
    $failed = $true
}

if ($employee1003.Status -eq "Remediation Required") {
    Write-Host "[PASS] Employee 1003 remediation required"
}
else {
    Write-Host "[FAIL] Employee 1003 remediation status incorrect"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "ACCESS REMEDIATION TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "ACCESS REMEDIATION TEST RESULT: PASS"
    exit 0
}
