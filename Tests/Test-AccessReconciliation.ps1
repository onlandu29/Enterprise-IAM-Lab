Write-Host "===== ACCESS RECONCILIATION CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/AccessReconciliationReport.csv"
$failed = $false

$matches = @(
    $report | Where-Object {
        $_.Reconciliation -eq "Match"
    }
).Count

$mismatches = @(
    $report | Where-Object {
        $_.Reconciliation -eq "Mismatch"
    }
).Count

if ($matches -eq 2) {
    Write-Host "[PASS] Matching access records: 2"
}
else {
    Write-Host "[FAIL] Matching access records: $matches"
    $failed = $true
}

if ($mismatches -eq 1) {
    Write-Host "[PASS] Access mismatches detected: 1"
}
else {
    Write-Host "[FAIL] Access mismatches detected: $mismatches"
    $failed = $true
}

$employee1003 = $report | Where-Object {
    $_.EmployeeID -eq "1003"
}

if ($employee1003.ExpectedGroup -eq "GG-Finance-Accountants") {
    Write-Host "[PASS] Employee 1003 expected group identified"
}
else {
    Write-Host "[FAIL] Employee 1003 expected group incorrect"
    $failed = $true
}

if ($employee1003.ActualGroup -eq "GG-Marketing-Users") {
    Write-Host "[PASS] Employee 1003 actual group identified"
}
else {
    Write-Host "[FAIL] Employee 1003 actual group incorrect"
    $failed = $true
}

if ($employee1003.Reconciliation -eq "Mismatch") {
    Write-Host "[PASS] Employee 1003 access mismatch detected"
}
else {
    Write-Host "[FAIL] Employee 1003 mismatch was not detected"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "ACCESS RECONCILIATION TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "ACCESS RECONCILIATION TEST RESULT: PASS"
    exit 0
}
