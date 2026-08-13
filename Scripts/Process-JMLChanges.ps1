# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load employee data
$employees = Import-Csv "$projectRoot/Data/Employees.csv"

# Load employee lifecycle changes
$changes = Import-Csv "$projectRoot/Data/EmployeeChanges.csv"

# Load role-to-group mappings
$roleGroups = Import-Csv "$projectRoot/Data/RoleGroups.csv"

# Load group permissions
$permissions = Import-Csv "$projectRoot/Data/GroupPermissions.csv"

# Store JML access changes for reporting
$accessReport = @()

# Process each lifecycle change
foreach ($change in $changes) {

    # Find the existing employee
    $employee = $employees | Where-Object EmployeeID -eq $change.EmployeeID

    # Determine the lifecycle event
    switch ($change.ChangeType) {

        "Joiner" {
            Write-Host "Processing Joiner: Employee $($change.EmployeeID)"

            # Determine IAM role from the new employee's job title
            $joinerRole = switch ($change.NewJobTitle) {
                "Help Desk Technician" { "IT_HelpDesk" }
                "HR Specialist" { "HR_User" }
                "Accountant" { "Finance_Accountant" }
                "Marketing Coordinator" { "Marketing_User" }
                "Sales Representative" { "Sales_User" }
                default { $null }
            }

            # Find the security group for the IAM role
            $joinerGroup = $roleGroups | Where-Object IAMRole -eq $joinerRole

            if ($joinerGroup) {
                Write-Host "IAM Role: $joinerRole"
                Write-Host "Security Group: $($joinerGroup.SecurityGroup)"

                # Find permissions for the security group
                $joinerPermissions = $permissions | Where-Object SecurityGroup -eq $joinerGroup.SecurityGroup

                if ($joinerPermissions) {
                    Write-Host "Permissions:"

                    foreach ($permission in $joinerPermissions) {
                        Write-Host " - $($permission.Permission)"
                    }
                }
                else {
                    Write-Host "No permissions found for security group: $($joinerGroup.SecurityGroup)"
                }

                # Add Joiner action to report
                $accessReport += [PSCustomObject]@{
                    EmployeeID = $change.EmployeeID
                    ChangeType = "Joiner"
                    Action = "Provision"
                    OldGroup = ""
                    NewGroup = $joinerGroup.SecurityGroup
                    Status = "Approved"
                }
            }
            else {
                Write-Host "No approved group mapping found for role: $joinerRole"
            }
        }

        "Mover" {
            Write-Host "Processing Mover: Employee $($change.EmployeeID)"

            if ($employee) {
                Write-Host "Current Job Title: $($employee.JobTitle)"

                # Determine the employee's current IAM role
                $currentRole = switch ($employee.JobTitle) {
                    "Help Desk Technician" { "IT_HelpDesk" }
                    "HR Specialist" { "HR_User" }
                    "Accountant" { "Finance_Accountant" }
                    "Marketing Coordinator" { "Marketing_User" }
                    "Sales Representative" { "Sales_User" }
                    default { $null }
                }

                # Find the employee's current security group
                $currentGroup = $roleGroups | Where-Object IAMRole -eq $currentRole

                Write-Host "Current IAM Role: $currentRole"
                Write-Host "Current Security Group: $($currentGroup.SecurityGroup)"
                Write-Host "New Job Title: $($change.NewJobTitle)"

                # Determine the new IAM role
                $newRole = switch ($change.NewJobTitle) {
                    "Help Desk Technician" { "IT_HelpDesk" }
                    "HR Specialist" { "HR_User" }
                    "Accountant" { "Finance_Accountant" }
                    "Marketing Coordinator" { "Marketing_User" }
                    "Sales Representative" { "Sales_User" }
                    default { $null }
                }

                # Find the new security group
                $newGroup = $roleGroups | Where-Object IAMRole -eq $newRole

                if ($newGroup) {
                    Write-Host "New IAM Role: $newRole"
                    Write-Host "New Security Group: $($newGroup.SecurityGroup)"

                    # Simulate removing the old access
                    Write-Host "REMOVE: $($currentGroup.SecurityGroup)"

                    # Simulate assigning the new access
                    Write-Host "ADD: $($newGroup.SecurityGroup)"

                    # Add Mover action to report
                    $accessReport += [PSCustomObject]@{
                        EmployeeID = $change.EmployeeID
                        ChangeType = "Mover"
                        Action = "Replace Access"
                        OldGroup = $currentGroup.SecurityGroup
                        NewGroup = $newGroup.SecurityGroup
                        Status = "Approved"
                    }
                }
                else {
                    Write-Host "No approved group mapping found for role: $newRole"
                }
            }
            else {
                Write-Host "Employee $($change.EmployeeID) was not found."
            }
        }

        "Leaver" {
            Write-Host "Processing Leaver: Employee $($change.EmployeeID)"

            if ($employee) {
                Write-Host "Employee: $($employee.FirstName) $($employee.LastName)"
                Write-Host "Current Job Title: $($employee.JobTitle)"

                # Determine the employee's current IAM role
                $currentRole = switch ($employee.JobTitle) {
                    "Help Desk Technician" { "IT_HelpDesk" }
                    "HR Specialist" { "HR_User" }
                    "Accountant" { "Finance_Accountant" }
                    "Marketing Coordinator" { "Marketing_User" }
                    "Sales Representative" { "Sales_User" }
                    default { $null }
                }

                # Find the employee's current security group
                $currentGroup = $roleGroups | Where-Object IAMRole -eq $currentRole

                if ($currentGroup) {
                    Write-Host "Current IAM Role: $currentRole"
                    Write-Host "Current Security Group: $($currentGroup.SecurityGroup)"

                    # Simulate removing all access
                    Write-Host "REMOVE: $($currentGroup.SecurityGroup)"
                    Write-Host "DISABLE: Employee $($employee.EmployeeID)"

                    # Add Leaver action to report
                    $accessReport += [PSCustomObject]@{
                        EmployeeID = $change.EmployeeID
                        ChangeType = "Leaver"
                        Action = "Deprovision"
                        OldGroup = $currentGroup.SecurityGroup
                        NewGroup = ""
                        Status = "Approved"
                    }
                }
                else {
                    Write-Host "No approved group mapping found for current role: $currentRole"
                }
            }
            else {
                Write-Host "Employee $($change.EmployeeID) was not found."
            }
        }

        default {
            Write-Host "Unknown change type: $($change.ChangeType)"
        }
    }
}

# Display final JML access report
Write-Host ""
Write-Host "===== JML ACCESS REPORT ====="
$accessReport | Format-Table -AutoSize

# Export JML access report to CSV
$accessReport | Export-Csv "$projectRoot/Logs/JML-AccessReport.csv" -NoTypeInformation

Write-Host ""
Write-Host "JML access report saved to Logs/JML-AccessReport.csv"