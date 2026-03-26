March 26, 2026

# Windows 11 CIS Microsoft Intune for Windows v4.0.0
These configuration templates aim to implement all configurations of the CIS Microsoft Intune for Windows v4.0.0 benchmark including both L1 and L2 policies.

Due to limitations with OMAURI/Intune, some configurations need to be applied using either a configuration that does not use OMAURI or a separate Powershell remediation script.

The following configuration scripts have been created:

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Amelioration)
- Certain configurations that CIS does not include in their recommendations, but probably should be set in an enterprise environment. IE: Disable Copilot, web search in start menu, etc.

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Attack Surface Reduction)
- CIS 22.7 to 22.22 recommends that Attack Surface Reduction configurations be applied. This script provides configuration options for setting ASR rules and loads them as a new ASR configuration. Configuration options are available in the script to assist with implementing.

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Bitlocker OMAURI).ps1
- CIS 4.11.7.*. Enables Bitlocker and backing up of recovery keys to Intune (using OMAURI)

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Blank Policies).ps1
- CIS 89.1 to 89.35. When configuring User Rights Policies, if a policy requires that no group/user have access, using a blank value in OMAURI fails. This policy creates a separate non-OMAURI policy that will apply the configuration without triggering a failure in Intune.

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (L1+L2).ps1
- This is the primary policy configuration that applies nearly all L1 and L2 configurations with the exception of ones that can't be applied using OMAURI

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Lock after 10min).ps1
- CIS 26.7 and 45.9 This sets the screen timeout to 10 minutes as recommended by CIS. This is not configured in the L1+L2 script, because it's common to have different timeouts for different types of devices.

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Lock Never).ps1
- Violates CIS 26.7 and 45.9. This sets the screen timeout to never. This is mainly for devices that should usually never lock (teleprompters, presentation devices, etc). This is the counterpart to the "Lock after 5min" configuration.

### CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Services Configuration).ps1
- CIS 81.1 to 81.42. This script configures all services specified in CIS benchmark to the recommended setting. When attempting to apply service configurations using OMAURI, an error is reported in the Event Viewer, despite following the Microsoft documents and the services are not configured properly. CIS has also noticed this issue and has documented the issue. This script works around that issue by running a Powershell script on the machine to configure each service.

- Do NOT run this script to install. This script should be uploaded into your "Scripts and Remediation" section under "Platform Scripts" and should run in the System context and you should disable signature checking since it's not a signed script.

# How to Use
1. Download the PowerShell script
2. Edit the configuration settings in each script (Tenant ID, Policy Name, Description, etc)
3. Run the PowerShell script to import the configuration to Intune
4. In Intune, assign the configuration to users/groups.

# Audits
Audits have been performed at different stages of development of these scripts. Each audit documents any exceptions and gaps between the configuration and the findings.

"Opposed" means the configuration differs with CIS recommendations intentionally either due to issues discovered in the environment or opinion differences.

The audits are performed using Tenable Nessus Compliance Scan modules (CIS Microsoft Intune for Windows 11 v4.0.0 BL, L1, L2). Results from those scans are extracted and put into custom spreadsheet.
