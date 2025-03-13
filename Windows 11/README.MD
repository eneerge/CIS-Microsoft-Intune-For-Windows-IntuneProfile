March 13, 2025

# Windows 11 CIS Microsoft Intune for Windows v3.0.1
These configuration templates aim to implement all configurations of the CIS Microsoft Intune for Windows v3.0.1 benchmark including both L1 and L2 policies.

Due to limitations with OMAURI/Intune, some configurations need to be applied using either a configuration that does not use OMAURI or a separate Powershell remediation script.

The following configuration scripts have been created:
- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (L1+L2).ps1
  - This policy configuration applies nearly all L1 and L2 configurations with the exception of ones that can't be applied using OMAURI

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Bitlocker).ps1
  - Enables Bitlocker and backing up of recovery keys to Intune

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Blank Policies).ps1
  - When configuring User Rights Policies, if a policy requires that no group/user have access, using a blank value in OMAURI fails. This policy creates a separate non-OMAURI policy that will apply the configuration properly.

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Amelioration)
  - Certain configurations that CIS does not include in their recommendations, but probably should be set in an enterprise environment. IE: Disable Copilot, web search in start menu, etc.

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Services Configuration).ps1
  - This script configures all services specified in CIS benchmark to the recommended setting. When attempting to apply service configurations using OMAURI, an error is reported in the Event Viewer, despite following the Microsoft documents and the services are not configured properly. CIS has also noticed this issue and has documented the issue. This script works around that issue by running a Powershell script on the machine to configure each service.
  - Do NOT run this script to install. This script should be uploaded into your "Scripts and Remediation" section under "Platform Scripts" and should run in the System context.

# How to Use
1. Download the PowerShell script
2. Edit the script to provide your Tenant ID, Login Message, and the name you would like to call the policy in Intune
3. Run the PowerShell script to import the configuration to Intune
4. In Intune, assign the configuration to users/groups.


# Audits
See "Audits" folder for current results.


# Notes
- CIS also does not recommend using OneDrive and have made many suggestions to disable in their benchmarks. Additional configurations will be released with secure Onedrive settings.
