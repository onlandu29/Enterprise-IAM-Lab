Write-Host "===== IAM REPORTING ENGINE TEST ====="

$passed = $true

Write-Host ""
Write-Host "Checking JML metrics..."

$jml = Import-Csv "./Logs/JML-AccessReport.csv"

$joiners = ($jml | Where-Object { $_.ChangeType -eq "Joiner" }).Count
$movers = ($jml | Where-Object { $_.ChangeType -eq "Mover" }).Count
$leavers = ($jml | Where-Object { $_.ChangeType -eq "Leaver" }).Count

if ($joiners -eq 1 -and $movers -eq 1 -and $leavers -eq 1) {
    Write-Host "[PASS] JML metrics match expected values"
} else {
    Write-Host "[FAIL] JML metrics do not match"
    $passed = $false
}

Write-Host ""
Write-Host "Checking Access Review metrics..."

$reviews = Import-Csv "./Logs/AccessReviewReport.csv"

$keep = ($reviews | Where-Object { $_.Decision -eq "Keep" }).Count
$revoke = ($reviews | Where-Object { $_.Decision -eq "Revoke" }).Count

if ($keep -eq 3 -and $revoke -eq 2) {
    Write-Host "[PASS] Access Review metrics match expected values"
} else {
    Write-Host "[FAIL] Access Review metrics do not match"
    $passed = $false
}

Write-Host ""
Write-Host "Checking SoD metrics..."

$sod = Import-Csv "./Logs/SoD-CheckReport.csv"

$allowed = ($sod | Where-Object { $_.Decision -eq "Allow" }).Count
$blocked = ($sod | Where-Object { $_.Decision -eq "Block" }).Count

if ($allowed -eq 1 -and $blocked -eq 2) {
    Write-Host "[PASS] SoD metrics match expected values"
} else {
    Write-Host "[FAIL] SoD metrics do not match"
    $passed = $false
}

Write-Host ""
Write-Host "Checking Access Request metrics..."

$requests = Import-Csv "./Logs/AccessRequestReport.csv"

$approved = ($requests | Where-Object { $_.FinalDecision -eq "Approved" 
}).Count
$requestBlocked = ($requests | Where-Object { $_.FinalDecision -eq 
"Blocked" }).Count
$denied = ($requests | Where-Object { $_.FinalDecision -eq "Denied" 
}).Count

if ($approved -eq 1 -and $requestBlocked -eq 2 -and $denied -eq 1) {
    Write-Host "[PASS] Access Request metrics match expected values"
} else {
    Write-Host "[FAIL] Access Request metrics do not match"
    $passed = $false
}

Write-Host ""

if ($passed) {
    Write-Host "IAM REPORTING TEST RESULT: PASS"
    exit 0
} else {
    Write-Host "IAM REPORTING TEST RESULT: FAIL"
    exit 1
}
