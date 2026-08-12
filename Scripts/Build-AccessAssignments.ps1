# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load employee data
$employees = Import-Csv "$projectRoot/Data/Employees.csv"

# Load role-to-group mappings
$roleGroups = Import-Csv "$projectRoot/Data/RoleGroups.csv"

# Load group permissions
$permissions = Import-Csv "$projectRoot/Data/GroupPermissions.csv"

# Process each employee
foreach ($employee in $employees) {

    # Determine IAM role based on job title
    if ($employee.JobTitle -eq "Help Desk Technician") {
        $employee | Add-Member -MemberType NoteProperty -Name IAMRole -Value "IT_HelpDesk"
    }
    elseif ($employee.JobTitle -eq "HR Specialist") {
        $employee | Add-Member -MemberType NoteProperty -Name IAMRole -Value "HR_User"
    }
    elseif ($employee.JobTitle -eq "Accountant") {
        $employee | Add-Member -MemberType NoteProperty -Name IAMRole -Value "Finance_Accountant"
    }
    elseif ($employee.JobTitle -eq "Marketing Coordinator") {
        $employee | Add-Member -MemberType NoteProperty -Name IAMRole -Value "Marketing_User"
    }
    elseif ($employee.JobTitle -eq "Sales Representative") {
        $employee | Add-Member -MemberType NoteProperty -Name IAMRole -Value "Sales_User"
    }

    # Find the security group for the IAM role
    $group = $roleGroups | Where-Object IAMRole -eq $employee.IAMRole

    if ($group) {
        $employee | Add-Member -MemberType NoteProperty -Name SecurityGroup -Value $group.SecurityGroup
    }

    # Find permissions for the security group
    $employeePermissions = $permissions | Where-Object SecurityGroup -eq $employee.SecurityGroup

    if ($employeePermissions) {
        $employee | Add-Member -MemberType NoteProperty -Name Permissions -Value (($employeePermissions.Permission) -join ", ")
    }
}

# Display access assignments
$employees | Select-Object FirstName, LastName, JobTitle, IAMRole, SecurityGroup, Permissions