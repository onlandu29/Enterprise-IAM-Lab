Write-Host "===== ACCESS REVIEW CONTROL TEST ====="

$log = Import-Csv "./Logs/AccessReviewReport.csv"

$keep = ($log | Where-Object { $_.Decision -eq "Keep" }).Count
$revoke = ($log | Where-Object { $_.Decision -eq "Revoke" }).Count
$total = $log.Count

$passed = $true

if ($keep -eq 3) {
    Write-Host "[PASS] Keep decisions: $keep"
} else {
    Write-Host "[FAIL] Expected 3 Keep decisions, found $keep"
    $passed = $false
}

if ($revoke -eq 2) {
    Write-Host "[PASS] Revoke decisions: $revoke"
} else {
    Write-Host "[FAIL] Expected 2 Revoke decisions, found $revoke"
    $passed = $false
}

if ($total -eq 5) {
    Write-Host "[PASS] Total access reviews: $total"
} else {
    Write-Host "[FAIL] Expected 5 access reviews, found $total"
    $passed = $false
}

if ($total -gt 0) {
    $rate = [math]::Round(($revoke / $total) * 100, 2)

    if ($rate -eq 40) {
        Write-Host "[PASS] Revocation rate: $rate%"
    } else {
        Write-Host "[FAIL] Expected revocation rate of 40%, found $rate%"
        $passed = $false
    }
}

Write-Host ""

if ($passed) {
    Write-Host "ACCESS REVIEW TEST RESULT: PASS"
    exit 0
} else {
    Write-Host "ACCESS REVIEW TEST RESULT: FAIL"
    exit 1
}
