# IAM Control Evidence

## Purpose

This document presents a complete IAM control scenario from detection 
through remediation planning, exception management, certification, and 
audit evidence.

The scenario uses Employee 1003, Michael Williams, whose actual access 
does not match the access expected for his assigned IAM role.

---

## Control Scenario

**Employee:** Michael Williams  
**Employee ID:** 1003  
**IAM Role:** Finance_Accountant

| Control Attribute | Expected | Actual |
|---|---|---|
| Security Group | `GG-Finance-Accountants` | `GG-Marketing-Users` |
| Reconciliation Result | Match | **Mismatch** |

The reconciliation control identified that the employee's actual security 
group did not match the group expected for the assigned 
`Finance_Accountant` role.

**Finding:** Access mismatch detected.

---

## Control Flow

```text
Expected Role
     |
     v
Expected Security Group
GG-Finance-Accountants
     |
     | Compare
     v
Actual Security Group
GG-Marketing-Users
     |
     v
MISMATCH DETECTED
     |
     v
Remediation Required
     |
     +-----------------------------+
     |                             |
     v                             v
Remove Incorrect Group       Add Expected Group
GG-Marketing-Users          GG-Finance-Accountants
     |                             |
     +-------------+---------------+
                   |
                   v
            Exception Recorded
                   |
                   v
             Certification
                   |
                   v
             Audit Evidence


---

## Evidence Chain

### 1. Detection

The access reconciliation process compared expected access against actual access.

Evidence:

[AccessReconciliationReport.csv](../Logs/AccessReconciliationReport.csv)

Result for Employee 1003:

- Expected group: `GG-Finance-Accountants`
- Actual group: `GG-Marketing-Users`
- Reconciliation: `Mismatch`

---

### 2. Remediation Planning

The remediation workflow identified the corrective action required for the mismatch.

Evidence:

[AccessRemediationReport.csv](../Logs/AccessRemediationReport.csv)

Required actions for Employee 1003:

- Remove `GG-Marketing-Users`
- Add `GG-Finance-Accountants`

The remediation report records the corrective action required. The current access record remains unchanged while the exception is still open.

---

### 3. Exception Management

Because the mismatch represents a control exception, the finding is recorded in the IAM exception register.

Evidence:

[IAMExceptionRegister.csv](../Logs/IAMExceptionRegister.csv)

Exception:

- Exception ID: `EXC-1003`
- Employee: Michael Williams
- Control: Access Reconciliation
- Exception Type: Access Mismatch
- Required Action: Remediate Access
- Status: Open

---

### 4. Access Certification

The access certification process identifies the employee as an exception because the current access does not match the expected access.

Evidence:

[AccessCertificationReport.csv](../Logs/AccessCertificationReport.csv)

Certification status:

**Exception**

---

### 5. Audit Trail

The control activity is also represented in the IAM audit trail.

Evidence:

[IAMAuditTrail.csv](../Logs/IAMAuditTrail.csv)

The audit trail provides a record of control activity across reconciliation, remediation, certification, and related IAM workflows.

---

## Control Objectives Demonstrated

This scenario demonstrates the following IAM control objectives:

- **Least Privilege** — access should correspond to the employee's authorized role.
- **RBAC** — role assignments determine expected security-group access.
- **Access Reconciliation** — actual access is compared against expected access.
- **Access Remediation** — identified mismatches generate corrective actions.
- **Exception Management** — unresolved control findings are formally tracked.
- **Access Certification** — exceptions are surfaced during access review.
- **Auditability** — control activity is recorded as evidence.
- **Continuous Monitoring** — reconciliation and control-health processes identify deviations from expected access.

---

## Why This Matters

This scenario demonstrates that the lab is more than a collection of IAM scripts. It models a connected control lifecycle:

**Detect → Investigate → Remediation Required → Certify → Record → Monitor**

The same finding is carried across multiple IAM controls so that a single access deviation produces traceable operational and governance evidence.

---

## Current Control Status

The scenario intentionally remains open to demonstrate how an IAM control framework handles an unresolved finding.

Current status:

- Access mismatch: **1**
- IAM exception: **1**
- Open IAM exception: **1**
- Certification exception: **1**
- Required remediation: **Remove incorrect group and add expected group**
- Control health: **Review Required**

This demonstrates the distinction between **detecting a control failure**, **generating remediation actions**, and **verifying that remediation has actually been completed**.

---

## Related Documentation

- [IAM Architecture](IAM-Architecture.md)
- [IAM Evidence Index](IAM-Evidence-Index.md)
- [IAM Operations Runbook](IAM-Operations-Runbook.md)
- [IAM Risk Register](IAM-Risk-Register.md)
- [IAM Control Dashboard](IAM-Control-Dashboard.md)
