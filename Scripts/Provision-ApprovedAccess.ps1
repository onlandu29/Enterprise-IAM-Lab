Write-Host "=================================================="
Write-Host "       IAM ACCESS PROVISIONING ENGINE"
Write-Host "=================================================="
Write-Host ""

$requests = Import-Csv "./Logs/AccessRequestReport.csv"

$provisioningLog = @()

foreach ($request in $requests) {

    Write-Host "Processing Request: $($request.RequestID)"
    Write-Host "Employee ID: $($request.EmployeeID)"
    Write-Host "Requested Role: $($request.RequestedRole)"
    Write-Host "Final Decision: $($request.FinalDecision)"

    if ($request.FinalDecision -eq "Approved") {

        Write-Host "ACTION: PROVISION ACCESS"

        $group = switch ($request.RequestedRole) {
            "Marketing_User"     { "GG-Marketing-Users" }
            "Sales_User"         { "GG-Sales-Users" }
            "HR_User"            { "GG-HR-Users" }
            "Finance_Accountant" { "GG-Finance-Accountants" }
            "IT_HelpDesk"        { "GG-IT-HelpDesk" }
            default              { "UNKNOWN-GROUP" }
        }

        if ($group -eq "UNKNOWN-GROUP") {
            Write-Host "ACTION: PROVISIONING FAILED"
            Write-Host "Reason: No security group mapping exists"
            $status = "Failed"
        }
        else {
            Write-Host "Security Group: $group"
            Write-Host "Provisioning Status: SUCCESS"
            $status = "Provisioned"
        }
    }
    else {
        Write-Host "ACTION: NO PROVISIONING"
        Write-Host "Reason: Access request was not approved"
        $group = ""
        $status = "Not Provisioned"
    }

    $provisioningLog += [PSCustomObject]@{
        RequestID          = $request.RequestID
        EmployeeID         = $request.EmployeeID
        RequestedRole      = $request.RequestedRole
        FinalDecision      = $request.FinalDecision
        SecurityGroup      = $group
        ProvisioningStatus = $status
    }

    Write-Host ""
}

$provisioningLog | Export-Csv "./Logs/Provisioning-AccessReport.csv" -NoTypeInformation

Write-Host "=================================================="
Write-Host "Provisioning report saved to:"
Write-Host "Logs/Provisioning-AccessReport.csv"
Write-Host "=================================================="
