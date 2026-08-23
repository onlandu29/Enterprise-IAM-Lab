Write-Host "===== SOD CONTROL TEST ====="

$log = Import-Csv "./Logs/SoD-CheckReport.csv"

$allowed = ($log | Where-Object { $_.Decision -eq "Allow" }).Count
$blocked = ($log | Where-Object { $_.Decision -eq "Block" }).Count
$total = $log.Count

$passed = $true

if ($allowed -eq 1) {
    Write-Host "[PASS] Allowed requests: $allowed"
} else {
    Write-Host "[FAIL] Expected 1 allowed request, found $allowed"
    $passed = $false
}

if ($blocked -eq 2) {
    Write-Host "[PASS] Blocked requests: $blocked"
} else {
    Write-Host "[FAIL] Expected 2 blocked requests, found $blocked"
    $passed = $false
}

if ($total -eq 3) {
    Write-Host "[PASS] Total SoD checks: $total"
} else {
    Write-Host "[FAIL] Expected 3 SoD checks, found $total"
    $passed = $false
}

if ($total -gt 0) {
    $rate = [math]::Round(($blocked / $total) * 100, 2)

    if ($rate -eq 66.67) {
        Write-Host "[PASS] SoD block rate: $rate%"
    } else {
        Write-Host "[FAIL] Expected SoD block rate of 66.67%, found 
$rate%"
        $passed = $false
    }
}

Write-Host ""

if ($passed) {
    Write-Host "SOD TEST RESULT: PASS"
    exit 0
} else {
    Write-Host "SOD TEST RESULT: FAIL"
    exit 1
}
