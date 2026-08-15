# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load employee data
$employees = Import-Csv "$projectRoot/Data/Employees.csv"

# Load SoD rules
$sodRules = Import-Csv "$projectRoot/Data/SoDRules.csv"

# Load access requests
$accessRequests = Import-Csv "$projectRoot/Data/AccessRequests.csv"

# Store SoD check results for reporting
$sodReport = @()

# Process each access request
foreach ($request in $accessRequests) {

    # Find the employee
    $employee = $employees | Where-Object EmployeeID -eq $request.EmployeeID

    if ($employee) {
        Write-Host "Processing Access Request: Employee $($request.EmployeeID)"
        Write-Host "Employee: $($employee.FirstName) $($employee.LastName)"
        Write-Host "Current Job Title: $($employee.JobTitle)"
        Write-Host "Requested IAM Role: $($request.RequestedRole)"
        Write-Host "Request Reason: $($request.RequestReason)"

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
            Write-Host "Reason: $($conflict.ConflictReason)"
            Write-Host "ACTION: BLOCK ACCESS REQUEST"

            $sodReport += [PSCustomObject]@{
                EmployeeID = $request.EmployeeID
                RequestedRole = $request.RequestedRole
                CurrentRole = $currentRole
                Decision = "Block"
                ConflictReason = $conflict.ConflictReason
                RequestReason = $request.RequestReason
            }
        }
        else {
            Write-Host "SOD CHECK: NO CONFLICT"
            Write-Host "ACTION: ALLOW ACCESS REQUEST"

            $sodReport += [PSCustomObject]@{
                EmployeeID = $request.EmployeeID
                RequestedRole = $request.RequestedRole
                CurrentRole = $currentRole
                Decision = "Allow"
                ConflictReason = ""
                RequestReason = $request.RequestReason
            }
        }

        Write-Host ""
    }
    else {
        Write-Host "Employee $($request.EmployeeID) was not found."
    }
}

# Display final SoD report
Write-Host "===== SOD CHECK REPORT ====="
$sodReport | Format-Table -AutoSize

# Export SoD report to CSV
$sodReport | Export-Csv "$projectRoot/Logs/SoD-CheckReport.csv" -NoTypeInformation

Write-Host ""
Write-Host "SoD check report saved to Logs/SoD-CheckReport.csv"