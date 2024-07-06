# Windows 11 CIS Microsoft Intune for Windows v3.0.1
These configuration templates aim to implement all configurations of the CIS Microsoft Intune for Windows v3.0.1 benchmark including both L1 and L2 policies.

Due to limitations with OMAURI/Intune, some configurations need to be applied using either a configuration that does not use OMAURI or a separate Powershell remediation script.

Currently there are 3 scripts:
- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Primary).ps1
  - This policy configuration applies nearly all L1 and L2 configurations with the exception of ones that can't be applied using OMAURI
  - Specify your tenant id, your desired logon message, and run.

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Blank Policies).ps1
  - When configuring User Rights Policies, if a policy requires that no group/user have access, using a blank value in OMAURI fails. This policy creates a separate non-OMAURI policy that will apply the configuration properly.

- CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Services Configuration).ps1
  - This script configures all services specified in CIS benchmark to the recommended setting. When attempting to apply service configurations using OMAURI, an error is reported in the Event Viewer, despite following the Microsoft documents and the services are not configured properly. CIS has also noticed this issue and has documented the issue. This script works around that issue by running a Powershell script on the machine to configure each service.

# New Requirements
I'm now using the Microsoft.Graph.Beta.DeviceManagement Powershell Module. To install:
`Install-Module Microsoft.Graph.Beta.DeviceManagement`

# Status
2024.07.05 Three configuration audit results have been uploaded to this repository that includes investigation into their failures and remediation procedures. Most failures have been remediated throughout the audits. However, there are still a few configurations that seem to be tricky get them to apply using Intune, and I may need to write additional remediation scripts to get them configured properly. Refer to the audit files to see what configurations are currently not being applied properly.

2024.06.28 Some configurations have returned a failure during audit and a few caused Intune conflicts. I am reviewing and tweaking. I will be breaking up the configurations into multiple powershell scripts so that both omauri and non-omauri configurations can be applied. These scripts will only map to the CIS benchmark for Windows 11.

2024.06 Currently testing and auditing.

# Audits
I've attached the audits I have performed with the results. Significant time was put into this to ensure proper configuration. Please see the audit results to determine if anything needs to be address in your environment. All items except for Bitlocker and the ASR configuration have been implemented and are passing.

# Notes
- CIS does not block web search in the start menu. I will release additional "amelioration" scripts to address this and some other issues I've observed with the CIS standard Intune recommendation.
- CIS also does not recommend using OneDrive and have made many suggestions to disable in their benchmarks. Additional configurations will be released with secure Onedrive settings.
- CIS Bitlocker (BL) Win11 configurations are in progress.
