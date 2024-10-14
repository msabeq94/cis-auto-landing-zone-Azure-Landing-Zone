targetScope = 'tenant'

metadata name = 'ALZ Bicep - Management Groups Module'
metadata description = 'ALZ Bicep Module to set up Management Group structure for Small Depoloyment Type'

@sys.description('Prefix for the management group hierarchy. This management group will be created as part of the deployment.')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Display name for top level management group. This name will be applied to the management group prefix defined in parTopLevelManagementGroupPrefix parameter.')
@minLength(2)
param parTopLevelManagementGroupDisplayName string = 'Azure Landing Zones'

@sys.description('Optional parent for Management Group hierarchy, used as intermediate root Management Group parent, if specified. If empty, default, will deploy beneath Tenant Root Management Group.')
param parTopLevelManagementGroupParentId string = ''

@sys.description('Set Parameter to true to Opt-out of deployment telemetry.')
param parTelemetryOptOut bool = false

// Platform Management Groups &  Child Management Groups
var varPlatformMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform'
  displayName: 'Platform'
}
var varPlatformManagementMg = {
  name: '${parTopLevelManagementGroupPrefix}-platform-management'
  displayName: 'Management'
}

// Landing Zones & Child Management Groups
var varLandingZonesMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones'
  displayName: 'Landing Zones'
}
var varLandingZonesOnlineMg = {
  name: '${parTopLevelManagementGroupPrefix}-landingzones-online'
  displayName: 'Online'
}


// Customer Usage Attribution Id
var varCuaid = '9b7965a0-d77c-41d6-85ef-ec3dfea4845b'

// Level 1
resource resTopLevelMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: parTopLevelManagementGroupPrefix
  properties: {
    displayName: parTopLevelManagementGroupDisplayName
    details: {
      parent: {
        id: empty(parTopLevelManagementGroupParentId) ? '/providers/Microsoft.Management/managementGroups/${tenant().tenantId}' : parTopLevelManagementGroupParentId
      }
    }
  }
}

// Level 2
resource resPlatformMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: varPlatformMg.name
  properties: {
    displayName: varPlatformMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

resource resLandingZonesMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: varLandingZonesMg.name
  properties: {
    displayName: varLandingZonesMg.displayName
    details: {
      parent: {
        id: resTopLevelMg.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Platform MG
resource resPlatformManagementMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: varPlatformManagementMg.name
  properties: {
    displayName: varPlatformManagementMg.displayName
    details: {
      parent: {
        id: resPlatformMg.id
      }
    }
  }
}

// Level 3 - Child Management Groups under Landing Zones MG
resource resLandingZonesOnlineMg 'Microsoft.Management/managementGroups@2023-04-01' = {
  name: varLandingZonesOnlineMg.name
  properties: {
    displayName: varLandingZonesOnlineMg.displayName
    details: {
      parent: {
        id: resLandingZonesMg.id
      }
    }
  }
}

// Optional Deployment for Customer Usage Attribution
module modCustomerUsageAttribution '../../CRML/customerUsageAttribution/cuaIdTenant.bicep' = if (!parTelemetryOptOut) {
  #disable-next-line no-loc-expr-outside-params //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information //Only to ensure telemetry data is stored in same location as deployment. See https://github.com/Azure/ALZ-Bicep/wiki/FAQ#why-are-some-linter-rules-disabled-via-the-disable-next-line-bicep-function for more information
  name: 'pid-${varCuaid}-${uniqueString(deployment().location)}'
  params: {}
}

// Output Management Group IDs
output outTopLevelManagementGroupId string = resTopLevelMg.id
output outPlatformManagementGroupId string = resPlatformMg.id
output outLandingZonesManagementGroupId string = resLandingZonesMg.id


// Output Management Group Names
output outTopLevelManagementGroupName string = resTopLevelMg.name

output outPlatformManagementGroupName string = resPlatformMg.name

output outLandingZonesManagementGroupName string = resLandingZonesMg.name

