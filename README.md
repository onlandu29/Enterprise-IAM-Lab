# Enterprise IAM Governance & Automation Lab

A PowerShell-based Identity and Access Management (IAM) lab that simulates enterprise identity lifecycle management, access governance, Segregation of Duties (SoD), access request approval, audit logging, and IAM reporting.

## Overview

This project demonstrates how an enterprise IAM team can manage employee identities and access throughout the user lifecycle.

Core capabilities:

- Role-Based Access Control (RBAC)
- Joiner-Mover-Leaver (JML) lifecycle management
- Periodic access reviews
- Segregation of Duties (SoD) controls
- Manager-approved access requests
- Audit logging
- IAM governance reporting

## IAM Architecture

Employee Identity
        |
        v
       RBAC
        |
        v
Security Groups
        |
   +----+----+
   |         |
   v         v
  JML   Access Requests
   |    Manager Approval
   v         |
Access       v
Reviews   SoD Validation
   |         |
   +----+----+
        |
        v
Final IAM Decision
        |
        v
    Audit Logs
        |
        v
Governance Reporting

## RBAC

Employees are mapped to IAM roles and security groups based on their job responsibilities.

| Job Title | IAM Role | Security Group |
|---|---|---|
| Help Desk Technician | IT_HelpDesk | GG-IT-HelpDesk |
| HR Specialist | HR_User | GG-HR-Users |
| Accountant | Finance_Accountant | GG-Finance-Accountants |
| Marketing Coordinator | Marketing_User | GG-Marketing-Users |
| Sales Representative | Sales_User | GG-Sales-Users |

RBAC provides a consistent access model and supports least privilege.

## Joiner-Mover-Leaver (JML)

The JML workflow manages access throughout the employee lifecycle.

### Joiner

New employees receive access based on their IAM role.

### Mover

Role changes trigger removal of old access and assignment of new access.

Example:

Finance_Accountant
       |
   Role Change
       |
       v
Marketing_User

REMOVE: GG-Finance-Accountants
ADD:    GG-Marketing-Users

### Leaver

Employees leaving the organization have their access removed and account disabled.

Script: `Scripts/Process-JMLChanges.ps1`

Audit log: `Logs/JML-AccessReport.csv`

## Access Reviews

The lab simulates periodic access certification.

Review decisions can be:

- Keep access
- Revoke access

Example:

Employee: 1003
Decision: Revoke
Reason: No longer requires accounting access

Script: `Scripts/Process-AccessReviews.ps1`

Audit log: `Logs/AccessReviewReport.csv`

## Segregation of Duties (SoD)

Preventive SoD controls identify conflicting IAM roles.

Example:

Finance_Accountant + Payment_Approver = CONFLICT

Reason: User could create and approve financial transactions.

Another conflict:

IT_HelpDesk + Security_Admin = CONFLICT

SoD rules: `Data/SoDRules.csv`

Script: `Scripts/Check-SoDConflicts.ps1`

Audit log: `Logs/SoD-CheckReport.csv`

## Access Request & Approval Workflow

Additional access requires manager approval before SoD validation.

Access Request
      |
      v
Manager Approval
      |
   +--+--+
   |     |
Denied Approved
   |     |
 DENY    v
       SoD Check
          |
      +---+---+
      |       |
   Conflict  No Conflict
      |       |
    BLOCK   APPROVE

Example blocked request:

REQ001
Employee: Michael Williams
Requested Role: Payment_Approver
Manager Decision: Approved
SoD Result: Conflict
Final Decision: Blocked

Example approved request:

REQ002
Employee: Michael Williams
Requested Role: Marketing_User
Manager Decision: Approved
SoD Result: No Conflict
Final Decision: Approved

Script: `Scripts/Process-AccessRequests.ps1`

Input: `Data/AccessRequestApprovals.csv`

Audit log: `Logs/AccessRequestReport.csv`

## Audit Logging

Each IAM control produces structured audit records.

- JML: `Logs/JML-AccessReport.csv`
- Access Reviews: `Logs/AccessReviewReport.csv`
- SoD: `Logs/SoD-CheckReport.csv`
- Access Requests: `Logs/AccessRequestReport.csv`

These records provide evidence of IAM decisions and security control activity.

## IAM Governance Reporting

`Scripts/Generate-IAMReport.ps1` aggregates IAM audit logs and produces governance metrics.

Generated report: `Logs/IAM-Executive-Report.txt`

### Current Simulated Metrics

| Metric | Result |
|---|---:|
| JML Joiners | 1 |
| JML Movers | 1 |
| JML Leavers | 1 |
| Access Reviews | 5 |
| Access Revocations | 2 |
| Access Revocation Rate | 40% |
| SoD Checks | 3 |
| SoD Blocks | 2 |
| SoD Block Rate | 66.67% |
| Access Requests | 4 |
| Access Requests Approved | 1 |
| Access Requests Blocked | 2 |
| Access Requests Denied | 1 |
| Access Request Approval Rate | 25% |

## Control Findings

The current dataset demonstrates:

- SoD conflicts detected and blocked
- Unnecessary access identified during access reviews
- Access requests blocked by SoD controls
- Access requests denied through management approval

These demonstrate that the IAM controls are actively enforcing governance decisions.

## Project Structure

Enterprise-IAM-Lab/
|
+-- Data/
+-- Logs/
+-- Scripts/
+-- README.md

### Key Scripts

- `Assign-IAMRoles.ps1`
- `Build-AccessAssignments.ps1`
- `Process-JMLChanges.ps1`
- `Process-AccessReviews.ps1`
- `Check-SoDConflicts.ps1`
- `Process-AccessRequests.ps1`
- `Generate-IAMReport.ps1`

## Technologies

- PowerShell
- CSV data modeling
- Git
- GitHub
- RBAC
- JML
- Segregation of Duties
- Access Reviews
- Access Governance
- Audit Logging

## Security Principles Demonstrated

### Least Privilege

Access is assigned according to job responsibilities.

### Separation of Duties

Conflicting responsibilities are identified and blocked.

### Lifecycle Management

Access is managed throughout the employee lifecycle.

### Access Governance

Existing access is periodically reviewed and unnecessary access can be revoked.

### Approval-Based Access

Additional access requires manager approval.

### Auditability

IAM decisions are recorded in structured logs.

### Governance

IAM activity is aggregated into management-level metrics.

## Future Enhancements

Planned improvements:

- Simulated directory provisioning
- Automated security group membership updates
- Expanded error handling
- Automated test cases
- Additional IAM scenarios
- Portfolio screenshots
- Architecture documentation

## Disclaimer

This project is a simulated IAM environment created for educational and portfolio purposes.

It does not connect to a production Active Directory, Microsoft Entra ID, Okta, or other enterprise identity provider.

All employee identities, roles, groups, and access decisions are simulated.
