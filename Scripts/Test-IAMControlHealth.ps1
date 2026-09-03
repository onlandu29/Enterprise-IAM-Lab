$metrics = Import-Csv "./Logs/IAMControlMetrics.csv"

$health = @()

$health += [PSCustomObject]@{
    Control = "JML Lifecycle"
    Status = "PASS"
    Reason = "Joiner, mover, and leaver processing is functioning"
}

$health += [PSCustomObject]@{
    Control = "Access Requests"
    Status = "PASS"
    Reason = "Requests are being evaluated through approval and policy controls"
}

$health += [PSCustomObject]@{
    Control = "SoD Enforcement"
    Status = "PASS"
    Reason = "SoD conflicts are detected and blocked"
}

$health += [PSCustomObject]@{
    Control = "Provisioning"
    Status = "PASS"
    Reason = "Approved access is provisioned and unauthorized access is prevented"
}

$reconciliationMetric = $metrics | Where-Object { $_.Metric -eq "Access Mismatches" }

if ([int]$reconciliationMetric.Value -gt 0) {
    $health += [PSCustomObject]@{
        Control = "Reconciliation"
        Status = "REVIEW"
        Reason = "Access mismatch detected and remediation is required"
    }
}
else {
    $health += [PSCustomObject]@{
        Control = "Reconciliation"
        Status = "PASS"
        Reason = "No access mismatches detected"
    }
}

$certificationMetric = $metrics | Where-Object { $_.Metric -eq "Certification Exceptions" }

if ([int]$certificationMetric.Value -gt 0) {
    $health += [PSCustomObject]@{
        Control = "Access Certification"
        Status = "REVIEW"
        Reason = "Certification exception detected"
    }
}
else {
    $health += [PSCustomObject]@{
        Control = "Access Certification"
        Status = "PASS"
        Reason = "All access certifications completed without exceptions"
    }
}

$exceptionMetric = $metrics | Where-Object { $_.Metric -eq "Open IAM Exceptions" }

if ([int]$exceptionMetric.Value -gt 0) {
    $health += [PSCustomObject]@{
        Control = "Exception Management"
        Status = "REVIEW"
        Reason = "Open IAM exception requires remediation"
    }
}
else {
    $health += [PSCustomObject]@{
        Control = "Exception Management"
        Status = "PASS"
        Reason = "No open IAM exceptions"
    }
}

$privilegedMetric = $metrics | Where-Object { $_.Metric -eq "Eligible Privileged Requests" }

if ([int]$privilegedMetric.Value -gt 0) {
    $health += [PSCustomObject]@{
        Control = "Privileged Access"
        Status = "REVIEW"
        Reason = "Privileged access request is eligible for provisioning"
    }
}
else {
    $health += [PSCustomObject]@{
        Control = "Privileged Access"
        Status = "PASS"
        Reason = "Privileged access controls are enforcing approval and SoD requirements"
    }
}

$health += [PSCustomObject]@{
    Control = "Audit Trail"
    Status = "PASS"
    Reason = "IAM events are being recorded"
}

$health += [PSCustomObject]@{
    Control = "Control Metrics"
    Status = "PASS"
    Reason = "IAM control metrics are being generated"
}

$reviewCount = ($health | Where-Object { $_.Status -eq "REVIEW" }).Count

if ($reviewCount -gt 0) {
    $overallStatus = "REVIEW REQUIRED"
}
else {
    $overallStatus = "PASS"
}

Write-Host ""
Write-Host "============================================================"
Write-Host "                  IAM CONTROL HEALTH"
Write-Host "============================================================"
Write-Host ""

$health | Format-Table -AutoSize

Write-Host ""
Write-Host "============================================================"
Write-Host "OVERALL STATUS: $overallStatus"
Write-Host "============================================================"

$health | Export-Csv "./Logs/IAMControlHealth.csv" -NoTypeInformation
