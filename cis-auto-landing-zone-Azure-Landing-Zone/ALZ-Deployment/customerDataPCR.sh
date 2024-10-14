#!/bin/bash

# Default Variables
dateYMD=$(date +%Y%m%dT%H%M%S%NZ)
MGID="alz"


sed -i "s/PPCR/Y/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.allPCR.json
# Prompt the user for Resource Group 
echo "Enter resorce group name created by PCR build (Eg: vf-core-GB-resources-rg):"
read  rg

# Feed File
sed -i "s/rg/${rg}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.allPCR.json

# Prompt the user for Deployment Type
echo "Enter the deployment Type (Small, Medium or Large)"
read  deploymentType

# Prompt the user for customer Location 
echo "Enter customer Location (Eg uksouth):"
read  LOCATION

# Feed files
sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/logging/parameters/logging.parameters.allPCR.json
sed -i "s/customerLocation/${LOCATION}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.allPCR.json

# Prompt the user for customer Name 
echo "Enter customer Name:"
read  customerName

# Feed files
sed -i "s/customerName/${customerName}/g" infra-as-code/bicep/modules/managementGroups/parameters/managementGroups.parameters.$deploymentType.json

# Prompt the user for mgmt subscirption Id 
echo "Enter customer management subscription ID:"
read  mgmtSubID

# Feed file
sed -i "s/mgmtSubID/${mgmtSubID}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.allPCR.json

# Prompt the user for the securityEmail variable 
echo "Enter customer Security Email:"
read securityEmail

# Feed files
sed -i "s/securityEmail/${securityEmail}/g" infra-as-code/bicep/modules/policy/assignments/alzDefaults/parameters/alzDefaultPolicyAssignments.parameters.allPCR.json

# Output the entered variables
echo "#############################################################"
echo "#############################################################"
echo "The customer data is:"
echo "Customer Name: $customerName"
echo "Location: $LOCATION"
echo "Deployment Type: $deploymentType"
echo "Resource Group: $rg"
echo "Management subscription ID: $mgmtSubID"
echo "Security Email: $securityEmail"

