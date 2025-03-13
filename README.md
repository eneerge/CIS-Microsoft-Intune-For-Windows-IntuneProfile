![alt text](https://github.com/eneerge/CIS-Microsoft-Intune-For-Windows-IntuneProfile/raw/main/screenshots/intuness.png?raw=true)

March 13, 2025

# CIS-Microsoft-Intune-For-Windows-IntuneProfile
This repository houses prebuilt Microsoft Intune configuration profiles for Windows 10 and Windows 11 that can be imported into Microsoft Intune. (https://intune.microsoft.com). Older releases (archive folder) provided JSON files with a PowerShell script to import them. Newer versions use the Microsoft.Graph.DeviceManagement PowerShell module which will be automatically installed (User Scope) if required.

# Implemented using OMA-URI
Most settings are configured using OMA-URI. There are a few reasons for this approach:
- Each configuration can be named according the section and name provided by CIS. EG: 1.1.1 <Name>
- It is clear what CIS option a particular configuration is addressing
- When CIS recommendations change, it will be easy to make changes to align with the new recommendation
- OMA-URIs allow for a "description". This description can be used to note configurations that differ from CIS and provide a reason for the difference. If you use Risk Acceptance Forms (RAF) in your environment, you can also note a RAF # to address the difference/ allow Intune to reference external documentation.

 
A lot of the OMA-URIs in these configuration profiles are not published by CIS. The OMA-URIs were found here: https://learn.microsoft.com/en-us/windows/client-management/mdm/
Some configuration options were found by finding corresponding ADMX Group Policy files and locating their xml element ids. These are specified using the SyncML <data id=""> syntax as documented here: https://learn.microsoft.com/en-us/windows/client-management/understanding-admx-backed-policies#enabling-a-policy
If you need to implement your own configurations, open the admx file (located at C:\windows\policydefintions) and locate the policy and the corresponding element you want to configure and follow the <enabled/><data id="config_id" values="value_you_want"/> syntax.

# How to Use
1. Download the PowerShell script
2. Edit the script to provide your Tenant ID, Login Message, and the name you would like to call the policy in Intune
3. Run the PowerShell script to import the configuration to Intune
4. In Intune, assign the configuration to users/groups.

NOTES:
- You may need to run `Set-ExecutionPolicy unrestricted` as a local admin to allow running of scripts
- This script uses <b>Microsoft.Graph.DeviceManagement</b> (release version) to import the configuration. If this is not detected, it will automatically install in user scope. This means, it will install to your C:\Users\JohnDoe\Documents\WindowsPowerShell\Modules or C:\Users\JohnDoe\Company - UM Foundation\Documents\WindowsPowerShell\Modules. You can delete "Microsoft.Graph.DeviceManagement" the PowerShell subfolder to remove after importing if no longer needed.
- You must have the proper Intune permissions to import. Typically this is the <b>Intune Administrator role</b>. Specifically, you need the following: `DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementConfiguration.Read.All`

# Windows 11
CIS Microsoft Intune for Windows 11 v3.0.1 (https://workbench.cisecurity.org/benchmarks/16853) is implemented.

# Windows 10
Windows 10 configurations are all archived and will no longer be updated due to the end of support for Windows 10 in October 2025. Please navigate to the archived folder for the antiquated Windows 10 configuration scripts.

# Audits
These configurations are audited multiple times to ensure adherence to CIS published configurations. Small Excel files have been provided to view summary results of each audit.

In some cases, the CIS configuration has been "opposed". You should review these and decide if these alternate configurations should apply in your environment. Configurations may be opposed for any of the following reasons:
1. In some cases, CIS makes suggestions that are favor privacy over security. A few options, such as Windows Defender MAPS have been configured differently than CIS recommendations.
2. Configurations that block people from properly communicating in a work environment (such as disabling the web camera) have been opposed for obvious reasons.
3. The risk associated with uncommon attacks such as dumping memory from a computer that is in a sleep state are acceptable. Sleep states have been allowed.
4. Other reasons are specified in the description if any setting is opposed.

# Known Issues / Troubleshooting
To verify a configuration applied:
- Open Event Viewer on the machine the configuration was deployed to
- Open "Application and Services Logs"\Microsoft\Windows\DeviceManagement-Enterprise-Diagnostics-Provider\Admin"
- Review any entries with "Error"
  - Ignore error referencing "./Device/Vendor/MSFT/Policy/ConfigOpoerations/ADMXInstall/Receiver/Properties/Policy/FakePolicy/Version. This is an expected error the informs you that Intune is working properly. See: https://www.reddit.com/r/Intune/comments/n8u51x/intune_fakepolicy_not_found_error/

- Intune remediation failures for User Rights Assignment policies that apply a blank value. (2.2.1 through 2.2.30)
  - May report the error "0x87D1FDE8" (Remediation Failure). Despite this error, the blank policies are applied properly.
  - This appears to be an issue with intune reporting. See the "cause" mentioned here: https://learn.microsoft.com/en-us/troubleshoot/mem/intune/device-configuration/device-configuration-profile-reports-error-2016281112
  - Because blanks are specified using <!CDATA[]]>, Intune expects to receive this value in the response. However, only "blank" is sent back to Intune, resulting in this "error" even though the policy was applied successfully.
  - Due to this error, I have moved all "blank policies" into a separate non-OMAURI configuration policy.

# Extras
Firefox can be a pain to work with OMA-URIs. I created a stylesheet to make it a lot easier and that can be seen in the screenshot above. To install, go into the "Extras" folder for instructions.
