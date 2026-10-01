# 🛡️ Module: Azure Policy Management & Cloud Governance

This module demonstrates the implementation of enterprise-grade cloud governance using Azure Policy and Management Groups. The objective is to enforce security, compliance, and cost-management guardrails at the Azure Resource Manager (ARM) API level, ensuring that non-compliant infrastructure is blocked *before* it can be provisioned.

---

## 🎯 Demonstrated Skills for Recruiters
* **Custom Policy Creation:** Writing custom JSON policy rules in Terraform to evaluate resource properties.
* **Enterprise Scaling:** Bundling individual policies into a central Policy Initiative (Policy Set Definition) for scalable assignment, rather than relying on fragile one-off policy assignments.
* **Hierarchical Governance:** Scoping policy definitions to the Root Management Group[cite: 4] while assigning enforcement specifically to the Production and Development Management Groups[cite: 3, 4].
* **API-Level Security:** Demonstrating how Azure Policy acts as a hard boundary against unauthorized infrastructure deployments.

---

## 🏗️ Governance Architecture

This module deploys the following structure:

```text
                                  [ Portfolio Org Root Management Group ]
                                              │ (Policies Defined Here)
                                   (Policy Initiative: Baseline)
                                              │
                      ┌───────────────────────┴───────────────────────┐
                      ▼                                               ▼
           [ Production Management Group ]                [ Development Management Group ]
                      │
           (Initiative Assigned & Enforced)
```

## 🔒 Enforced Security Controls
  - Data Residency (Allowed Regions): A custom policy (allowed-azure-locations) that explicitly denies the creation of any resources outside of authorized regions (eastus, eastus2).
  - Cost & Resource Tracking (Mandatory Tags): A custom policy (require-mandatory-tag) requiring the Environment tag on all deployed resources to ensure accurate cost allocation and resource lifecycle management.

## 📂 Module Files

| File | Description |
| :--- | :--- |
| management_groups.tf | Creates the management groups that will receive the policies. |
| policy_definitions.tf | Contains the raw JSON logic for custom policies (location restrictions and tag enforcement). |
| policy_initiatives.tf | Aggregates the custom policies into a single Organizational Baseline Governance initiative. |
| policy_assignments.tf | Assigns the initiative to target management groups (e.g., Production) and passes specific parameters down to the rules. |


## 🛑 Compliance Validation (deployment-test/)

To definitively prove that these governance guardrails work, this folder includes a deployment-test directory. It contains a Terraform script that simultaneously attempts to deploy three resources to test the Azure Policy API response.

Test Matrix
| Resource | Region | Tag (Environment) | Expected Outcome | Failure Reason |
| :--- | :--- | :--- | :--- | :--- |
| vnet-compliant | eastus | "Production" | 201 Created (Success) |  Complies with all assigned policies.|
| vnet-invalid-region | westus | "Production" | 400 Bad Request (Fail) | Blocked by Allowed Regions policy. |
| vnet-missing-tag | eastus | None | 400 Bad Request (Fail) | Blocked by Required Tag policy.|

*(Note to Reviewer: If you want to run these files using terraform, remember to create a subscription or move one that already exists to the Production Management Group created before. Since this can mess with existing policies, I thought that it would be better not to create or move a subscription automatically).*

## 🏃 Execution & API Response

When executing terraform apply in the test directory, Azure Resource Manager successfully provisions the compliant network, but intercepts and blocks the other two. Terraform records the compliant resource in the state file and outputs the following explicit API rejections for the non-compliant resources:

```
Error: creating Virtual Network "vnet-invalid-region": 
authorization.PolicyAssignmentClient#CreateOrUpdate: Failure responding to request: 
StatusCode=400 -- Current status code is 400 with response body:
{
  "error": {
    "code": "RequestDisallowedByPolicy",
    "message": "Resource 'vnet-invalid-region' was disallowed by policy. Policy definition: 'Allowed Azure Location'."
  }
}

Error: creating Virtual Network "vnet-missing-tag": 
authorization.PolicyAssignmentClient#CreateOrUpdate: Failure responding to request: 
StatusCode=400 -- Current status code is 400 with response body:
{
  "error": {
    "code": "RequestDisallowedByPolicy",
    "message": "Resource 'vnet-missing-tag' was disallowed by policy. Policy definition: 'Require Mandatory Tag'."
  }
}
```
