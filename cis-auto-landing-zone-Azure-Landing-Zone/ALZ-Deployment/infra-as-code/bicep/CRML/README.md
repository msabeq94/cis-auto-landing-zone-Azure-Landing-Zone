# Why Does This Directory Exist & Contain Other Bicep Modules?

This directory exists to host modules that are **not** specific to the Azure Landing Zones modules that are contained within the `infra-as-code/bicep/modules` directory.

These modules are consumed and called by other modules within this repo. For example, the `customerUsageAttribution` module is called in all modules as you can see from each of those modules `.bicep` files.
