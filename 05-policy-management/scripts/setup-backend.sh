#!/bin/bash
# scripts/setup-backend.sh

RESOURCE_GROUP_NAME="rg-terraform-state-sec-portfolio"
# Generates a unique storage account name using a random string to avoid naming collisions
STORAGE_ACCOUNT_NAME="tfstatesec$(openssl rand -hex 4)"
CONTAINER_NAME="tfstate"
LOCATION="eastus"

echo "Creating Resource Group..."
az group create --name "$RESOURCE_GROUP_NAME" --location "$LOCATION"

echo "Creating Storage Account..."
az storage account create \
	--resource-group "$RESOURCE_GROUP_NAME" \
	--name "$STORAGE_ACCOUNT_NAME" \
	--sku Standard_LRS \
	--encryption-service blob \
	--allow-blob-public-access false

echo "Creating Storage Container..."
az storage container create \
	--name "$CONTAINER_NAME" \
	--account-name "$STORAGE_ACCOUNT_NAME" \
	--auth-mode login

echo "Storage Account Name: $STORAGE_ACCOUNT_NAME"
echo "Update your providers.tf with the storage account name above."
