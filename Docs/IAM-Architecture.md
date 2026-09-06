# Enterprise IAM Architecture

## Overview

The Enterprise-IAM-Lab is a simulated enterprise Identity and Access Management (IAM) governance environment built with PowerShell and CSV-based identity data.

The architecture models the lifecycle of user identities and access from employee onboarding through access governance, provisioning, reconciliation, certification, exception management, audit logging, and control monitoring.

The design emphasizes least privilege, Role-Based Access Control (RBAC), Separation of Duties (SoD), privileged access governance, continuous reconciliation, and auditability.

---

## IAM Control Flow

```text
Employee Data
     |
     v
+----------------------+
| JML Lifecycle        |
| Joiner / Mover /     |
| Leaver Processing    |
+----------+-----------+
           |
           v
+----------------------+
| IAM Role Assignment  |
| RBAC Role Mapping    |
+----------+-----------+
           |
           v
+----------------------+
| Access Request       |
| Request Submission  |
+----------+-----------+
           |
           v
+----------------------+
| Manager Approval     |
+----------+-----------+
           |
           v
+----------------------+       +---------------------------+
| SoD Enforcement      | ----> | Privileged Access        |
| Conflict Detection   |       | Governance               |
+----------+-----------+       +-------------+-------------+
           |                                 |
           +----------------+----------------+
                            |
                            v
                 +----------------------+
                 | Access Provisioning  |
                 | Approved Access Only |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Duplicate Access     |
                 | Prevention           |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Access               |
                 | Reconciliation       |
                 +----------+-----------+
                            |
                     Mismatch?
                      /       \
                    No         Yes
                    |           |
                    |           v
                    |   +----------------------+
                    |   | Access Remediation   |
                    |   +----------+-----------+
                    |              |
                    +--------------+
                                   |
                                   v
                 +----------------------+
                 | Access Certification |
                 +----------+-----------+
                            |
                     Exception?
                      /       \
                    No         Yes
                    |           |
                    |           v
                    |   +----------------------+
                    |   | IAM Exception        |
                    |   | Register             |
                    |   +----------+-----------+
                    |              |
                    +--------------+
                                   |
                                   v
                 +----------------------+
                 | IAM Audit Trail      |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Metrics & Control     |
                 | Health Monitoring      |
                 +----------------------+

## 1. Identity Lifecycle Management

Employee identity changes are represented in:

- `Data/Employees.csv`
- `Data/EmployeeChanges.csv`

The JML control processes employee lifecycle events:

- Joiner — new employee
- Mover — employee role change
- Leaver — employee departure

Primary script:

`Scripts/Process-JMLChanges.ps1`

Output:

`Logs/JML-AccessReport.csv`

---

## 2. Role-Based Access Control

IAM roles are mapped to security groups using:

`Data/RoleGroups.csv`

Example mappings include:

- `IT_HelpDesk` → `GG-IT-HelpDesk`
- `HR_User` → `GG-HR-Users`
- `Finance_Accountant` → `GG-Finance-Accountants`
- `Marketing_User` → `GG-Marketing-Users`

Primary scripts:

- `Scripts/Assign-IAMRoles.ps1`
- `Scripts/Build-AccessAssignments.ps1`

---

## 3. Access Request Governance

Employees request additional IAM roles through:

`Data/AccessRequests.csv`

Approval decisions are represented in:

`Data/AccessRequestApprovals.csv`

The request-processing control evaluates:

- Requested role
- Manager decision
- SoD requirements
- Final authorization decision

Primary script:

`Scripts/Process-AccessRequests.ps1`

Output:

`Logs/AccessRequestReport.csv`

---

## 4. Separation of Duties

SoD rules are defined in:

`Data/SoDRules.csv`

The SoD control identifies incompatible combinations of access and prevents conflicting access from being approved.

Primary script:

`Scripts/Check-SoDConflicts.ps1`

Output:

`Logs/SoD-CheckReport.csv`

The current lab intentionally includes blocked requests to demonstrate that SoD enforcement is functioning.

---

## 5. Privileged Access Governance

Privileged IAM roles are defined in:

`Data/PrivilegedRoles.csv`

The model distinguishes between:

- Standard access
- Elevated access
- Privileged access

Privileged roles require additional governance controls including approval and SoD validation.

Primary script:

`Scripts/Check-PrivilegedAccess.ps1`

Output:

`Logs/PrivilegedAccessReport.csv`

The current test scenario contains three privileged requests, two blocked by the control framework and one denied by management.

---

## 6. Access Provisioning

Only approved access is eligible for provisioning.

The provisioning workflow uses:

- `Data/ProvisioningDirectory.csv`
- `Data/RoleGroups.csv`
- `Data/AccessRequests.csv`

Primary script:

`Scripts/Provision-ApprovedAccess.ps1`

Output:

`Logs/Provisioning-AccessReport.csv`

The provisioning control prevents unauthorized or blocked requests from being provisioned.

---

## 7. Duplicate Access Prevention

The lab validates that an employee does not receive duplicate access when the requested security group is already assigned.

Primary validation:

`Tests/Test-DuplicateProvisioning.ps1`

This represents a provisioning safeguard that reduces unnecessary entitlement duplication and simplifies access governance.

---

## 8. Access Reconciliation

Expected access is compared against current access.

Expected role-to-group mappings come from:

`Data/RoleGroups.csv`

Current access is represented in:

`Data/CurrentAccess.csv`

Primary script:

`Scripts/Reconcile-Access.ps1`

Output:

`Logs/AccessReconciliationReport.csv`

The current test scenario intentionally contains an access mismatch for employee `1003`.

Expected group:

`GG-Finance-Accountants`

Current group:

`GG-Marketing-Users`

The reconciliation control identifies this as a mismatch.

---

## 9. Access Remediation

Reconciliation findings are passed into the remediation workflow.

Primary script:

`Scripts/Remediate-Access.ps1`

Output:

`Logs/AccessRemediationReport.csv`

The remediation process identifies:

- Access that should be removed
- Access that should be added
- Employees requiring remediation

For employee `1003`, the remediation record identifies:

- Remove `GG-Marketing-Users`
- Add `GG-Finance-Accountants`

---

## 10. Access Certification

Access certification provides an additional governance review of employee access.

Primary script:

`Scripts/Generate-AccessCertification.ps1`

Output:

`Logs/AccessCertificationReport.csv`

The certification process evaluates whether access is:

- Certified
- Requiring exception handling

Employee `1003` is intentionally flagged as a certification exception because the access mismatch remains unresolved.

---

## 11. IAM Exception Management

Exceptions are consolidated into:

`Logs/IAMExceptionRegister.csv`

Primary script:

`Scripts/Generate-IAMExceptionRegister.ps1`

The exception register tracks:

- Exception ID
- Employee
- IAM role
- Current access
- Expected access
- Control that detected the issue
- Exception type
- Remediation status
- Certification status
- Required action
- Exception status
- Reason

This creates a centralized record of unresolved IAM control issues.

---

## 12. IAM Audit Trail

IAM events are consolidated into:

`Logs/IAMAuditTrail.csv`

Primary script:

`Scripts/Generate-IAMAuditTrail.ps1`

The audit trail records events across:

- Access requests
- Provisioning
- Reconciliation
- Remediation
- Certification

The current test environment contains 17 audit events.

Employee `1003` has multiple related events demonstrating how a single access issue can be traced across the IAM control lifecycle.

---

## 13. IAM Metrics

Control metrics are generated by:

`Scripts/Generate-IAMMetrics.ps1`

Output:

`Logs/IAMControlMetrics.csv`

Current metrics include:

- Access requests
- Approved requests
- Denied requests
- Blocked requests
- Privileged requests
- Blocked privileged requests
- Eligible privileged requests
- Reconciliation checks
- Access mismatches
- Access certifications
- Certification exceptions
- IAM exceptions
- Open IAM exceptions
- Audit trail events

---

## 14. IAM Control Health

The control-health layer evaluates the state of major IAM controls.

Primary script:

`Scripts/Test-IAMControlHealth.ps1`

Output:

`Logs/IAMControlHealth.csv`

Controls currently evaluated include:

- JML Lifecycle
- Access Requests
- SoD Enforcement
- Provisioning
- Reconciliation
- Access Certification
- Exception Management
- Privileged Access
- Audit Trail
- Control Metrics

The current environment reports:

`OVERALL STATUS: REVIEW REQUIRED`

This is intentional because the simulated environment contains an unresolved access mismatch and related certification and exception findings.

A `REVIEW` status does not mean the control failed. It indicates that the control successfully detected a condition requiring human or downstream remediation.

---

## 15. Automated Validation

The entire IAM control framework is validated through PowerShell tests located in:

`Tests/`

The master test runner is:

`Tests/Run-AllTests.ps1`

Current validation result:

- Tests Passed: 16
- Tests Failed: 0
- Total Tests: 16
- Overall Result: PASS

The test suite validates both successful control execution and intentional negative scenarios.

---

## Control Design Principles

The architecture demonstrates the following IAM and security principles:

### Least Privilege

Users receive access based on their defined IAM role and approved business requirements.

### Role-Based Access Control

Security group assignments are mapped to defined IAM roles.

### Separation of Duties

Conflicting access combinations are identified and blocked.

### Privileged Access Governance

Privileged roles receive additional approval and SoD controls.

### Lifecycle Governance

Joiner, mover, and leaver events drive changes to identity access.

### Continuous Reconciliation

Current access is compared against expected access to identify unauthorized or stale entitlements.

### Certification

Access is evaluated for continued appropriateness.

### Exception Management

Unresolved control findings are centrally tracked.

### Auditability

IAM events are recorded to support traceability and review.

### Control Monitoring

Metrics and control-health assessments provide visibility into the effectiveness and current state of IAM controls.

---

## Enterprise IAM Mapping

The simulated architecture can be conceptually mapped to common enterprise IAM platforms and processes.

| Lab Component | Enterprise Equivalent |
|---|---|
| `Employees.csv` | HR / Identity Source |
| JML Processing | Identity Lifecycle Management |
| `RoleGroups.csv` | RBAC / Entitlement Model |
| Access Requests | Access Request Management |
| Manager Approval | Business Authorization |
| SoD Rules | Governance Policy Engine |
| Privileged Roles | PAM / Privileged Access Governance |
| Provisioning Directory | Identity / Target Directory |
| Provisioning Script | Provisioning Engine |
| Reconciliation | Access Governance Reconciliation |
| Certification | Access Review / Certification Campaign |
| Exception Register | IAM Governance Exceptions |
| Audit Trail | IAM Audit / SIEM Feed |
| Metrics | IAM Control Reporting |
| Control Health | IAM Control Monitoring |

---

## Scope

This architecture is intentionally implemented as a simulated environment using PowerShell and CSV files.

It demonstrates IAM governance logic without making changes to production identity systems.

Future implementations could replace the simulated data sources and controls with integrations such as:

- Microsoft Entra ID
- Active Directory
- Okta
- SailPoint
- ServiceNow
- SIEM platforms
- PAM platforms
