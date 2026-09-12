# IAM Security Findings & Risk Register

## Purpose

This register documents security findings identified by the Enterprise-IAM-Lab and distinguishes active IAM risks from access requests that were successfully prevented by security controls.

The objective is to provide a structured view of:

**Finding → Risk → Control → Evidence → Remediation → Status**

## Risk Classification

| Severity | Definition |
|---|---|
| Critical | Immediate risk involving highly privileged access or a significant control failure |
| High | Significant unauthorized or inappropriate access requiring prompt remediation |
| Medium | Control exception or access issue requiring investigation and remediation |
| Low | Minor governance issue with limited security impact |

## Active Findings

| Finding ID | Finding | Risk | Severity | Detecting Control | Evidence | Remediation | Status |
|---|---|---|---|---|---|---|---|
| EXC-1003 | Finance employee has Marketing security-group access | User has access inconsistent with assigned role | High | Access Reconciliation | `Logs/AccessReconciliationReport.csv` | Remove `GG-Marketing-Users` and add `GG-Finance-Accountants` | Open |

## Prevented Access Risks

The lab also identifies access requests that were prevented by IAM controls.

These are recorded as **control successes**, rather than active security findings.

| Request | Requested Access | Control Outcome | Security Control | Evidence |
|---|---|---|---|---|
| REQ001 | Payment_Approver | Blocked | SoD / Privileged Access Governance | `Logs/PrivilegedAccessReport.csv` |
| REQ003 | Security_Admin | Blocked | SoD / Privileged Access Governance | `Logs/PrivilegedAccessReport.csv` |
| REQ004 | Payroll_Admin | Denied | Manager Approval / Privileged Access Governance | `Logs/PrivilegedAccessReport.csv` |

## Finding Analysis

### EXC-1003 — Access Mismatch

**Affected Employee:** 1003

**IAM Role:** `Finance_Accountant`

**Current Group:** `GG-Marketing-Users`

**Expected Group:** `GG-Finance-Accountants`

**Risk:** The employee's actual access does not align with the access expected for their assigned IAM role.

**Severity:** High

**Detecting Control:** Access Reconciliation

**Required Remediation:**

1. Remove `GG-Marketing-Users`.
2. Add `GG-Finance-Accountants`.
3. Re-run access reconciliation.
4. Confirm the mismatch is resolved.
5. Update the exception status.
6. Re-certify the employee's access.

**Current Status:** Open

## Control Effectiveness

The lab demonstrates both preventive and detective IAM controls.

### Preventive Controls

SoD and privileged-access governance prevented multiple inappropriate privileged access requests from reaching an approved state.

### Detective Controls

Access reconciliation detected an entitlement mismatch between expected and actual access.

### Corrective Controls

Access remediation identifies the required changes to return the user's access to the expected role-based state.

### Governance Controls

Certification and exception management provide additional oversight of unresolved access issues.

## Risk Treatment Workflow

The recommended workflow for identified IAM findings is:

**Detect → Classify → Investigate → Remediate → Validate → Certify → Close**

A finding should not be considered closed until the relevant control has been re-run and the resulting evidence confirms that the issue has been resolved.

## Current Risk Summary

Current lab state:

- Active IAM findings: 1
- Open IAM exceptions: 1
- High-severity findings: 1
- Privileged requests blocked: 2
- Privileged requests denied: 1
- Access mismatches: 1
- Certification exceptions: 1

The blocked and denied privileged requests demonstrate successful preventive controls and should not be counted as active security findings.

## Scope

This register reflects findings generated within the simulated Enterprise-IAM-Lab environment.

It does not represent findings from a production identity environment.
