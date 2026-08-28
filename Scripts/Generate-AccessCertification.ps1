Write-Host "=================================================="
Write-Host "        IAM ACCESS CERTIFICATION ENGINE"
Write-Host "=================================================="
Write-Host ""

$remediation = Import-Csv "./Logs/AccessRemediationReport.csv"
$reviews = Import-Csv "./Logs/AccessReviewReport.csv"
$requests = Import-Csv "./Logs/AccessRequestReport.csv"

$certificationLog = @()

foreach ($record in $remediation) {

    $employeeID = $record.EmployeeID

    $reviewRecords = @(
        $reviews | Where-Object {
            $_.EmployeeID -eq $employeeID
        }
    )

    $requestRecords = @(
        $requests | Where-Object {
            $_.EmployeeID -eq $employeeID
        }
    )

    $certificationStatus = "Certified"
    $exceptionReason = "Access is compliant with assigned IAM role"

    if ($record.Status -eq "Remediation Required") {

        $certificationStatus = "Exception"
        $exceptionReason = "Access mismatch requires remediation"

    }
    elseif ($reviewRecords.Count -gt 0) {

        $revokeDecision = $reviewRecords | Where-Object {
            $_.Decision -eq "Revoke"
        }

        if ($revokeDecision.Count -gt 0) {

            $certificationStatus = "Exception"
            $exceptionReason = "Access review contains a revoke decision"

        }
    }

    $approvedRequests = @(
        $requestRecords | Where-Object {
            $_.FinalDecision -eq "Approved"
        }
    )

    Write-Host "Employee: $employeeID"
    Write-Host "Employee Name: $($record.EmployeeName)"
    Write-Host "IAM Role: $($record.IAMRole)"
    Write-Host "Current Group: $($record.CurrentGroup)"
    Write-Host "Expected Group: $($record.ExpectedGroup)"
    Write-Host "Reconciliation: $($record.Status)"
    Write-Host "Certification Status: $certificationStatus"
    Write-Host "Reason: $exceptionReason"
    Write-Host ""

    $certificationLog += [PSCustomObject]@{
        EmployeeID          = $employeeID
        EmployeeName        = $record.EmployeeName
        IAMRole             = $record.IAMRole
        CurrentGroup        = $record.CurrentGroup
        ExpectedGroup       = $record.ExpectedGroup
        Reconciliation      = $record.Status
        RemediationStatus   = $record.Status
        ApprovedRequests    = $approvedRequests.Count
        CertificationStatus = $certificationStatus
        ExceptionReason     = $exceptionReason
    }
}

$certificationLog |
    Export-Csv "./Logs/AccessCertificationReport.csv" -NoTypeInformation

Write-Host "=================================================="
Write-Host "Certification report saved to:"
Write-Host "Logs/AccessCertificationReport.csv"
Write-Host "=================================================="
