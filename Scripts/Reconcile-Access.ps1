Write-Host "=================================================="
Write-Host "        IAM ACCESS RECONCILIATION ENGINE"
Write-Host "=================================================="
Write-Host ""

$directory = Import-Csv "./Data/ProvisioningDirectory.csv"
$roleGroups = Import-Csv "./Data/RoleGroups.csv"
$currentAccess = Import-Csv "./Data/CurrentAccess.csv"

$reconciliationLog = @()

foreach ($employee in $directory) {

    Write-Host "Checking Employee: $($employee.EmployeeID)"
    Write-Host "Employee Name: $($employee.EmployeeName)"
    Write-Host "IAM Role: $($employee.CurrentRole)"

    $roleMapping = $roleGroups | Where-Object {
        $_.IAMRole -eq $employee.CurrentRole
    }

    $expectedGroup = $roleMapping.SecurityGroup

    $actualAccess = $currentAccess | Where-Object {
        $_.EmployeeID -eq $employee.EmployeeID
    }

    $actualGroup = $actualAccess.SecurityGroup

    Write-Host "Expected Group: $expectedGroup"
    Write-Host "Actual Group: $actualGroup"

    if ($null -eq $roleMapping) {

        $result = "Failed"
        $reason = "No role-to-group mapping exists"

        Write-Host "RESULT: RECONCILIATION FAILED"
        Write-Host "Reason: $reason"

    }
    elseif ($null -eq $actualAccess) {

        $result = "Mismatch"
        $reason = "Expected access is missing"

        Write-Host "RESULT: ACCESS MISMATCH"
        Write-Host "Reason: $reason"

    }
    elseif ($actualGroup -eq $expectedGroup) {

        $result = "Match"
        $reason = "Actual access matches expected access"

        Write-Host "RESULT: ACCESS MATCH"

    }
    else {

        $result = "Mismatch"
        $reason = "Actual access does not match expected access"

        Write-Host "RESULT: ACCESS MISMATCH"
        Write-Host "Reason: $reason"
    }

    $reconciliationLog += [PSCustomObject]@{
        EmployeeID     = $employee.EmployeeID
        EmployeeName   = $employee.EmployeeName
        IAMRole        = $employee.CurrentRole
        ExpectedGroup  = $expectedGroup
        ActualGroup    = $actualGroup
        Reconciliation = $result
        Reason         = $reason
    }

    Write-Host ""
}

$reconciliationLog | Export-Csv "./Logs/AccessReconciliationReport.csv"

Write-Host "=================================================="
Write-Host "Reconciliation report saved to:"
Write-Host "Logs/AccessReconciliationReport.csv"
Write-Host "=================================================="
