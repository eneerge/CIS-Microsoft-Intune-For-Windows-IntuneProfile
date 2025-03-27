March 13, 2025

# Windows 11 CIS Microsoft Intune for Windows v3.0.1
These configuration templates aim to implement all configurations of the CIS Microsoft Intune for Windows v3.0.1 benchmark including both L1 and L2 policies.

Due to limitations with OMAURI/Intune, some configurations need to be applied using either a configuration that does not use OMAURI or a separate Powershell remediation script.

The following configuration scripts have been created:

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Amelioration)
- Certain configurations that CIS does not include in their recommendations, but probably should be set in an enterprise environment. IE: Disable Copilot, web search in start menu, etc.

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Attack Surface Reduction)
- CIS 21.7 recommends that Attack Surface Reduction configurations be applied. This script provides configuration options for setting ASR rules and loads them as a new ASR configuration.

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Bitlocker OMAURI).ps1
- Enables Bitlocker and backing up of recovery keys to Intune (using OMAURI)

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Blank Policies).ps1
- When configuring User Rights Policies, if a policy requires that no group/user have access, using a blank value in OMAURI fails. This policy creates a separate non-OMAURI policy that will apply the configuration without triggering a failure in Intune.

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (L1+L2).ps1
- This is the primary policy configuration that applies nearly all L1 and L2 configurations with the exception of ones that can't be applied using OMAURI

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Lock after 5min).ps1
- This sets the screen timeout to 5 minutes as recommended by CIS. This is not configured in the L1+L2 script, because it's common to have different timeouts for different types of devices.

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Lock Never).ps1
- This sets the screen timeout to never. This is mainly for devices that should usually never lock (teleprompters, presentation devices, etc). This is the counterpart to the "Lock after 5min" configuration.

### CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Services Configuration).ps1
- This script configures all services specified in CIS benchmark to the recommended setting. When attempting to apply service configurations using OMAURI, an error is reported in the Event Viewer, despite following the Microsoft documents and the services are not configured properly. CIS has also noticed this issue and has documented the issue. This script works around that issue by running a Powershell script on the machine to configure each service.

- Do NOT run this script to install. This script should be uploaded into your "Scripts and Remediation" section under "Platform Scripts" and should run in the System context and you should disable signature checking since it's not a signed script.

# How to Use
1. Download the PowerShell script
2. Edit the configuration settings in each script (Tenant ID, Policy Name, Description, etc)
3. Run the PowerShell script to import the configuration to Intune
4. In Intune, assign the configuration to users/groups.

# Audits
Audits have been performed at different stages of development of these scripts. Audit 1 refers to the first audit performed where several configurations were still found non-compliant. Audit 2 refers to the second iteration which addressed some of the missing configurations found during Audit 1. Audit 3 , 4 and later represent even further refinements. The last audit should represent the current state of these scripts.

Most configurations marked as "Failed" are documented as "Opposed" with a reason for deviation from CIS recommendations. Items highlighted in yellow are highly recommended to review before deploying.

The audits are performed using Tenable Nessus Compliance Scans. Results from those scans are extracted and put into custom spreadsheet.

# Notes
Some settings recommended by CIS have been "Opposed". The reason for opposing any setting has been documented. Before using in your environment, please consider these deviations and whether they are relevant to your requirements. Options can easily be modified after importing into Intune.
