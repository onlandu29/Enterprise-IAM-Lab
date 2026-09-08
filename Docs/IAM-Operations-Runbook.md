# IAM Operations Runbook

## Purpose

This runbook defines the operational procedures for executing, validating, investigating, and documenting the IAM controls implemented in the Enterprise-IAM-Lab.

The objective is to provide a repeatable operating model for IAM administration, control monitoring, access governance, exception handling, and audit evidence generation.

## Operating Model

The IAM control lifecycle follows:

Identity Lifecycle
→ Access Assignment
→ Access Request
→ Approval
→ SoD/PAG Validation
→ Provisioning
→ Reconciliation
→ Remediation
→ Certification
→ Exception Management
→ Audit
→ Metrics
→ Control Health

## Operational Principles

### Least Privilege

Users should receive only the access required for their approved role and responsibilities.

### Separation of Duties

Conflicting access combinations should be identified and blocked before inappropriate access is provisioned.

### Approval Governance

Access requests should require appropriate management approval before provisioning.

### Evidence-Based Operations

IAM actions and control decisions should generate evidence that can be reviewed and audited.

### Continuous Validation

Automated tests should validate that IAM controls continue to operate as designed.

## Daily Operations

### 1. Review Identity Lifecycle Changes

Review employee lifecycle changes and confirm that joiner, mover, and leaver events were processed correctly.

Run:

`Scripts/Process-JMLChanges.ps1`

Evidence:

`Logs/JML-AccessReport.csv`

Expected outcome:

Lifecycle changes are processed according to the employee's status and role.

### 2. Review Access Requests

Process submitted access requests and verify that manager approval and required governance controls are enforced.

Run:

`Scripts/Process-AccessRequests.ps1`

Evidence:

`Logs/AccessRequestReport.csv`

Expected outcome:

Requests are Approved, Denied, or Blocked according to approval and control requirements.

### 3. Review Privileged Access

Review requests for privileged roles and verify that privileged access governance requirements are enforced.

Run:

`Scripts/Check-PrivilegedAccess.ps1`

Evidence:

`Logs/PrivilegedAccessReport.csv`

Expected outcome:

Privileged requests that fail approval or governance requirements remain blocked.

### 4. Review Access Reconciliation

Compare expected role-based access with current access assignments.

Run:

`Scripts/Reconcile-Access.ps1`

Evidence:

`Logs/AccessReconciliationReport.csv`

Expected outcome:

All users should have access matching their expected role assignments.

Any mismatch should be investigated and tracked for remediation.

### 5. Review Exceptions

Review open IAM exceptions and confirm that each exception has an appropriate remediation action.

Evidence:

`Logs/IAMExceptionRegister.csv`

Expected outcome:

Open exceptions are documented, assigned an action, and progressed toward resolution.

## Daily Investigation Workflow

When a control identifies an issue:

1. Identify the affected employee, request, role, or security group.
2. Review the corresponding evidence artifact.
3. Determine whether the finding represents a legitimate exception or unauthorized access.
4. Review applicable approval, SoD, privileged-access, or lifecycle requirements.
5. Perform or initiate the required remediation.
6. Re-run the applicable control.
7. Confirm that the issue is resolved or remains documented as an exception.
8. Preserve the resulting evidence for audit and governance review.

## Escalation Conditions

Escalation should occur when:

- Privileged access is requested without required approval.
- A segregation-of-duties conflict is detected.
- An employee retains access inconsistent with their current role.
- A terminated or inactive employee retains access.
- A reconciliation mismatch cannot be remediated through normal procedures.
- An IAM exception remains unresolved.
- Control-health results indicate a material governance issue.


## Weekly Operations

### 1. Run the Complete Control Test Suite

Execute the full automated validation suite.

Run:

`Tests/Run-AllTests.ps1`

Expected outcome:

All implemented IAM controls should pass their automated validation tests.

Current baseline:

16/16 tests passing.

### 2. Review Access Certification

Review certification results and investigate users whose access cannot be certified.

Run:

`Scripts/Generate-AccessCertification.ps1`

Evidence:

`Logs/AccessCertificationReport.csv`

Expected outcome:

Valid access is certified and discrepancies are documented as exceptions.

### 3. Review IAM Audit Trail

Review recent IAM activity for unusual, incomplete, or unexpected control events.

Evidence:

`Logs/IAMAuditTrail.csv`

Expected outcome:

IAM actions have traceable audit records.

### 4. Review Control Health

Review the latest control-health assessment.

Run:

`Scripts/Test-IAMControlHealth.ps1`

Evidence:

`Logs/IAMControlHealth.csv`

Expected outcome:

Controls should report PASS. Any REVIEW REQUIRED result should be investigated.

## Monthly Governance

### 1. Review IAM Metrics

Review the current IAM control metrics.

Run:

`Scripts/Generate-IAMMetrics.ps1`

Evidence:

`Logs/IAMControlMetrics.csv`

Review:

- Access request volume
- Approval and denial rates
- Blocked requests
- Privileged access activity
- Access mismatches
- Certification exceptions
- Open IAM exceptions
- Audit activity

### 2. Review Open Exceptions

Review all unresolved IAM exceptions.

Evidence:

`Logs/IAMExceptionRegister.csv`

For each open exception:

1. Confirm the business justification.
2. Confirm the required remediation.
3. Verify the exception owner or responsible team.
4. Confirm the exception remains valid.
5. Close the exception when remediation is complete.

### 3. Review Privileged Access Governance

Review privileged-access activity and confirm that privileged roles continue to meet approval and governance requirements.

Evidence:

`Logs/PrivilegedAccessReport.csv`

### 4. Review Control Effectiveness

Review the combined control-health, metrics, reconciliation, certification, and exception evidence.

The objective is to identify recurring control failures and determine whether additional preventive or detective controls are required.

## Control Failure Response

When a control reports `FAIL` or `REVIEW REQUIRED`:

1. Identify the affected control.
2. Review the associated evidence artifact.
3. Identify the affected employee, access request, or entitlement.
4. Determine the root cause.
5. Perform the required remediation.
6. Re-run the affected control.
7. Re-run the full test suite when appropriate.
8. Confirm the resulting evidence.
9. Document any remaining exception.
10. Escalate unresolved or high-risk findings.

## Evidence Retention

The following artifacts should be retained as evidence of IAM control operation:

- JML reports
- Access request reports
- Access review reports
- SoD reports
- Privileged access reports
- Provisioning reports
- Reconciliation reports
- Remediation reports
- Certification reports
- Exception registers
- Audit trails
- IAM metrics
- IAM control-health reports
- Executive governance reports

These artifacts provide an evidence trail connecting IAM activity to control decisions and remediation outcomes.

## Scope

This runbook applies to the simulated IAM environment implemented using PowerShell scripts and CSV-based data sources.
