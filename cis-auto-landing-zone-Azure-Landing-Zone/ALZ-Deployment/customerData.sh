#!/bin/bash

# Default Variables
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
MGID=alz
rg=rg-management



sed -i "s/PPCR/N/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json
# Prompt the user for deploymentType 
echo "Enter the AZL deployment Type (Small, Medium or Large)"
read deploymentType

# Prompt the user for customer Location 
echo "Enter customer Location (Eg uksouth):"
read LOCATION

# Feed files
sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/logging/parameters/logging.parameters.all.json
sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json

# Prompt the user for customer Name 
echo "Enter customer Name:"
read customerName

# Feed files

sed -i "s/customerName/${customerName}/g" infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.$deploymentType.json

# Prompt the user for mgmt subscirption Id 
echo "Enter customer management subscription ID:"
read mgmtSubID

# Feed file
sed -i "s/mgmtSubID/${mgmtSubID}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json

# Prompt the user for the securityEmail variable 
echo "Enter customer Security Email:"
read securityEmail

# Feed files
sed -i "s/securityEmail/${securityEmail}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.all.json

# Output the entered variables
echo "#############################################################"
echo "#############################################################"
echo "The customer data is:"
echo "Location: $LOCATION"
echo "Management Sub ID: $mgmtSubID"
echo "Deployment Type: $deploymentType"
echo "Customer Name: $customerName"
echo "Security Email: $securityEmail"
