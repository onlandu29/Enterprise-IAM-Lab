Write-Host "=================================================="
Write-Host "        ENTERPRISE IAM TEST SUITE"
Write-Host "=================================================="
Write-Host ""

$tests = @(
    @{
        Name = "JML Lifecycle"
        Script = "./Tests/Test-JML.ps1"
    },
    @{
        Name = "Access Reviews"
        Script = "./Tests/Test-AccessReviews.ps1"
    },
    @{
        Name = "SoD Enforcement"
        Script = "./Tests/Test-SoD.ps1"
    },
    @{
        Name = "Access Requests"
        Script = "./Tests/Test-AccessRequests.ps1"
    },
    @{
        Name = "IAM Reporting"
        Script = "./Tests/Test-IAMReport.ps1"
    },

    @{
        Name = "Access Provisioning"
        Script = "./Tests/Test-Provisioning.ps1"
    }
)

$passed = 0
$failed = 0

foreach ($test in $tests) {

    Write-Host "Running: $($test.Name)"
    Write-Host "------------------------------------------"

    & pwsh -File $test.Script

    if ($LASTEXITCODE -eq 0) {
        $passed++
        Write-Host "[PASS] $($test.Name)"
    }
    else {
        $failed++
        Write-Host "[FAIL] $($test.Name)"
    }

    Write-Host ""
}

$total = $tests.Count

Write-Host "=================================================="
Write-Host "              TEST SUITE SUMMARY"
Write-Host "=================================================="
Write-Host ""

Write-Host "Tests Passed: $passed"
Write-Host "Tests Failed: $failed"
Write-Host "Total Tests:  $total"

Write-Host ""

if ($failed -eq 0) {
    Write-Host "=================================================="
    Write-Host "OVERALL RESULT: PASS"
    Write-Host "=================================================="
    exit 0
}
else {
    Write-Host "=================================================="
    Write-Host "OVERALL RESULT: FAIL"
    Write-Host "=================================================="
    exit 1
}
