Write-Host "===== ACCESS REQUEST GOVERNANCE TEST ====="

$log = Import-Csv "./Logs/AccessRequestReport.csv"

$approved = ($log | Where-Object { $_.FinalDecision -eq "Approved" 
}).Count
$blocked = ($log | Where-Object { $_.FinalDecision -eq "Blocked" }).Count
$denied = ($log | Where-Object { $_.FinalDecision -eq "Denied" }).Count
$total = $log.Count

$passed = $true

if ($approved -eq 1) {
    Write-Host "[PASS] Approved requests: $approved"
} else {
    Write-Host "[FAIL] Expected 1 approved request, found $approved"
    $passed = $false
}

if ($blocked -eq 2) {
    Write-Host "[PASS] SoD-blocked requests: $blocked"
} else {
    Write-Host "[FAIL] Expected 2 blocked requests, found $blocked"
    $passed = $false
}

if ($denied -eq 1) {
    Write-Host "[PASS] Management-denied requests: $denied"
} else {
    Write-Host "[FAIL] Expected 1 denied request, found $denied"
    $passed = $false
}

if ($total -eq 4) {
    Write-Host "[PASS] Total access requests: $total"
} else {
    Write-Host "[FAIL] Expected 4 access requests, found $total"
    $passed = $false
}

if ($total -gt 0) {
    $approvalRate = [math]::Round(($approved / $total) * 100, 2)
    $rejectionRate = [math]::Round((($blocked + $denied) / $total) * 100, 
2)

    if ($approvalRate -eq 25) {
        Write-Host "[PASS] Approval rate: $approvalRate%"
    } else {
        Write-Host "[FAIL] Expected approval rate of 25%, found 
$approvalRate%"
        $passed = $false
    }

    if ($rejectionRate -eq 75) {
        Write-Host "[PASS] Rejection/block rate: $rejectionRate%"
    } else {
        Write-Host "[FAIL] Expected rejection/block rate of 75%, found 
$rejectionRate%"
        $passed = $false
    }
}

Write-Host ""

if ($passed) {
    Write-Host "ACCESS REQUEST TEST RESULT: PASS"
} else {
    Write-Host "ACCESS REQUEST TEST RESULT: FAIL"
}
