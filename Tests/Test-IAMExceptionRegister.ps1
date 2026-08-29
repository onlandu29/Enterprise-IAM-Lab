Write-Host "===== IAM EXCEPTION REGISTER CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/IAMExceptionRegister.csv"

$failed = $false

if ($report.Count -eq 1) {
    Write-Host "[PASS] Total exceptions: 1"
}
else {
    Write-Host "[FAIL] Total exceptions: $($report.Count)"
    $failed = $true
}

$exception = $report | Where-Object {
    $_.EmployeeID -eq "1003"
}

if ($exception) {
    Write-Host "[PASS] Employee 1003 exception identified"
}
else {
    Write-Host "[FAIL] Employee 1003 exception missing"
    $failed = $true
}

if ($exception.ExceptionType -eq "Access Mismatch") {
    Write-Host "[PASS] Exception type identified"
}
else {
    Write-Host "[FAIL] Incorrect exception type"
    $failed = $true
}

if ($exception.CurrentGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] Current access identified"
}
else {
    Write-Host "[FAIL] Current access incorrect"
    $failed = $true
}

if ($exception.ExpectedGroup -eq "GG-Finance-Accountants") {
    Write-Host "[PASS] Expected access identified"
}
else {
    Write-Host "[FAIL] Expected access incorrect"
    $failed = $true
}

if ($exception.RemediationStatus -eq "Remediation Required") {
    Write-Host "[PASS] Remediation requirement recorded"
}
else {
    Write-Host "[FAIL] Remediation requirement missing"
    $failed = $true
}

if ($exception.CertificationStatus -eq "Exception") {
    Write-Host "[PASS] Certification exception recorded"
}
else {
    Write-Host "[FAIL] Certification exception missing"
    $failed = $true
}

if ($exception.RequiredAction -eq "Remediate Access") {
    Write-Host "[PASS] Required remediation action identified"
}
else {
    Write-Host "[FAIL] Required remediation action incorrect"
    $failed = $true
}

if ($exception.ExceptionStatus -eq "Open") {
    Write-Host "[PASS] Exception status: Open"
}
else {
    Write-Host "[FAIL] Exception status incorrect"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "IAM EXCEPTION REGISTER TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "IAM EXCEPTION REGISTER TEST RESULT: PASS"
    exit 0
}
