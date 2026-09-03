$metrics = Import-Csv "./Logs/IAMControlMetrics.csv"

$failures = 0

function Test-Metric {
    param (
        [string]$Name,
        [int]$Expected
    )

    $metric = $metrics | Where-Object { $_.Metric -eq $Name }

    if ($null -eq $metric) {
        Write-Host "[FAIL] Missing metric: $Name"
        $script:failures++
    }
    elseif ([int]$metric.Value -ne $Expected) {
        Write-Host "[FAIL] $Name expected $Expected but found 
$($metric.Value)"
        $script:failures++
    }
    else {
        Write-Host "[PASS] $Name = $Expected"
    }
}

Write-Host "===== IAM CONTROL METRICS TEST ====="
Write-Host ""

Test-Metric "Total Access Requests" 4
Test-Metric "Approved Access Requests" 1
Test-Metric "Denied Access Requests" 1
Test-Metric "Blocked Access Requests" 2
Test-Metric "Privileged Access Requests" 3
Test-Metric "Blocked Privileged Requests" 2
Test-Metric "Eligible Privileged Requests" 0
Test-Metric "Access Reconciliation Checks" 3
Test-Metric "Access Mismatches" 1
Test-Metric "Access Certifications" 3
Test-Metric "Certification Exceptions" 1
Test-Metric "IAM Exceptions" 1
Test-Metric "Open IAM Exceptions" 1
Test-Metric "Audit Trail Events" 17

Write-Host ""

if ($failures -eq 0) {
    Write-Host "IAM CONTROL METRICS TEST RESULT: PASS"
}
else {
    Write-Host "IAM CONTROL METRICS TEST RESULT: FAIL"
    exit 1
}
