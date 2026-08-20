# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load IAM audit reports
$jmlReport = Import-Csv "$projectRoot/Logs/JML-AccessReport.csv"
$accessReviewReport = Import-Csv "$projectRoot/Logs/AccessReviewReport.csv"
$sodReport = Import-Csv "$projectRoot/Logs/SoD-CheckReport.csv"
$accessRequestReport = Import-Csv "$projectRoot/Logs/AccessRequestReport.csv"

# Calculate JML metrics
$jmlJoiners = ($jmlReport | Where-Object ChangeType -eq "Joiner").Count
$jmlMovers = ($jmlReport | Where-Object ChangeType -eq "Mover").Count
$jmlLeavers = ($jmlReport | Where-Object ChangeType -eq "Leaver").Count

# Calculate Access Review metrics
$accessKeep = ($accessReviewReport | Where-Object Decision -eq "Keep").Count
$accessRevoke = ($accessReviewReport | Where-Object Decision -eq "Revoke").Count

# Calculate SoD metrics
$sodBlocked = ($sodReport | Where-Object Decision -eq "Block").Count
$sodAllowed = ($sodReport | Where-Object Decision -eq "Allow").Count

# Calculate Access Request metrics
$requestsApproved = ($accessRequestReport | Where-Object FinalDecision -eq "Approved").Count
$requestsBlocked = ($accessRequestReport | Where-Object FinalDecision -eq "Blocked").Count
$requestsDenied = ($accessRequestReport | Where-Object FinalDecision -eq "Denied").Count

# Calculate Access Review revocation rate
$totalAccessReviews = $accessKeep + $accessRevoke

if ($totalAccessReviews -gt 0) {
    $accessRevokeRate = [math]::Round(($accessRevoke / $totalAccessReviews) * 100, 2)
}
else {
    $accessRevokeRate = 0
}

# Calculate SoD block rate
$totalSodChecks = $sodAllowed + $sodBlocked

if ($totalSodChecks -gt 0) {
    $sodBlockRate = [math]::Round(($sodBlocked / $totalSodChecks) * 100, 2)
}
else {
    $sodBlockRate = 0
}

# Calculate Access Request rates
$totalAccessRequests = $requestsApproved + $requestsBlocked + $requestsDenied

if ($totalAccessRequests -gt 0) {
    $requestApprovalRate = [math]::Round(($requestsApproved / $totalAccessRequests) * 100, 2)
    $requestRejectionRate = [math]::Round((($requestsBlocked + $requestsDenied) / $totalAccessRequests) * 100, 2)
}
else {
    $requestApprovalRate = 0
    $requestRejectionRate = 0
}

# Identify risk indicators
$riskIndicators = @()

if ($sodBlocked -gt 0) {
    $riskIndicators += "$sodBlocked SoD conflict(s) detected and blocked"
}

if ($accessRevoke -gt 0) {
    $riskIndicators += "$accessRevoke access review finding(s) resulted in revocation"
}

if ($requestsBlocked -gt 0) {
    $riskIndicators += "$requestsBlocked access request(s) blocked by SoD controls"
}

if ($requestsDenied -gt 0) {
    $riskIndicators += "$requestsDenied access request(s) denied by management"
}

# Build executive report
$report = @()

$report += "============================================================"
$report += "             ENTERPRISE IAM GOVERNANCE REPORT"
$report += "============================================================"
$report += ""
$report += "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
$report += ""

$report += "------------------------------------------------------------"
$report += "JML LIFECYCLE ACTIVITY"
$report += "------------------------------------------------------------"
$report += "Joiners: $jmlJoiners"
$report += "Movers:  $jmlMovers"
$report += "Leavers: $jmlLeavers"
$report += ""

$report += "------------------------------------------------------------"
$report += "ACCESS REVIEW ACTIVITY"
$report += "------------------------------------------------------------"
$report += "Access Reviews: $totalAccessReviews"
$report += "Access Kept: $accessKeep"
$report += "Access Revoked: $accessRevoke"
$report += "Revocation Rate: $accessRevokeRate%"
$report += ""

$report += "------------------------------------------------------------"
$report += "SEGREGATION OF DUTIES"
$report += "------------------------------------------------------------"
$report += "SoD Checks: $totalSodChecks"
$report += "Allowed: $sodAllowed"
$report += "Blocked: $sodBlocked"
$report += "Block Rate: $sodBlockRate%"
$report += ""

$report += "------------------------------------------------------------"
$report += "ACCESS REQUEST GOVERNANCE"
$report += "------------------------------------------------------------"
$report += "Total Requests: $totalAccessRequests"
$report += "Approved: $requestsApproved"
$report += "Blocked by SoD: $requestsBlocked"
$report += "Denied by Management: $requestsDenied"
$report += "Approval Rate: $requestApprovalRate%"
$report += "Rejection/Block Rate: $requestRejectionRate%"
$report += ""

$report += "------------------------------------------------------------"
$report += "CONTROL FINDINGS"
$report += "------------------------------------------------------------"

if ($riskIndicators.Count -gt 0) {
    foreach ($risk in $riskIndicators) {
        $report += "[CONTROL] $risk"
    }
}
else {
    $report += "[OK] No significant risk indicators detected"
}

$report += ""

$report += "------------------------------------------------------------"
$report += "CONTROL SUMMARY"
$report += "------------------------------------------------------------"
$report += "[OK] RBAC role and group assignments"
$report += "[OK] Joiner/Mover/Leaver lifecycle processing"
$report += "[OK] Periodic access review"
$report += "[OK] Segregation of Duties validation"
$report += "[OK] Manager access approval"
$report += "[OK] Access request audit logging"
$report += "[OK] IAM governance metrics"
$report += ""

$report += "============================================================"
$report += "                    END OF REPORT"
$report += "============================================================"

# Display report
$report | ForEach-Object { Write-Host $_ }

# Save report
$reportPath = "$projectRoot/Logs/IAM-Executive-Report.txt"
$report | Out-File $reportPath -Encoding utf8

Write-Host ""
Write-Host "Executive report saved to Logs/IAM-Executive-Report.txt"