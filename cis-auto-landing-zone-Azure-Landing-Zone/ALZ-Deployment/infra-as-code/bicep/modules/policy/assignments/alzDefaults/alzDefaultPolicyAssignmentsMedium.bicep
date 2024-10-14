metadata name = 'ALZ Bicep - ALZ Default Policy Assignments'
metadata description = 'This policy assignment will assign the ALZ Default Policy to management groups'
param parPCR string
@sys.description('Prefix for the management group hierarchy.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('The region where the Log Analytics Workspace & Automation Account are deployed.')
param parLogAnalyticsWorkSpaceAndAutomationAccountLocation string = 'customerLocation'

@sys.description('Log Analytics Workspace Resource ID.')
param parLogAnalyticsWorkspaceResourceId string = 'workspaceID'

@sys.description('Number of days of log retention for Log Analytics Workspace.')
param parLogAnalyticsWorkspaceLogRetentionInDays string = '365'

@sys.description('Automation account name.')
param parAutomationAccountName string = 'alz-automation-account'

@sys.description('An e-mail address that you want Microsoft Defender for Cloud alerts to be sent to.')
param parMsDefenderForCloudEmailSecurityContact string = 'securityEmail'


@sys.description('Set Parameter to true to Opt-out of deployment telemetry')
param parTelemetryOptOut bool = false

var varLogAnalyticsWorkspaceName = split(parLogAnalyticsWorkspaceResourceId, '/')[8]

var varLogAnalyticsWorkspaceResourceGroupName = split(parLogAnalyticsWorkspaceResourceId, '/')[4]

// Customer Usage Attribution Id
var varCuaid = '98cef979-5a6b-403b-83c7-10c8f04ac9a2'

// **Variables**
// Orchestration Module Variables
var varDeploymentNameWrappers = {
  basePrefix: 'ALZBicep'
  #disable-next-line no-loc-expr-outside-params //Policies resources are not deployed to a region, like other resources, but the metadata is stored in a region hence requiring this to keep input parameters reduced. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  baseSuffixTenantAndManagementGroup: '${deployment().location}-${uniqueString(deployment().location, parTopLevelManagementGroupPrefix)}'
}

var varModuleDeploymentNames = {
  modPolicyAssignmentIntRootDeployMdfcConfig: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployMDFCConfig-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAzActivityLog: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployAzActivityLog-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployAscMonitoring: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployASCMonitoring-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIntRootDeployResourceDiag: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployResoruceDiag-intRoot-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyPublicIp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyPublicIP-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenyRdpFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentIdentDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-ident-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentMgmtDeployLogAnalytics: take('${varDeploymentNameWrappers.basePrefix}-polAssi-deployLAW-mgmt-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyRdpFromInternet: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyRDPFromInet-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenySubnetWithoutNsg: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denySubnetNoNSG-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
  modPolicyAssignmentLzsDenyStorageHttp: take('${varDeploymentNameWrappers.basePrefix}-polAssi-denyStorageHttp-lz-${varDeploymentNameWrappers.baseSuffixTenantAndManagementGroup}', 64)
 

}

// Policy Assignments Modules Variables

var varPolicyAssignmentDenyPublicIP = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_public_ip.tmpl.json')
}

var varPolicyAssignmentDenyRDPFromInternet = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-RDP-From-Internet'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_rdp_from_internet.tmpl.json')
}

var varPolicyAssignmentDenyStoragehttp = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_storage_http.tmpl.json')
}

var varPolicyAssignmentDenySubnetWithoutNsg = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deny-Subnet-Without-Nsg'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deny_subnet_without_nsg.tmpl.json')
}


var varPolicyAssignmentDeployASCMonitoring = {
  definitionId: '/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_asc_monitoring.tmpl.json')
}

var varPolicyAssignmentDeployAzActivityLog = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policyDefinitions/Deploy-AzActivity-Log'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_azactivity_log.tmpl.json')
}

var varPolicyAssignmentDeployLogAnalytics = {
  definitionId: '/providers/Microsoft.Authorization/policyDefinitions/8e3e61b3-0b32-22d5-4edf-55f87fdb5955'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_log_analytics.tmpl.json')
}

var varPolicyAssignmentDeployMDFCConfig = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-MDFC-Config'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_mdfc_config.tmpl.json')
}


var varPolicyAssignmentDeployResourceDiag = {
  definitionId: '${varTopLevelManagementGroupResourceId}/providers/Microsoft.Authorization/policySetDefinitions/Deploy-Diagnostics-LogAnalytics'
  libDefinition: loadJsonContent('../../../policy/assignments/lib/policy_assignments/policy_assignment_es_deploy_resource_diag.tmpl.json')
}


// RBAC Role Definitions Variables - Used For Policy Assignments
var varRbacRoleDefinitionIds = {
  owner: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  contributor: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  networkContributor: '4d97b98b-1d4f-4787-a291-c67834d212e7'
  aksContributor: 'ed7f3fbd-7b88-4dd4-9017-9adb7ce333f8'
}

// Managment Groups Varaibles - Used For Policy Assignments
var varManagementGroupIds = {
  intRoot: parTopLevelManagementGroupPrefix
  platform: '${parTopLevelManagementGroupPrefix}-platform'
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online'
}

var varTopLevelManagementGroupResourceId = '/providers/Microsoft.Management/managementGroups/${varManagementGroupIds.intRoot}'


// **Scope**
targetScope = 'managementGroup'

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../../../CRML/customerUsageAttribution/cuaIdManagementGroup.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Modules - Policy Assignments - Intermediate Root Management Group
// Module - Policy Assignment - Deploy-MDFC-Config
module modPolicyAssignmentIntRootDeployMdfcConfig '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployMdfcConfig
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployMDFCConfig.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployMDFCConfig.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      emailSecurityContact: {
        value: parMsDefenderForCloudEmailSecurityContact
      }
      ascExportResourceGroupLocation: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployMDFCConfig.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployMDFCConfig.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-AzActivity-Log
module modPolicyAssignmentIntRootDeployAzActivityLog '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAzActivityLog
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployAzActivityLog.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployAzActivityLog.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployAzActivityLog.libDefinition.identity.type
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployAzActivityLog.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-ASC-Monitoring
module modPolicyAssignmentIntRootDeployAscMonitoring '../../../policy/assignments/policyAssignmentManagementGroup.bicep'= if (parPCR == 'N')  {
  // dependsOn: [
  //   modCustomPolicyDefinitions
  // ]
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployAscMonitoring
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployASCMonitoring.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployASCMonitoring.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployASCMonitoring.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployASCMonitoring.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deploy-Resource-Diag
module modPolicyAssignmentIntRootDeployResourceDiag '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.intRoot)
  name: varModuleDeploymentNames.modPolicyAssignmentIntRootDeployResourceDiag
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployResourceDiag.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployResourceDiag.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      logAnalytics: {
        value: parLogAnalyticsWorkspaceResourceId
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployResourceDiag.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployResourceDiag.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}


// Modules - Policy Assignments - Identity Management Group
// Module - Policy Assignment - Deny-Public-IP
module modPolicyAssignmentIdentDenyPublicIp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyPublicIp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyPublicIP.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyPublicIP.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyPublicIP.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyPublicIP.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyPublicIP.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyPublicIP.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyPublicIP.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentIdentDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentIdentDenyRdpFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformIdentity)
  name: varModuleDeploymentNames.modPolicyAssignmentIdentDenyRdpFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRDPFromInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRDPFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}



// // Modules - Policy Assignments - Platform Management Management Group
// Module - Policy Assignment - Deploy-Log-Analytics
module modPolicyAssignmentMgmtDeployLogAnalytics '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.platformManagement)
  name: varModuleDeploymentNames.modPolicyAssignmentMgmtDeployLogAnalytics
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDeployLogAnalytics.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDeployLogAnalytics.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.parameters
    parPolicyAssignmentParameterOverrides: {
      rgName: {
        value: varLogAnalyticsWorkspaceResourceGroupName
      }
      workspaceName: {
        value: varLogAnalyticsWorkspaceName
      }
      workspaceRegion: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
      dataRetention: {
        value: parLogAnalyticsWorkspaceLogRetentionInDays
      }
      automationAccountName: {
        value: parAutomationAccountName
      }
      automationRegion: {
        value: parLogAnalyticsWorkSpaceAndAutomationAccountLocation
      }
    }
    parPolicyAssignmentIdentityType: varPolicyAssignmentDeployLogAnalytics.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDeployLogAnalytics.libDefinition.properties.enforcementMode
    parPolicyAssignmentIdentityRoleDefinitionIds: [
      varRbacRoleDefinitionIds.owner
    ]
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Modules - Policy Assignments - Landing Zones Management Group


// Module - Policy Assignment - Deny-RDP-From-Internet
module modPolicyAssignmentLzsDenyRdpFromInternet '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyRdpFromInternet
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyRDPFromInternet.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyRDPFromInternet.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyRDPFromInternet.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Subnet-Without-Nsg
module modPolicyAssignmentLzsDenySubnetWithoutNsg '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenySubnetWithoutNsg
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenySubnetWithoutNsg.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenySubnetWithoutNsg.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}

// Module - Policy Assignment - Deny-Storage-http
module modPolicyAssignmentLzsDenyStorageHttp '../../../policy/assignments/policyAssignmentManagementGroup.bicep' = {
  scope: managementGroup(varManagementGroupIds.landingZones)
  name: varModuleDeploymentNames.modPolicyAssignmentLzsDenyStorageHttp
  params: {
    parPolicyAssignmentDefinitionId: varPolicyAssignmentDenyStoragehttp.definitionId
    parPolicyAssignmentName: varPolicyAssignmentDenyStoragehttp.libDefinition.name
    parPolicyAssignmentDisplayName: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.displayName
    parPolicyAssignmentDescription: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.description
    parPolicyAssignmentParameters: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.parameters
    parPolicyAssignmentIdentityType: varPolicyAssignmentDenyStoragehttp.libDefinition.identity.type
    parPolicyAssignmentEnforcementMode: varPolicyAssignmentDenyStoragehttp.libDefinition.properties.enforcementMode
    parTelemetryOptOut: parTelemetryOptOut
  }
}
