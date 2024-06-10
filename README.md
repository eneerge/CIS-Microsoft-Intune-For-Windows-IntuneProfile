![alt text](https://github.com/eneerge/CIS-Microsoft-Intune-For-Windows-IntuneProfile/raw/main/screenshots/intuness.png?raw=true)

June 10, 2024

# CIS-Microsoft-Intune-For-Windows-IntuneProfile
This repository houses prebuilt Microsoft Intune configuration profiles in JSON format for Windows 10 and Windows 11 that can be imported into Microsoft Intune. (https://intune.microsoft.com).

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
To import a profile:
1. Download this Powershell Script: [IntuneConfiguration_ImportCustomConfig.ps1](https://github.com/eneerge/CIS-Microsoft-Intune-For-Windows-IntuneProfile/blob/main/ImportScript/IntuneConfiguration_ImportCustomConfig.ps1)
2. Download the JSON configuration file of your choosing (either Win11 or Win10)
3. Run the powershell script
4. Enter the location to the JSON file when prompted

NOTE: To use the new Import script, you may need to "Approve" the requested app access. This is done in the Azure Portal under [Enterprise Applications -> Admin consent Requests](https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AccessRequests/menuId~/null)

# Windows 11 CIS Gaps / Unimplemented Configurations
In the Windows 11 template, I have added comments to the configuration that specifies what settings have not been implemented. The reason for this is either:
- Because of a Microsoft recommendation that conflicts with CIS'
- Because the setting would commonly break something
- Because an OMAURI is not available.

In addition, some settings have been implemented but have been "Opposed". This means, the CIS recommendation has been rejected by me for a particular reason in my environment as noted on in the description.
You should review the unimplemented and oppposed settings and address these gaps in your environment either with rejection documentation or implementation elsewhere.
A full test and audit of the new configuration is commencing now (June 10, 2024) to ensure proper implementation. Results will follow soon.

# Windows 10 CIS Gaps / Unimplemented Configurations
The Windows 10 template has a few gaps that I have addressed manually in my environment. Please refer to the Audit results to to see if there's anything you should address. This configuration is currently running in an active production environment without any issue.

# Known Issues / Troubleshooting
To verify a configuration applied:
- Open Event Viewer on the machine the configuration was deployed to
- Open "Application and Services Logs"\Microsoft\Windows\DeviceManagement-Enterprise-Diagnostics-Provider\Admin"
- Review any entries with "Error"
  - Ignore event id 2545 (checkNewInstanceData) - this appears to be an Intune bug. See https://answers.microsoft.com/en-us/windows/forum/all/event-2545-microsoft-windows-devicemanagement/a7e0f8e9-685f-44d8-be69-58fd1f8a716e. As of 2024.01.23, I am no longer seeing this in my deployment.
  - Ignore error referencing "./Device/Vendor/MSFT/Policy/ConfigOpoerations/ADMXInstall/Receiver/Properties/Policy/FakePolicy/Version. This is an expected error the informs you that Intune is working properly. See: https://www.reddit.com/r/Intune/comments/n8u51x/intune_fakepolicy_not_found_error/

- Intune remediation failures for User Rights Assignment policies that apply a blank value. (2.2.1 through 2.2.30)
  - May report the error "0x87D1FDE8" (Remediation Failure). Despite this error, the blank policies are applied properly.
  - This appears to be an issue with intune reporting. See the "cause" mentioned here: https://learn.microsoft.com/en-us/troubleshoot/mem/intune/device-configuration/device-configuration-profile-reports-error-2016281112
  - Because blanks are specified using <!CDATA[]]>, Intune expects to receive this value in the response. However, only "blank" is sent back to Intune, resulting in this "error" even though the policy was applied successfully.
  - These blank policies can be refactored into a new policy (Endpoint protection/User Rights) that does not use OMA-URI to prevent this reporting error.

# Extras
Firefox can be a pain to work with OMA-URIs. I created a stylesheet to make it a lot easier and that can be seen in the screenshot above. To install, go into the "Extras" folder for instructions.
