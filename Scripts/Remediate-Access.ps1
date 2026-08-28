Write-Host "=================================================="
Write-Host "        IAM ACCESS REMEDIATION ENGINE"
Write-Host "=================================================="
Write-Host ""

$reconciliation = Import-Csv "./Logs/AccessReconciliationReport.csv"

$remediationLog = @()

foreach ($record in $reconciliation) {

    Write-Host "Processing Employee: $($record.EmployeeID)"
    Write-Host "Employee Name: $($record.EmployeeName)"
    Write-Host "IAM Role: $($record.IAMRole)"
    Write-Host "Reconciliation Status: $($record.Reconciliation)"

    if ($record.Reconciliation -eq "Mismatch") {

        $action = "Remediate Access"
        $removeGroup = $record.ActualGroup
        $addGroup = $record.ExpectedGroup
        $status = "Remediation Required"
        $reason = "Actual access does not match assigned IAM role"

        Write-Host "ACTION: REMEDIATION REQUIRED"
        Write-Host "Remove Group: $removeGroup"
        Write-Host "Add Group: $addGroup"
        Write-Host "Reason: $reason"

    }
    elseif ($record.Reconciliation -eq "Match") {

        $action = "No Action"
        $removeGroup = ""
        $addGroup = ""
        $status = "Compliant"
        $reason = "Access matches assigned IAM role"

        Write-Host "ACTION: NO REMEDIATION REQUIRED"
        Write-Host "Status: COMPLIANT"
    }
    else {

        $action = "Investigate"
        $removeGroup = ""
        $addGroup = ""
        $status = "Investigation Required"
        $reason = "Reconciliation result requires investigation"

        Write-Host "ACTION: INVESTIGATION REQUIRED"
        Write-Host "Reason: $reason"
    }

    $remediationLog += [PSCustomObject]@{
        EmployeeID      = $record.EmployeeID
        EmployeeName    = $record.EmployeeName
        IAMRole         = $record.IAMRole
        CurrentGroup    = $record.ActualGroup
        ExpectedGroup   = $record.ExpectedGroup
        Action          = $action
        RemoveGroup     = $removeGroup
        AddGroup        = $addGroup
        Status          = $status
        Reason          = $reason
    }

    Write-Host ""
}

$remediationLog | Export-Csv "./Logs/AccessRemediationReport.csv"

Write-Host "=================================================="
Write-Host "Remediation report saved to:"
Write-Host "Logs/AccessRemediationReport.csv"
Write-Host "=================================================="
