# 🛡️ Module: Secure Hub & Spoke Network with Private AKS

This module demonstrates the implementation of a secure, enterprise-grade cloud architecture by deploying a private Azure Kubernetes Service (AKS) cluster within a Hub-and-Spoke network topology. The objective is to establish strict network isolation where the cluster control plane is kept private and all outbound workload traffic is centrally forced through an Azure Firewall for inspection.

---

## 🎯 Demonstrated Skills for Recruiters

* **Advanced Network Topology:** Architecting a Hub Virtual Network alongside multiple Spoke Virtual Networks with bidirectional peering.


* **Zero-Trust Routing:** Implementing User Defined Routes (UDRs) to capture all Spoke subnet traffic (`0.0.0.0/0`) and forcefully route it to a central Virtual Appliance (Azure Firewall).


* **Private Kubernetes Operations:** Deploying an AKS cluster completely isolated from the public internet by utilizing Private DNS Zones linked to the networking environment.


* **Granular Security Controls:** Writing Terraform to orchestrate Network Security Groups (NSGs) that explicitly block external administrative access, alongside complex Azure Firewall Network and Application rules.



---

## 🏗️ Infrastructure Architecture

This module deploys the following structure:

```text
                                   [ Hub VNet (10.0.0.0/16) ]
                                (Azure Firewall for Inspection)
                                                ▲
                      ┌─────────────────────────┴─────────────────────────┐
                      ▼ (Peered)                                          ▼ (Peered)
           [ Spoke 1 VNet (10.1.0.0/16) ]                      [ Spoke 2 VNet (10.2.0.0/16) ]
           (Private AKS Cluster via UDR)                       (Reserved for Future Workloads)

```

## 🔒 Enforced Security Controls

* **Centralized Egress Inspection:** A User Defined Route (UDR) intercepts all outbound traffic from the AKS nodes and directs it to the Hub Firewall's private IP.


* **Private API Server:** The AKS cluster is strictly designated as a private cluster (`private_cluster_enabled = true`). DNS resolution is managed via a dedicated Private DNS Zone (`privatelink.eastus.azmk8s.io`) linked to both the Hub and Spoke VNets.


* **Egress Firewall Rules:** Explicit egress rules permit necessary AKS API/Node traffic (UDP ports 443, 1194, 9000, 123) and web traffic to the Microsoft Container Registry using the built-in `AzureKubernetsService` FQDN tag.


* **Inbound Attack Surface Reduction:** An NSG applied to the Spoke workloads categorically denies inbound Internet traffic targeting ports 22 (SSH) and 3389 (RDP).



## 📂 Module Files

| File | Description |
| --- | --- |
| `aks.tf` | Provisions the private AKS cluster, standard VM node pools, and the User Assigned Identity for DNS updates. |
| `dns.tf` | Creates the Azure Private DNS Zone and configures links to the Hub and Spoke Virtual Networks. |
| `firewall.tf` | Deploys the Standard SKU Azure Firewall instance and its required public IP into the Hub VNet. |
| `firewall-apps.tf` | Configures Firewall Application Rules to allow outbound HTTPS/HTTP traffic for required AKS services. |
| `firewall-rules.tf` | Configures Firewall Network Rules to allow outbound UDP traffic for AKS core connectivity and NTP time sync. |
| `network.tf` | Builds the core network foundation: Hub VNet, two Spoke VNets, underlying subnets, and all peering relationships. |
| `providers.tf` | Defines required Terraform providers (AzureRM, TLS) and configures the remote Azure Storage backend for state management. |
| `routing.tf` | Creates the Route Table and default User Defined Route (0.0.0.0/0) pointing to the Azure Firewall, linking it to the Spoke subnets. |
| `security.tf` | Establishes the Network Security Group to block direct internet administrative access and associates it with the Spokes. |
| `test-app.yml` | Kubernetes manifest used to validate cluster functionality and internal networking. |

## 🛑 Workload Validation (`test-app.yml`)

To definitively prove that the private cluster and egress firewall rules operate correctly, this folder includes a sample Kubernetes deployment (`test-app.yml`).

This manifest executes two critical validation tests simultaneously:

1. **Egress Validation:** It pulls the `[mcr.microsoft.com/azuredocks/aks-helloworld:v1](https://mcr.microsoft.com/azuredocks/aks-helloworld:v1)` image directly from the Microsoft Container Registry, verifying that the Azure Firewall application rules correctly allow outbound registry traffic.
2. **Private Ingress Validation:** It provisions a `LoadBalancer` service utilizing the `service.beta.kubernetes.io/azure-load-balancer-internal: "true"` annotation. This ensures the application is exposed exclusively via a private IP address drawn from the Spoke subnet, proving the cluster's internal load balancing configuration is active.

*(Note to Reviewer: To interact with this private cluster, you must either deploy a jumpbox VM into the Hub VNet or configure a VPN Gateway, as the AKS API server is not accessible from the public internet).*

## 🏃 Execution & Deployment Response

When executing `terraform apply`, Terraform sequentially builds the network, establishes the firewall routing, and provisions the AKS identity before standing up the cluster. Because `depends_on = [azurerm_role_assignment.aks_dns_contributor]` is explicitly set, Terraform ensures the necessary RBAC permissions are fully propagated before the cluster attempts to create its private DNS records.

Once the infrastructure is successfully deployed, applying the workload via `kubectl apply -f test-app.yml` will result in the `aks-helloworld-internal` service acquiring an IP address directly from the `10.1.0.0/24` Spoke subnet.
