Write-Host "=================================================="
Write-Host "        IAM EXCEPTION REGISTER ENGINE"
Write-Host "=================================================="
Write-Host ""

$reconciliation = Import-Csv "./Logs/AccessReconciliationReport.csv"
$remediation = Import-Csv "./Logs/AccessRemediationReport.csv"
$certification = Import-Csv "./Logs/AccessCertificationReport.csv"

$exceptionLog = @()

foreach ($record in $reconciliation) {

    if ($record.Reconciliation -eq "Mismatch") {

        $remediationRecord = $remediation | Where-Object {
            $_.EmployeeID -eq $record.EmployeeID
        }

        $certificationRecord = $certification | Where-Object {
            $_.EmployeeID -eq $record.EmployeeID
        }

        Write-Host "Exception detected for Employee: $($record.EmployeeID)"
        Write-Host "Employee Name: $($record.EmployeeName)"
        Write-Host "IAM Role: $($record.IAMRole)"
        Write-Host "Current Group: $($record.ActualGroup)"
        Write-Host "Expected Group: $($record.ExpectedGroup)"
        Write-Host "Control: Access Reconciliation"
        Write-Host "Exception Type: Access Mismatch"

        $remediationStatus = "Unknown"
        $certificationStatus = "Unknown"

        if ($remediationRecord) {
            $remediationStatus = $remediationRecord.Status
        }

        if ($certificationRecord) {
            $certificationStatus = $certificationRecord.CertificationStatus
        }

        Write-Host "Remediation Status: $remediationStatus"
        Write-Host "Certification Status: $certificationStatus"

        if ($remediationRecord) {
            $action = $remediationRecord.Action
        }
        else {
            $action = "Investigate"
        }

        $status = "Open"

        if ($remediationStatus -eq "Compliant" -and
            $certificationStatus -eq "Certified") {
            $status = "Resolved"
        }

        Write-Host "Exception Status: $status"
        Write-Host ""

        $exceptionLog += [PSCustomObject]@{
            ExceptionID          = "EXC-$($record.EmployeeID)"
            EmployeeID           = $record.EmployeeID
            EmployeeName         = $record.EmployeeName
            IAMRole               = $record.IAMRole
            CurrentGroup         = $record.ActualGroup
            ExpectedGroup        = $record.ExpectedGroup
            Control               = "Access Reconciliation"
            ExceptionType        = "Access Mismatch"
            RemediationStatus     = $remediationStatus
            CertificationStatus   = $certificationStatus
            RequiredAction        = $action
            ExceptionStatus       = $status
            Reason                = $record.Reason
        }
    }
}

$exceptionLog | Export-Csv "./Logs/IAMExceptionRegister.csv" -NoTypeInformation

Write-Host "=================================================="
Write-Host "Exception register generated successfully."
Write-Host ""
Write-Host "Total exceptions: $($exceptionLog.Count)"
Write-Host ""
Write-Host "Exception register saved to:"
Write-Host "Logs/IAMExceptionRegister.csv"
Write-Host "=================================================="
