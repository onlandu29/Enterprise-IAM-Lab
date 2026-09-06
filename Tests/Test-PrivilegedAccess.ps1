Write-Host "===== PRIVILEGED ACCESS GOVERNANCE CONTROL TEST ====="

Write-Host ""

$report = Import-Csv "./Logs/PrivilegedAccessReport.csv"

$failed = $false

$privileged = @(
    $report | Where-Object {
        $_.PrivilegeLevel -eq "Privileged"
    }
).Count

$standard = @(
    $report | Where-Object {
        $_.PrivilegeLevel -eq "Standard"
    }
).Count

$blockedPrivileged = @(
    $report | Where-Object {
        $_.PrivilegeLevel -eq "Privileged" -and
        $_.FinalDecision -eq "Blocked"
    }
).Count

$eligiblePrivileged = @(
    $report | Where-Object {
        $_.PrivilegeLevel -eq "Privileged" -and
        $_.PAGDecision -eq "Eligible"
    }
).Count

if ($privileged -eq 3) {
    Write-Host "[PASS] Privileged requests identified: 3"
}
else {
    Write-Host "[FAIL] Privileged requests identified: $privileged"
    $failed = $true
}

if ($standard -eq 1) {
    Write-Host "[PASS] Standard requests identified: 1"
}
else {
    Write-Host "[FAIL] Standard requests identified: $standard"
    $failed = $true
}

if ($blockedPrivileged -eq 2) {
    Write-Host "[PASS] Privileged requests blocked: 2"
}
else {
    Write-Host "[FAIL] Privileged requests blocked: $blockedPrivileged"
    $failed = $true
}

if ($eligiblePrivileged -eq 0) {
    Write-Host "[PASS] Eligible privileged requests: 0"
}
else {
    Write-Host "[FAIL] Eligible privileged requests: $eligiblePrivileged"
    $failed = $true
}

$payment = $report | Where-Object {
    $_.RequestID -eq "REQ001"
}

if (
    $payment.PrivilegeLevel -eq "Privileged" -and
    $payment.PAGDecision -eq "Blocked"
) {
    Write-Host "[PASS] REQ001 privileged payment access blocked"
}
else {
    Write-Host "[FAIL] REQ001 privileged payment access control failed"
    $failed = $true
}

$security = $report | Where-Object {
    $_.RequestID -eq "REQ003"
}

if (
    $security.PrivilegeLevel -eq "Privileged" -and
    $security.PAGDecision -eq "Blocked"
) {
    Write-Host "[PASS] REQ003 privileged security access blocked"
}
else {
    Write-Host "[FAIL] REQ003 privileged security access control failed"
    $failed = $true
}

$payroll = $report | Where-Object {
    $_.RequestID -eq "REQ004"
}

if (
    $payroll.PrivilegeLevel -eq "Privileged" -and
    $payroll.ManagerDecision -eq "Denied" -and
    $payroll.FinalDecision -eq "Denied"
) {
    Write-Host "[PASS] REQ004 privileged payroll access denied by manager"
}
else {
    Write-Host "[FAIL] REQ004 privileged payroll access denial control failed"
    $failed = $true
}

$marketing = $report | Where-Object {
    $_.RequestID -eq "REQ002"
}

if (
    $marketing.PrivilegeLevel -eq "Standard" -and
    $marketing.PAGDecision -eq "Eligible"
) {
    Write-Host "[PASS] REQ002 standard access eligible"
}
else {
    Write-Host "[FAIL] REQ002 standard access control failed"
    $failed = $true
}

Write-Host ""

if ($failed) {
    Write-Host "PRIVILEGED ACCESS GOVERNANCE TEST RESULT: FAIL"
    exit 1
}
else {
    Write-Host "PRIVILEGED ACCESS GOVERNANCE TEST RESULT: PASS"
    exit 0
}
