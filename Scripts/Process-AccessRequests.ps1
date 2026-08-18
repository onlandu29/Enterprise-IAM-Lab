# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load employee data
$employees = Import-Csv "$projectRoot/Data/Employees.csv"

# Load access request approvals
$requests = Import-Csv "$projectRoot/Data/AccessRequestApprovals.csv"

# Load SoD rules
$sodRules = Import-Csv "$projectRoot/Data/SoDRules.csv"

# Store access request results for reporting
$requestReport = @()

# Process each access request
foreach ($request in $requests) {

    # Find the employee
    $employee = $employees | Where-Object EmployeeID -eq $request.EmployeeID

    if ($employee) {
        Write-Host "Processing Request: $($request.RequestID)"
        Write-Host "Employee: $($employee.FirstName) $($employee.LastName)"
        Write-Host "Requested Role: $($request.RequestedRole)"
        Write-Host "Manager Decision: $($request.ManagerDecision)"
        Write-Host "Reason: $($request.Reason)"

        # Check manager approval before performing security checks
        if ($request.ManagerDecision -eq "Denied") {
            Write-Host "ACTION: DENY REQUEST"
            Write-Host "Reason: Manager did not approve the request"

            $requestReport += [PSCustomObject]@{
                RequestID = $request.RequestID
                EmployeeID = $request.EmployeeID
                RequestedRole = $request.RequestedRole
                CurrentRole = ""
                ManagerDecision = "Denied"
                FinalDecision = "Denied"
                Reason = $request.Reason
                ConflictReason = ""
            }
        }
        elseif ($request.ManagerDecision -eq "Approved") {
            Write-Host "ACTION: MANAGER APPROVED"
            Write-Host "Proceeding to SoD check"

            # Determine the employee's current IAM role
            $currentRole = switch ($employee.JobTitle) {
                "Help Desk Technician" { "IT_HelpDesk" }
                "HR Specialist" { "HR_User" }
                "Accountant" { "Finance_Accountant" }
                "Marketing Coordinator" { "Marketing_User" }
                "Sales Representative" { "Sales_User" }
                default { $null }
            }

            Write-Host "Current IAM Role: $currentRole"

            # Check for a conflicting role combination
            $conflict = $sodRules | Where-Object {
                ($_.Role1 -eq $currentRole -and $_.Role2 -eq $request.RequestedRole) -or
                ($_.Role1 -eq $request.RequestedRole -and $_.Role2 -eq $currentRole)
            }

            if ($conflict) {
                Write-Host "SOD CHECK: CONFLICT DETECTED"
                Write-Host "Conflict Reason: $($conflict.ConflictReason)"
                Write-Host "ACTION: BLOCK REQUEST"

                $requestReport += [PSCustomObject]@{
                    RequestID = $request.RequestID
                    EmployeeID = $request.EmployeeID
                    RequestedRole = $request.RequestedRole
                    CurrentRole = $currentRole
                    ManagerDecision = "Approved"
                    FinalDecision = "Blocked"
                    Reason = $request.Reason
                    ConflictReason = $conflict.ConflictReason
                }
            }
            else {
                Write-Host "SOD CHECK: NO CONFLICT"
                Write-Host "ACTION: APPROVE ACCESS"

                $requestReport += [PSCustomObject]@{
                    RequestID = $request.RequestID
                    EmployeeID = $request.EmployeeID
                    RequestedRole = $request.RequestedRole
                    CurrentRole = $currentRole
                    ManagerDecision = "Approved"
                    FinalDecision = "Approved"
                    Reason = $request.Reason
                    ConflictReason = ""
                }
            }
        }
        else {
            Write-Host "Unknown manager decision: $($request.ManagerDecision)"
        }
    }
    else {
        Write-Host "Employee $($request.EmployeeID) was not found."
    }
}

# Display final access request report
Write-Host ""
Write-Host "===== ACCESS REQUEST REPORT ====="
$requestReport | Format-Table -AutoSize

# Export access request report to CSV
$requestReport | Export-Csv "$projectRoot/Logs/AccessRequestReport.csv" -NoTypeInformation

Write-Host ""
Write-Host "Access request report saved to Logs/AccessRequestReport.csv"