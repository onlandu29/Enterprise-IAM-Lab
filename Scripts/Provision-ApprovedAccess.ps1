Write-Host "=================================================="
Write-Host "       IAM ACCESS PROVISIONING ENGINE"
Write-Host "=================================================="
Write-Host ""

$requests = Import-Csv "./Logs/AccessRequestReport.csv"
$directory = Import-Csv "./Data/ProvisioningDirectory.csv"

$provisioningLog = @()

foreach ($request in $requests) {

    Write-Host "Processing Request: $($request.RequestID)"
    Write-Host "Employee ID: $($request.EmployeeID)"
    Write-Host "Requested Role: $($request.RequestedRole)"
    Write-Host "Final Decision: $($request.FinalDecision)"

    $employee = $directory | Where-Object {
        $_.EmployeeID -eq $request.EmployeeID
    }

    if ($request.FinalDecision -ne "Approved") {

        Write-Host "ACTION: NO PROVISIONING"
        Write-Host "Reason: Access request was not approved"

        $group = ""
        $status = "Not Provisioned"
        $reason = "Access request was not approved"
    }

    elseif ($null -eq $employee) {

        Write-Host "ACTION: PROVISIONING FAILED"
        Write-Host "Reason: Employee does not exist in provisioning 
directory"

        $group = ""
        $status = "Failed"
        $reason = "Employee not found"
    }

    elseif ($employee.Status -ne "Active") {

        Write-Host "ACTION: PROVISIONING FAILED"
        Write-Host "Reason: Employee is not active"

        $group = ""
        $status = "Failed"
        $reason = "Employee is not active"
    }

    else {

        $group = switch ($request.RequestedRole) {

            "Marketing_User" {
                "GG-Marketing-Users"
            }

            "Sales_User" {
                "GG-Sales-Users"
            }

            "HR_User" {
                "GG-HR-Users"
            }

            "Finance_Accountant" {
                "GG-Finance-Accountants"
            }

            "IT_HelpDesk" {
                "GG-IT-HelpDesk"
            }

            default {
                ""
            }
        }

        if ([string]::IsNullOrWhiteSpace($group)) {

            Write-Host "ACTION: PROVISIONING FAILED"
            Write-Host "Reason: No security group mapping exists"

            $status = "Failed"
            $reason = "No security group mapping exists"
            $group = ""
        }

        else {

            Write-Host "ACTION: PROVISION ACCESS"
            Write-Host "Security Group: $group"
            Write-Host "Provisioning Status: SUCCESS"

            $status = "Provisioned"
            $reason = "Access provisioned successfully"
        }
    }

    $provisioningLog += [PSCustomObject]@{

        RequestID          = $request.RequestID
        EmployeeID         = $request.EmployeeID
        RequestedRole      = $request.RequestedRole
        FinalDecision      = $request.FinalDecision
        SecurityGroup      = $group
        ProvisioningStatus = $status
        Reason             = $reason
    }

    Write-Host ""
}

$provisioningLog | Export-Csv "./Logs/Provisioning-AccessReport.csv" 

Write-Host "=================================================="
Write-Host "Provisioning report saved to:"
Write-Host "Logs/Provisioning-AccessReport.csv"
Write-Host "=================================================="
