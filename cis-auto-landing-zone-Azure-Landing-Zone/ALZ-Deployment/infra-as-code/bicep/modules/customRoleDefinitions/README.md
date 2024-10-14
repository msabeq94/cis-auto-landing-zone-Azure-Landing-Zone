# Module:  Custom Role Definitions

This module defines custom roles based on the recommendations from the Azure Landing Zone Conceptual Architecture.  The role definitions are defined in [Identity and access management](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/enterprise-scale/identity-and-access-management) recommendations.

Module supports the following custom roles:

- [*ManagementGroupId] Subscription owner
- [*ManagementGroupId] Application owners (DevOps/AppOps)
- [*ManagementGroupId] Network management (NetOps)
- [*ManagementGroupId] Security operations (SecOps)

*The custom role names are prefixed with `[ManagementGroupId]` since custom roles scoped at Management Group level must be unique within the Azure AD tenant.
