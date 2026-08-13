# Find the project root directory
$projectRoot = Split-Path $PSScriptRoot -Parent

# Load employee data
$employees = Import-Csv "$projectRoot/Data/Employees.csv"

# Load access review decisions
$reviews = Import-Csv "$projectRoot/Data/AccessReviews.csv"

# Load role-to-group mappings
$roleGroups = Import-Csv "$projectRoot/Data/RoleGroups.csv"

# Store access review results for reporting
$reviewReport = @()

# Process each access review
foreach ($review in $reviews) {

    # Find the employee being reviewed
    $employee = $employees | Where-Object EmployeeID -eq $review.EmployeeID

    if ($employee) {
        Write-Host "Processing Access Review: Employee $($review.EmployeeID)"
        Write-Host "Employee: $($employee.FirstName) $($employee.LastName)"
        Write-Host "Review Decision: $($review.ReviewDecision)"
        Write-Host "Reason: $($review.Reason)"

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

            if ($review.ReviewDecision -eq "Keep") {
    Write-Host "ACTION: KEEP ACCESS"

    $reviewReport += [PSCustomObject]@{
        EmployeeID = $review.EmployeeID
        Decision = "Keep"
        Action = "Keep Access"
        SecurityGroup = $currentGroup.SecurityGroup
        Reason = $review.Reason
        Status = "Approved"
    }
}
            elseif ($review.ReviewDecision -eq "Revoke") {
    Write-Host "ACTION: REVOKE ACCESS"
    Write-Host "REMOVE: $($currentGroup.SecurityGroup)"

    $reviewReport += [PSCustomObject]@{
        EmployeeID = $review.EmployeeID
        Decision = "Revoke"
        Action = "Remove Access"
        SecurityGroup = $currentGroup.SecurityGroup
        Reason = $review.Reason
        Status = "Approved"
    }
}
            else {
                Write-Host "Unknown review decision: $($review.ReviewDecision)"
            }
        }
        else {
            Write-Host "No approved group mapping found for current role: $currentRole"
        }
    }
    else {
        Write-Host "Employee $($review.EmployeeID) was not found."
    }
}
# Display access review report
Write-Host ""
Write-Host "===== ACCESS REVIEW REPORT ====="
$reviewReport | Format-Table -AutoSize

# Export access review report to CSV
$reviewReport | Export-Csv "$projectRoot/Logs/AccessReviewReport.csv" -NoTypeInformation

Write-Host ""
Write-Host "Access review report saved to Logs/AccessReviewReport.csv"