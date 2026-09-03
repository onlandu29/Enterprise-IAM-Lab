# Enterprise IAM Governance & Automation Lab

A PowerShell-based Identity and Access Management (IAM) lab that simulates enterprise identity lifecycle management, role-based access control, access request governance, provisioning, access reconciliation, certification, privileged access governance, exception management, audit logging, and control health monitoring.

This project is designed as a portfolio demonstration of how IAM controls can work together across the identity lifecycle.

---

## Project Overview

The lab simulates an enterprise IAM environment where employee identities are mapped to roles and security groups, access requests are evaluated through manager approval and Segregation of Duties (SoD) controls, approved access is provisioned, existing access is reconciled against expected access, exceptions are tracked, and governance metrics are generated.

### Core IAM Capabilities

- Role-Based Access Control (RBAC)
- Joiner-Mover-Leaver (JML) lifecycle management
- Access request and manager approval workflows
- Segregation of Duties (SoD) enforcement
- Access provisioning
- Provisioning validation
- Duplicate access prevention
- Access reconciliation
- Access remediation
- Periodic access certification
- Privileged Access Governance
- IAM exception management
- Structured audit trail generation
- IAM control metrics
- IAM control health assessment
- Automated IAM control testing

---

## IAM Control Architecture

```text
Employee Identity
       |
       v
     RBAC
       |
       v
Security Groups
       |
       +----------------------+
       |                      |
       v                      v
      JML              Access Requests
       |                      |
       |               Manager Approval
       |                      |
       |                      v
       |                SoD Validation
       |                      |
       |                +-----+-----+
       |                |           |
       |             Conflict    No Conflict
       |                |           |
       |              BLOCK       APPROVE
       |                            |
       +-------------+--------------+
                     |
                     v
              Access Provisioning
                     |
                     v
             Access Reconciliation
                     |
              +------+------+
              |             |
            Match       Mismatch
              |             |
              v             v
          Compliant     Remediation
                            |
                            v
                    Access Certification
                            |
                            v
                    Exception Management
                            |
                            v
                       Audit Trail
                            |
                            v
                     Control Metrics
                            |
                            v
                   IAM Control Health

---

## Control Validation Results

The complete IAM control framework is validated through an automated PowerShell test suite.

```text
Tests Passed: 16
Tests Failed: 0
Total Tests:  16

OVERALL RESULT: PASS

---

## Project Structure

```text
Enterprise-IAM-Lab/
│
├── Data/
│   ├── Employees.csv
│   ├── EmployeeChanges.csv
│   ├── AccessReviews.csv
│   ├── AccessRequests.csv
│   ├── AccessRequestApprovals.csv
│   ├── GroupPermissions.csv
│   ├── RoleGroups.csv
│   ├── SoDRules.csv
│   ├── ProvisioningDirectory.csv
│   ├── ProvisioningValidationTests.csv
│   ├── PrivilegedRoles.csv
│   └── CurrentAccess.csv
│
├── Scripts/
│   ├── Assign-IAMRoles.ps1
│   ├── Build-AccessAssignments.ps1
│   ├── Check-SoDConflicts.ps1
│   ├── Process-JMLChanges.ps1
│   ├── Process-AccessReviews.ps1
│   ├── Process-AccessRequests.ps1
│   ├── Provision-ApprovedAccess.ps1
│   ├── Reconcile-Access.ps1
│   ├── Remediate-Access.ps1
│   ├── Generate-AccessCertification.ps1
│   ├── Check-PrivilegedAccess.ps1
│   ├── Generate-IAMAuditTrail.ps1
│   ├── Generate-IAMExceptionRegister.ps1
│   ├── Generate-IAMMetrics.ps1
│   ├── Test-IAMControlHealth.ps1
│   └── Generate-IAMReport.ps1
│
├── Tests/
│   ├── Run-AllTests.ps1
│   ├── Test-JML.ps1
│   ├── Test-AccessReviews.ps1
│   ├── Test-SoD.ps1
│   ├── Test-AccessRequests.ps1
│   ├── Test-IAMReport.ps1
│   ├── Test-Provisioning.ps1
│   ├── Test-ProvisioningValidation.ps1
│   ├── Test-DuplicateProvisioning.ps1
│   ├── Test-AccessReconciliation.ps1
│   ├── Test-AccessRemediation.ps1
│   ├── Test-AccessCertification.ps1
│   ├── Test-IAMAuditTrail.ps1
│   ├── Test-IAMExceptionRegister.ps1
│   ├── Test-PrivilegedAccess.ps1
│   ├── Test-IAMMetrics.ps1
│   └── Test-IAMControlHealth.ps1
│
└── Logs/
    └── Generated IAM control reports and audit artifacts

## Running the Lab

The individual IAM controls can be executed from PowerShell.

### Run the Complete Test Suite

Run:

pwsh -File Tests/Run-AllTests.ps1

A successful validation run produces:

Tests Passed: 16
Tests Failed: 0
Total Tests: 16
OVERALL RESULT: PASS

## Security Principles Demonstrated

This lab demonstrates practical IAM and security principles including:

- Least privilege
- Role-Based Access Control
- Separation of Duties
- Manager authorization
- Privileged access governance
- Joiner-Mover-Leaver lifecycle controls
- Access certification
- Continuous access reconciliation
- Exception management
- Auditability
- Control monitoring
- Automated validation

## Technologies

- PowerShell
- CSV-based IAM data modeling
- Git / GitHub
- Automated PowerShell testing
- Role-Based Access Control concepts
- IAM governance concepts
- Segregation of Duties
- Privileged Access Management concepts

## Scope and Limitations

This project is a simulated IAM governance environment designed for learning and portfolio demonstration.

It does not directly provision accounts or modify production identity platforms such as Active Directory, Microsoft Entra ID, Okta, or SailPoint.

Instead, CSV files simulate identity directories, access assignments, requests, approvals, and security groups so that IAM governance workflows can be demonstrated safely.

## Future Enhancements

Potential future enhancements include:

- Microsoft Entra ID integration
- Active Directory integration
- REST API-based provisioning
- ServiceNow access request integration
- Scheduled certification campaigns
- SIEM integration
- Dashboard visualization
- Automated remediation workflows
- Integration with a PAM platform
- Database-backed identity and access data

## Author

Built as an IAM engineering portfolio project demonstrating identity governance, access control, automation, auditability, and security control validation.
