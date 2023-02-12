# CIS-Microsoft-Intune-For-Windows-IntuneProfile
This repository houses prebuilt Microsoft Intune configuration profiles that can be imported into Microsoft Endpoint Manager (MDM) including CIS benchmarks.

At the moment, all portions of the CIS Intune benchmark (L1,L2,BL) are being implemented into a single configuration profile. Once all portions have been implemented, I plan to separate them.

Some CIS configurations have been "opposed". When a configuration has been opposed, the configuration strays away from the CIS recommended option. The OMA-URI description species any configurations that have been opposed and provides a reason for the setting.

# Implemented using OMA-URI
The profiles are all configured using OMA-URI. There are a few reasons for this approach:
- Each configuration can be named according the section and name provided by CIS. EG: 1.1.1 <Name>
- It is clear what CIS option a particular configuration is addressing
- When CIS recommendations change, it will be easy to make changes to align with the new recommendation
- OMA-URIs allow for a "description". This description can be used to note configurations that differ from CIS and provide a reason for the difference. If you use Risk Acceptance Forms (RAF) in your environment, you can also note a RAF # to address the difference.
 

A lot of the OMA-URIs in these configuration profiles are not published by CIS. The OMA-URIs were found here: https://learn.microsoft.com/en-us/windows/client-management/mdm/
Some configuration options were found by finding corresponding ADMX Group Policy files and locating their xml element ids. These are specified using the SyncML <data id=""> syntax as documented here: https://learn.microsoft.com/en-us/windows/client-management/understanding-admx-backed-policies#enabling-a-policy
If you need to implement your own configurations, open the admx file (located at C:\windows\policydefintions) and locate the policy and the corresponding element you want to configure and follow the <enabled/><data id="config_id" values="value_you_want"/> syntax.

# Importing
To import a profile, use this Powershell Script: https://github.com/eneerge/Azure-Intune-Export-DeviceConfiguration-Decrypts/blob/main/DeviceConfiguration_Import_FromJSON.ps1
The above script supports unicode which is required to import the profile correctly. The ones provided by Microsoft do not support unicode, but unicode is required in order to configure some policies.

# Importing requirements
You need the AzureAD powershell module. Run this from an administrative powershell console:
`Install-Module AzureAD`

# Status
Profile currently goes up to 18.9.11.1.1, but will soon cover the entire CIS Intune benchmark.
