# Load employee data
$employees = Import-Csv ./Data/Employees.csv

# Assign IAM roles based on job title
foreach ($employee in $employees) {

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
}

# Display the results
$employees | Select-Object FirstName, LastName, JobTitle, IAMRole
