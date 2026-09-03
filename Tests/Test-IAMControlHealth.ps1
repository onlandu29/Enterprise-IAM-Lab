$health = Import-Csv "./Logs/IAMControlHealth.csv"

$failures = 0

function Test-Health {
    param (
        [string]$Control,
        [string]$ExpectedStatus
    )

    $result = $health | Where-Object { $_.Control -eq $Control }

    if ($null -eq $result) {
        Write-Host "[FAIL] Missing control: $Control"
        $script:failures++
    }
    elseif ($result.Status -ne $ExpectedStatus) {
        Write-Host "[FAIL] $Control expected $ExpectedStatus but found $($result.Status)"
        $script:failures++
    }
    else {
        Write-Host "[PASS] $Control status = $ExpectedStatus"
    }
}

Write-Host "===== IAM CONTROL HEALTH TEST ====="
Write-Host ""

Test-Health "JML Lifecycle" "PASS"
Test-Health "Access Requests" "PASS"
Test-Health "SoD Enforcement" "PASS"
Test-Health "Provisioning" "PASS"
Test-Health "Reconciliation" "REVIEW"
Test-Health "Access Certification" "REVIEW"
Test-Health "Exception Management" "REVIEW"
Test-Health "Privileged Access" "PASS"
Test-Health "Audit Trail" "PASS"
Test-Health "Control Metrics" "PASS"

$reviewCount = ($health | Where-Object { $_.Status -eq "REVIEW" }).Count

if ($reviewCount -eq 3) {
    Write-Host "[PASS] Review controls = 3"
}
else {
    Write-Host "[FAIL] Expected 3 review controls but found $reviewCount"
    $failures++
}

Write-Host ""

if ($failures -eq 0) {
    Write-Host "IAM CONTROL HEALTH TEST RESULT: PASS"
}
else {
    Write-Host "IAM CONTROL HEALTH TEST RESULT: FAIL"
    exit 1
}
