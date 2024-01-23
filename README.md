![alt text](https://github.com/eneerge/CIS-Microsoft-Intune-For-Windows-IntuneProfile/raw/main/screenshots/intuness.png?raw=true)

# CIS-Microsoft-Intune-For-Windows-IntuneProfile
This repository houses prebuilt Microsoft Intune configuration profiles in JSON format that can be imported into Microsoft Endpoint Manager (MDM). Benchmark:  https://workbench.cisecurity.org/benchmarks/14355 (v2.0.0)

At the moment, all portions of the CIS Intune benchmark (L1,L2,BL,NG) are being implemented into a single configuration profile. Once all portions have been implemented, I plan to separate them.

Some CIS configurations have been "opposed". When a configuration has been opposed, the configuration strays away from the CIS recommended option. The OMA-URI description specifies any configurations that have been opposed and provides a reason for the setting. You can follow a similar strategy in your environment if you require changes.

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
2024.01.22 Microsoft no longer supports ADAL, so I have included a new script that uses the Microsoft.Graph Powershell Module to import the configuration.

To import a profile:
1. Download this Powershell Script: [IntuneConfiguration_ImportCustomConfig.ps1](https://github.com/eneerge/CIS-Microsoft-Intune-For-Windows-IntuneProfile/blob/main/IntuneConfiguration_ImportCustomConfig.ps1)
2. Download the JSON configuration file in this repository
3. Run the powershell script
4. Enter the location to the JSON file when prompted

NOTE: To use the new Import script, you may need to "Approve" the requested appaccess. This is done in the Azure Portal under [Enterprise Applications -> Admin consent Requests](https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AccessRequests/menuId~/null)

# Known Issues
- Some configurations require specifying a blank value. For example, the "EnableDelegation" setting. No user should be allowed this privilege. The recommendation is to leave this blank. The only way to specify a blank in Intune is to use the cdata option. (EG: `<![CDATA[]]>`). Configurations that specify a blank may report remediation failure. These may be refactored into a separate profile that does not use OMA-URI to prevent these "errors".

To verify a configuration applied:
- Open Event Viewer
- Open the log "Application and Services Logs"\Microsoft\Windows\DeviceManagement-Enterprise-Diagnostics-Provider\Admin
- Review any entries with "Error"
  - Ignore event id 2545 (checkNewInstanceData) - this appears to be an Intune bug. See https://answers.microsoft.com/en-us/windows/forum/all/event-2545-microsoft-windows-devicemanagement/a7e0f8e9-685f-44d8-be69-58fd1f8a716e
  - Ignore error referencing "./Device/Vendor/MSFT/Policy/ConfigOpoerations/ADMXInstall/Receiver/Properties/Policy/FakePolicy/Version. This is an expected error the informs you that Intune is working properly. See: https://www.reddit.com/r/Intune/comments/n8u51x/intune_fakepolicy_not_found_error/

# Extras
Firefox can be a pain to work with OMA-URIs. I created a stylesheet to make it a lot easier and that can be seen in the screenshot above. To install, go into the "Extras" folder for instructions.

# Status
All settings of CIS Intune benchmark implemented with the exception of Bitlocker. A seperate bitlocker configuration will be created.
