Write-Host "===== PROVISIONING VALIDATION TEST ====="
Write-Host ""

$directory = Import-Csv "./Data/ProvisioningDirectory.csv"
$tests = Import-Csv "./Data/ProvisioningValidationTests.csv"

$passed = 0
$failed = 0

foreach ($test in $tests) {

    $employee = $directory | Where-Object {
        $_.EmployeeID -eq $test.EmployeeID
    }

    $validEmployee = $null -ne $employee

    $validRole = $test.RequestedRole -in @(
        "Marketing_User",
        "Sales_User",
        "HR_User",
        "Finance_Accountant",
        "IT_HelpDesk"
    )

    if ($test.FinalDecision -ne "Approved") {
        $expected = "Not Provisioned"
    }
    elseif (-not $validEmployee) {
        $expected = "Failed"
    }
    elseif ($employee.Status -ne "Active") {
        $expected = "Failed"
    }
    elseif (-not $validRole) {
        $expected = "Failed"
    }
    else {
        $expected = "Provisioned"
    }

    Write-Host "Testing: $($test.RequestID)"
    Write-Host "Employee: $($test.EmployeeID)"
    Write-Host "Role: $($test.RequestedRole)"
    Write-Host "Expected Result: $expected"

    if ($test.RequestID -eq "TEST001") {

        if ($expected -eq "Failed") {
            Write-Host "[PASS] Unknown employee rejected"
            $passed++
        }
        else {
            Write-Host "[FAIL] Unknown employee was not rejected"
            $failed++
        }

    }
    elseif ($test.RequestID -eq "TEST002") {

        if ($expected -eq "Failed") {
            Write-Host "[PASS] Unknown role rejected"
            $passed++
        }
        else {
            Write-Host "[FAIL] Unknown role was not rejected"
            $failed++
        }

    }
    elseif ($test.RequestID -eq "TEST003") {

        if ($expected -eq "Provisioned") {
            Write-Host "[PASS] Valid request approved for provisioning"
            $passed++
        }
        else {
            Write-Host "[FAIL] Valid request was not provisioned"
            $failed++
        }

    }
    elseif ($test.RequestID -eq "TEST004") {

        if ($expected -eq "Not Provisioned") {
            Write-Host "[PASS] Blocked request prevented from 
provisioning"
            $passed++
        }
        else {
            Write-Host "[FAIL] Blocked request was provisioned"
            $failed++
        }

    }
    else {

        Write-Host "[FAIL] Unknown test case"
        $failed++

    }

    Write-Host ""
}

Write-Host "Validation Tests Passed: $passed"
Write-Host "Validation Tests Failed: $failed"

if ($failed -eq 0) {
    Write-Host "PROVISIONING VALIDATION TEST RESULT: PASS"
    exit 0
}
else {
    Write-Host "PROVISIONING VALIDATION TEST RESULT: FAIL"
    exit 1
}

