Enterprise Secure Hub-and-Spoke Network in Azure

📌 Overview
This repository contains the Infrastructure as Code (IaC) configuration to deploy a secure, enterprise-grade Hub-and-Spoke network topology in Microsoft Azure.
This architecture was designed and implemented to align with the Microsoft Cybersecurity Reference Architecture (MCRA) and principles evaluated in the AZ-305 (Solutions Architect) and SC-100 (Cybersecurity Architect) certifications. It demonstrates a Zero Trust approach to cloud networking, centralized traffic inspection, and scalable infrastructure deployment using Terraform.

🏗️ Architecture Design

[Architecture Diagram](./microsoft-hub-spoke-architecture-demo.png)

Key Security & Routing Features:
Hub-and-Spoke Topology: Isolates workloads (Spokes) while centralizing shared services and security (Hub).
Centralized Traffic Inspection: An Azure Firewall is deployed in the Hub network to inspect all inter-spoke and internet-bound traffic.
Forced Tunneling via UDRs: User Defined Routes (UDRs) override default Azure routing, forcing all outbound Spoke traffic (0.0.0.0/0) to the Azure Firewall as the Next-Hop Virtual Appliance.
Subnet-Level Microsegmentation: Network Security Groups (NSGs) are bound to workload subnets, explicitly denying direct administrative access (SSH/RDP) from the public internet to enforce bastion/jump-box patterns.

📂 Repository Structur
The Terraform configuration is modularized for readability and maintainability:
main.tf: Foundational resources including the Resource Group, Hub VNet, Spoke VNets, and VNet Peering connections.
firewall.tf: The Azure Firewall instance, its mandatory dedicated subnet (AzureFirewallSubnet), and Public IP configuration.
routing.tf: Route Tables and User Defined Routes (UDRs) that implement forced tunneling for the Spoke workloads.
.gitignore: Ensures sensitive state files (.tfstate) and provider binaries are never committed to version control.

🚀 Deployment Instructions
To deploy this architecture to your own Azure subscription, ensure you have the Azure CLI and Terraform installed.

Authenticate to Azure:
az login

Initialize Terraform:
terraform init

Review the Deployment Plan:
terraform plan

Deploy the Infrastructure:
terraform apply

Note: The deployment of the Azure Firewall resource typically takes 10-15 minutes.

🧹 Clean Up

To avoid ongoing charges (particularly for the Azure Firewall and Public IPs), destroy the resources when not in use:
terraform destroy

👨‍‍💻 About the Author
Matheus Luiz Saito Soares
Azure Cloud & Security Architect
Focused on building secure, scalable, and automated cloud infrastructure. Holding multiple expert-level Microsoft certifications including AZ-305 (Azure Solutions Architect Expert) and SC-100 (Cybersecurity Architect Expert).

Connect with me on LinkedIn: https://www.linkedin.com/in/matheus-luiz-saito-soares-b7ab80236
