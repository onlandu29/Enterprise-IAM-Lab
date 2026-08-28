Write-Host "===== IAM AUDIT TRAIL CONTROL TEST ====="
Write-Host ""

$report = Import-Csv "./Logs/IAMAuditTrail.csv"

$failed = $false

$totalEvents = $report.Count

if ($totalEvents -eq 17) {
    Write-Host "[PASS] Total audit events: 17"
}
else {
    Write-Host "[FAIL] Total audit events: $totalEvents"
    $failed = $true
}

$accessRequests = @(
    $report | Where-Object {
        $_.EventType -eq "Access Request"
    }
).Count

if ($accessRequests -eq 4) {
    Write-Host "[PASS] Access request audit events: 4"
}
else {
    Write-Host "[FAIL] Access request audit events: $accessRequests"
    $failed = $true
}

$provisioning = @(
    $report | Where-Object {
        $_.EventType -eq "Provisioning"
    }
).Count

if ($provisioning -eq 4) {
    Write-Host "[PASS] Provisioning audit events: 4"
}
else {
    Write-Host "[FAIL] Provisioning audit events: $provisioning"
    $failed = $true
}

$reconciliation = @(
    $report | Where-Object {
        $_.EventType -eq "Access Reconciliation"
    }
).Count

if ($reconciliation -eq 3) {
    Write-Host "[PASS] Reconciliation audit events: 3"
}
else {
    Write-Host "[FAIL] Reconciliation audit events: $reconciliation"
    $failed = $true
}

$remediation = @(
    $report | Where-Object {
        $_.EventType -eq "Access Remediation"
    }
).Count

if ($remediation -eq 3) {
    Write-Host "[PASS] Remediation audit events: 3"
}
else {
    Write-Host "[FAIL] Remediation audit events: $remediation"
    $failed = $true
}

$certification = @(
    $report | Where-Object {
        $_.EventType -eq "Access Certification"
    }
).Count

if ($certification -eq 3) {
    Write-Host "[PASS] Certification audit events: 3"
}
else {
    Write-Host "[FAIL] Certification audit events: $certification"
    $failed = $true
}

$employee1003 = @(
    $report | Where-Object {
        $_.EmployeeID -eq "1003"
    }
)

if ($employee1003.Count -eq 7) {
    Write-Host "[PASS] Employee 1003 audit events: 7"
}
else {
    Write-Host "[FAIL] Employee 1003 audit events: $($employee1003.Count)"
    $failed = $true
}

$exception = $report | Where-Object {
    $_.EmployeeID -eq "1003" -and
    $_.EventType -eq "Access Certification" -and
    $_.Result -eq "Exception"
}

if ($exception) {
    Write-Host "[PASS] Employee 1003 certification exception recorded"
}
else {
    Write-Host "[FAIL] Employee 1003 certification exception missing"
    $failed = $true
}

$mismatch = $report | Where-Object {
    $_.EmployeeID -eq "1003" -and
    $_.EventType -eq "Access Reconciliation" -and
    $_.Result -eq "Mismatch"
}

if ($mismatch) {
    Write-Host "[PASS] Employee 1003 reconciliation mismatch recorded"
}
else {
    Write-Host "[FAIL] Employee 1003 reconciliation mismatch missing"
    $failed = $true
}

$remediationEvent = $report | Where-Object {
    $_.EmployeeID -eq "1003" -and
    $_.EventType -eq "Access Remediation" -and
    $_.Action -eq "Remediate Access"
}

if ($remediationEvent) {
    Write-Host "[PASS] Employee 1003 remediation action recorded"
}
else {
    Write-Host "[FAIL] Employee 1003 remediation action missing"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "IAM AUDIT TRAIL TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "IAM AUDIT TRAIL TEST RESULT: PASS"
    exit 0
}
