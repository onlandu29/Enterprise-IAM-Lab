$accessRequests = Import-Csv "./Logs/AccessRequestReport.csv"
$privilegedAccess = Import-Csv "./Logs/PrivilegedAccessReport.csv"
$reconciliation = Import-Csv "./Logs/AccessReconciliationReport.csv"
$certification = Import-Csv "./Logs/AccessCertificationReport.csv"
$exceptions = Import-Csv "./Logs/IAMExceptionRegister.csv"
$auditTrail = Import-Csv "./Logs/IAMAuditTrail.csv"

$totalRequests = $accessRequests.Count
$approvedRequests = ($accessRequests | Where-Object { $_.FinalDecision -eq "Approved" }).Count
$deniedRequests = ($accessRequests | Where-Object { $_.FinalDecision -eq "Denied" }).Count
$blockedRequests = ($accessRequests | Where-Object { $_.FinalDecision -eq "Blocked" }).Count

$totalPrivileged = ($privilegedAccess | Where-Object { $_.PrivilegeLevel -eq "Privileged" }).Count
$blockedPrivileged = ($privilegedAccess | Where-Object { $_.PrivilegeLevel -eq "Privileged" -and $_.FinalDecision -eq "Blocked" }).Count
$eligiblePrivileged = ($privilegedAccess | Where-Object { $_.PrivilegeLevel -eq "Privileged" -and $_.PAGDecision -eq "Eligible" }).Count

$totalReconciliation = $reconciliation.Count
$mismatches = ($reconciliation | Where-Object { $_.Reconciliation -eq "Mismatch" }).Count

$totalCertification = $certification.Count
$certificationExceptions = ($certification | Where-Object { $_.CertificationStatus -eq "Exception" }).Count

$totalExceptions = $exceptions.Count
$openExceptions = ($exceptions | Where-Object { $_.ExceptionStatus -eq "Open" }).Count

$totalAuditEvents = $auditTrail.Count

$metrics = @(
    [PSCustomObject]@{ Metric = "Total Access Requests"; Value = $totalRequests }
    [PSCustomObject]@{ Metric = "Approved Access Requests"; Value = $approvedRequests }
    [PSCustomObject]@{ Metric = "Denied Access Requests"; Value = $deniedRequests }
    [PSCustomObject]@{ Metric = "Blocked Access Requests"; Value = $blockedRequests }
    [PSCustomObject]@{ Metric = "Privileged Access Requests"; Value = $totalPrivileged }
    [PSCustomObject]@{ Metric = "Blocked Privileged Requests"; Value = $blockedPrivileged }
    [PSCustomObject]@{ Metric = "Eligible Privileged Requests"; Value = $eligiblePrivileged }
    [PSCustomObject]@{ Metric = "Access Reconciliation Checks"; Value = $totalReconciliation }
    [PSCustomObject]@{ Metric = "Access Mismatches"; Value = $mismatches }
    [PSCustomObject]@{ Metric = "Access Certifications"; Value = $totalCertification }
    [PSCustomObject]@{ Metric = "Certification Exceptions"; Value = $certificationExceptions }
    [PSCustomObject]@{ Metric = "IAM Exceptions"; Value = $totalExceptions }
    [PSCustomObject]@{ Metric = "Open IAM Exceptions"; Value = $openExceptions }
    [PSCustomObject]@{ Metric = "Audit Trail Events"; Value = $totalAuditEvents }
)

$metrics | Format-Table -AutoSize

$metrics | Export-Csv "./Logs/IAMControlMetrics.csv" -NoTypeInformation
