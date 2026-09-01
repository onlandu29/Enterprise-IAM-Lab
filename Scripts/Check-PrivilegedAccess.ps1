Write-Host "=================================================="
Write-Host "       PRIVILEGED ACCESS GOVERNANCE ENGINE"
Write-Host "=================================================="
Write-Host ""

$requests = Import-Csv "./Logs/AccessRequestReport.csv"
$privilegedRoles = Import-Csv "./Data/PrivilegedRoles.csv"

$governanceLog = @()

foreach ($request in $requests) {

    Write-Host "Processing Request: $($request.RequestID)"
    Write-Host "Employee ID: $($request.EmployeeID)"
    Write-Host "Requested Role: $($request.RequestedRole)"

    $role = $privilegedRoles | Where-Object {
        $_.IAMRole -eq $request.RequestedRole
    }

    if (-not $role) {

        $privilegeLevel = "Unknown"
        $decision = "Blocked"
        $reason = "Role is not defined in privileged role catalog"

        Write-Host "Privilege Classification: Unknown"
        Write-Host "PAG Decision: BLOCKED"
        Write-Host "Reason: $reason"
    }
    else {

        $privilegeLevel = $role.PrivilegeLevel

        Write-Host "Privilege Classification: $privilegeLevel"

        if (
            $role.ApprovalRequired -eq "Yes" -and
            $request.ManagerDecision -eq "Approved" -and
            $role.SoDCheckRequired -eq "Yes" -and
            $request.FinalDecision -eq "Approved"
        ) {

            $decision = "Eligible"
            $reason = "Approval and SoD requirements satisfied"

            Write-Host "PAG Decision: ELIGIBLE"
            Write-Host "Reason: $reason"
        }
        else {

            $decision = "Blocked"
            $reason = "Required approval or SoD requirements not 
satisfied"

            Write-Host "PAG Decision: BLOCKED"
            Write-Host "Reason: $reason"
        }
    }

    $governanceLog += [PSCustomObject]@{
        RequestID       = $request.RequestID
        EmployeeID      = $request.EmployeeID
        RequestedRole   = $request.RequestedRole
        PrivilegeLevel  = $privilegeLevel
        ManagerDecision = $request.ManagerDecision
        FinalDecision   = $request.FinalDecision
        PAGDecision     = $decision
        Reason          = $reason
    }

    Write-Host ""
}

$governanceLog | Export-Csv "./Logs/PrivilegedAccessReport.csv"

Write-Host "=================================================="
Write-Host "Privileged access report saved to:"
Write-Host "Logs/PrivilegedAccessReport.csv"
Write-Host "=================================================="
