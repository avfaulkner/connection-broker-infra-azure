# Connection Broker Infrastructure in Azure

## **WIP**

## Diagram

![certiport_leostream](./certiport_leostream.png?raw=true "Infra diagram")

## Requirements

### Tooling

- Azure CLI version 2.0.79 or newer.
- Terraform version 0.13.0.

### Terraform backend / Terraform state files

- The Terraform backend / state files will be stored in a separate Resource Group from the rest of the infrastructure.
This Resource Group will contain a storage account containing a container for blob storage, which will store the Terraform state files. These files allow Terraform to keep track of the physical infrastructure that it has created in Azure.
To create the above, run this file first: **azurecli.sh**.

## Steps to Run

1. Authenticate to Azure

```
az login
```

This will open the browser with a message confirming successful authentication.

Note:
If running in WSL2, then run the following:

```
az login --use-device-code
```

Then use a web browser to open the page <https://microsoft.com/devicelogin> and enter the code provided in the terminal output.

2. You will need several values from your Azure account:

Choose your subscription ID:

```
az account list --output table
```

3. Set subscription

```
az account set --subscription <Azure-SubscriptionId>
```

4. Use your subscription ID to create the service principal account:

```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID" --name="Terraform-spa"
```

This code will output several values. These values will be mapped to these Terraform variables:

- appId (Azure) → client_id (Terraform).
- password (Azure) → client_secret (Terraform).
- tenant (Azure) → tenant_id (Terraform).

Add the subscription ID and Tenant ID to `providers.tf` in 'backend "azurerm"'.

5. Run the azurecli.sh script
This script will create the remote backend to store the Terraform state files.

```
chmod 764 azurecli.sh && ./azurecli.sh
```

The script will export a value called `storage_account_name` that looks like "tfstate(some value)". Place this value in `provider.tf` in 'backend "azurerm"'.

6. Remember to add all variables in `terraform.tfvars` prior to running the Terraform script.

7. Initialize Terraform

```
terraform init
```

8. View the infrastructure plan

```
terraform plan
```

9. Apply the Terraform plan

```
terraform apply
```

## Resources

- two resource groups
  - one for infrastructure
  - one which will contain blob storage to store the terraform state files
- application gateway
  - static public ip address for app gateway frontend
  - backend pool for app gateway backend
    - virtual machine scale set for brokers
  - app gateway listener
  - a routing rule to send traffic from a given frontend IP address to one or more backend targets.
    - A routing rule must contain a listener and at least one backend target.
- virtual network
- public subnet
- private subnet
- ssh key pair
