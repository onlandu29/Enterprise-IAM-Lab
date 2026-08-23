Write-Host "===== JML CONTROL TEST ====="

$log = Import-Csv "./Logs/JML-AccessReport.csv"

$joiners = ($log | Where-Object { $_.ChangeType -eq "Joiner" }).Count
$movers = ($log | Where-Object { $_.ChangeType -eq "Mover" }).Count
$leavers = ($log | Where-Object { $_.ChangeType -eq "Leaver" }).Count

$passed = $true

if ($joiners -eq 1) {
    Write-Host "[PASS] Joiner records: $joiners"
} else {
    Write-Host "[FAIL] Expected 1 Joiner, found $joiners"
    $passed = $false
}

if ($movers -eq 1) {
    Write-Host "[PASS] Mover records: $movers"
} else {
    Write-Host "[FAIL] Expected 1 Mover, found $movers"
    $passed = $false
}

if ($leavers -eq 1) {
    Write-Host "[PASS] Leaver records: $leavers"
} else {
    Write-Host "[FAIL] Expected 1 Leaver, found $leavers"
    $passed = $false
}

Write-Host ""

if ($passed) {
    Write-Host "JML TEST RESULT: PASS"
} else {
    Write-Host "JML TEST RESULT: FAIL"
}
