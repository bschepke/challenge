# Challenge

Pipeline 1

[![Build Status](https://dev.azure.com/schepkebailey/challenge/_apis/build/status/Pipeline%201?branchName=master)](https://dev.azure.com/schepkebailey/challenge/_build/latest?definitionId=4&branchName=master)

Pipeline 2

[![Build Status](https://dev.azure.com/schepkebailey/challenge/_apis/build/status/Pipeline%202?branchName=master)](https://dev.azure.com/schepkebailey/challenge/_build/latest?definitionId=5&branchName=master)

## Pipeline Variables

### `ARM_ACCESS_KEY`
Access key for terraform state storage account.

To get the value, run: `az storage account keys list --resource-group $RESOURCE_GROUP_STORAGE --account-name $ACCOUNT_NAME --query '[0].value' -o tsv`

## Runtime Variables

### `Resource Group`
Set the resource group the infrastructure will be deployed to.

Can be a new or existing resource group.
