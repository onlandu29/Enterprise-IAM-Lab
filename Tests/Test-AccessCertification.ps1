Write-Host "===== ACCESS CERTIFICATION CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/AccessCertificationReport.csv"

$failed = $false

$certified = @(
    $report | Where-Object {
        $_.CertificationStatus -eq "Certified"
    }
).Count

$exceptions = @(
    $report | Where-Object {
        $_.CertificationStatus -eq "Exception"
    }
).Count

if ($certified -eq 2) {
    Write-Host "[PASS] Certified employees: 2"
}
else {
    Write-Host "[FAIL] Certified employees: $certified"
    $failed = $true
}

if ($exceptions -eq 1) {
    Write-Host "[PASS] Certification exceptions detected: 1"
}
else {
    Write-Host "[FAIL] Certification exceptions detected: $exceptions"
    $failed = $true
}

$employee1001 = $report | Where-Object {
    $_.EmployeeID -eq "1001"
}

if ($employee1001.CertificationStatus -eq "Certified") {
    Write-Host "[PASS] Employee 1001 certified"
}
else {
    Write-Host "[FAIL] Employee 1001 certification status incorrect"
    $failed = $true
}

$employee1002 = $report | Where-Object {
    $_.EmployeeID -eq "1002"
}

if ($employee1002.CertificationStatus -eq "Certified") {
    Write-Host "[PASS] Employee 1002 certified"
}
else {
    Write-Host "[FAIL] Employee 1002 certification status incorrect"
    $failed = $true
}

$employee1003 = $report | Where-Object {
    $_.EmployeeID -eq "1003"
}

if ($employee1003.CertificationStatus -eq "Exception") {
    Write-Host "[PASS] Employee 1003 flagged as exception"
}
else {
    Write-Host "[FAIL] Employee 1003 exception not detected"
    $failed = $true
}

if ($employee1003.ExpectedGroup -eq "GG-Finance-Accountants") {
    Write-Host "[PASS] Employee 1003 expected access preserved"
}
else {
    Write-Host "[FAIL] Employee 1003 expected access incorrect"
    $failed = $true
}

if ($employee1003.CurrentGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] Employee 1003 actual access preserved"
}
else {
    Write-Host "[FAIL] Employee 1003 actual access incorrect"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "ACCESS CERTIFICATION TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "ACCESS CERTIFICATION TEST RESULT: PASS"
    exit 0
}
