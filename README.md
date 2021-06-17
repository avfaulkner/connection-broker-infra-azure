# Connection Broker Infrastructure in Azure
## **WIP**

## Diagram
![certiport_leostream](./certiport_leostream.png?raw=true "Infra diagram")

## Requirements

### Tooling
- Azure CLI version 2.0.79 or newer.
- Terraform version 0.13.0.

### Azure Login
- Authenticate to your Azure account by running 'az login'.

### Terraform backend / Terraform state files
- The Terraform backend / state files will be stored in a separate Resource Group from the rest of the infrastructure. 
This Resource Group will contain a storage account containing a container for blob storage. 
An access key must also be created. 

- To create the above, RUN THIS FILE FIRST: **azurecli.sh**.
RUN **azurecli.sh** ON ITS OWN BEFORE RUNNING THE TERRAFORM. This is necessary to store the Terraform state files, which are created as the Terraform script runs and allows Terraform to keep track of the physical infrastructure that it has created in Azure. 


## Steps to Run

1. Authenticate to Azure
```
az login
```
This will open the browser with a message confirming successful authentication. 

2. You will need several values from your Azure account:

Choose your subscription ID:
```
az account list --output table
```

3. Use your subscription ID to create the service principal account:
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID" --name="Terraform-spa"
```

4. Run the azurecli.sh script
This script will create the remote backend to store the Terraform state files.
```
chmod 764 azurecli.sh && ./azurecli.sh
```

5. Initialize Terraform
```
terraform init
```

6. View the infrastructure plan
```
terraform plan
```

7. Apply the Terraform plan
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
    
