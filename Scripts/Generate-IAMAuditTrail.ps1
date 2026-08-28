Write-Host "=================================================="
Write-Host "          IAM AUDIT TRAIL ENGINE"
Write-Host "=================================================="
Write-Host ""

$accessRequests = Import-Csv "./Logs/AccessRequestReport.csv"
$provisioning = Import-Csv "./Logs/Provisioning-AccessReport.csv"
$reconciliation = Import-Csv "./Logs/AccessReconciliationReport.csv"
$remediation = Import-Csv "./Logs/AccessRemediationReport.csv"
$certification = Import-Csv "./Logs/AccessCertificationReport.csv"

$auditLog = @()

# Access Request Events
foreach ($record in $accessRequests) {

    $auditLog += [PSCustomObject]@{
        EventType       = "Access Request"
        EmployeeID      = $record.EmployeeID
        ReferenceID     = $record.RequestID
        Role            = $record.RequestedRole
        Control         = "Access Request Governance"
        Result          = $record.FinalDecision
        Action          = $record.FinalDecision
        Details         = $record.Reason
    }
}

# Provisioning Events
foreach ($record in $provisioning) {

    $auditLog += [PSCustomObject]@{
        EventType       = "Provisioning"
        EmployeeID      = $record.EmployeeID
        ReferenceID     = $record.RequestID
        Role            = $record.RequestedRole
        Control         = "Access Provisioning"
        Result          = $record.ProvisioningStatus
        Action          = $record.ProvisioningStatus
        Details         = $record.Reason
    }
}

# Reconciliation Events
foreach ($record in $reconciliation) {

    $auditLog += [PSCustomObject]@{
        EventType       = "Access Reconciliation"
        EmployeeID      = $record.EmployeeID
        ReferenceID     = ""
        Role            = $record.IAMRole
        Control         = "Access Reconciliation"
        Result          = $record.Reconciliation
        Action          = $record.Reconciliation
        Details         = $record.Reason
    }
}

# Remediation Events
foreach ($record in $remediation) {

    $auditLog += [PSCustomObject]@{
        EventType       = "Access Remediation"
        EmployeeID      = $record.EmployeeID
        ReferenceID     = ""
        Role            = $record.IAMRole
        Control         = "Access Remediation"
        Result          = $record.Status
        Action          = $record.Action
        Details         = $record.Reason
    }
}

# Certification Events
foreach ($record in $certification) {

    $auditLog += [PSCustomObject]@{
        EventType       = "Access Certification"
        EmployeeID      = $record.EmployeeID
        ReferenceID     = ""
        Role            = $record.IAMRole
        Control         = "Access Certification"
        Result          = $record.CertificationStatus
        Action          = $record.CertificationStatus
        Details         = $record.ExceptionReason
    }
}

$auditLog | Export-Csv "./Logs/IAMAuditTrail.csv" -NoTypeInformation

Write-Host "Audit trail generated successfully."
Write-Host ""
Write-Host "Total audit events: $($auditLog.Count)"
Write-Host ""
Write-Host "Audit trail saved to:"
Write-Host "Logs/IAMAuditTrail.csv"
Write-Host "=================================================="
