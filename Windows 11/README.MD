# Windows 11 CIS Microsoft Intune for Windows v3.0.1
These configuraiton templates aim to implement all aspects of the CIS Microsoft Intune for Windows v3.0.1 benchmark including L1 and L2 policies.

# Status
Testing. Currently testing and auditing this configuration.

# Gaps
The following items have been skipped in the main template either because there is no OMAURI or because Microsoft recommended against implementing.
- Skipped: 3.10.9.1.1 (BL) Ensure \u0027Prevent installation of devices that match any of these device IDs\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.10.9.1.2 (BL) Ensure \u0027Prevent installation of devices that match any of these device IDs: Also apply to matching devices that are already installed.\u0027 is set to \u0027True\u0027 (checked) (Automated)
- Skipped: 3.10.9.1.3 (BL) Ensure \u0027Prevent installation of devices that match any of these device IDs: Prevent installation of devices that match any of these device IDs\u0027 is set to \u0027PCI\\CC_0C0A\u0027 (Automated)
- Skipped: 3.10.9.1.4 (BL) Ensure \u0027Prevent installation of devices using drivers that match these device setup classes\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.10.9.1.5 (BL) Ensure \u0027Prevent installation of devices using drivers that match these device setup classes: Also apply to matching devices that are already installed.\u0027 is set to \u0027True\u0027 (checked) (Automated)
- Skipped: 3.10.9.1.6 (BL) Ensure \u0027Prevent installation of devices using drivers that match these device setup classes: Prevent installation of devices using drivers for these device setup\u0027 is set to \u0027IEEE 1394 device setup classes\u0027 (Automated)
- Skipped: 3.11.7.1.1 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.11.7.1.2 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Recovery Key\u0027 is set to \u0027Enabled: Allow 256-bit recovery key\u0027 (Automated)
- Skipped: 3.11.7.1.3 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Recovery Password\u0027 is set to \u0027Enabled: Allow 48-digit recovery password\u0027 (Automated)*/
- Skipped: 3.11.7.1.4 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Allow data recovery agent\u0027 is set to \u0027Enabled: True\u0027 (Automated)
- Skipped: 3.11.7.1.5 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Configure storage of BitLocker recovery information to AD DS\u0027 is set to \u0027Enabled: Backup recovery passwords and key packages\u0027 (Automated)
- Skipped: 3.11.7.1.6 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives\u0027 is set to \u0027Enabled: False\u0027 (Automated)
- Skipped: 3.11.7.1.7 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Omit recovery options from the BitLocker setup wizard\u0027 is set to \u0027Enabled: True\u0027 (Automated)
- Skipped: 3.11.7.1.8 (BL) Ensure \u0027Choose how BitLocker-protected fixed drives can be recovered: Save BitLocker recovery information to AD DS for fixed data drives\u0027 is set to \u0027Enabled: False\u0027 (Automated)

- Skipped: 3.11.7.2.1 (BL) Ensure \u0027Allow enhanced PINs for startup\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.11.7.2.2 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.11.7.2.3 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Recovery Key\u0027 is set to \u0027Enabled: Do not allow 256-bit recovery key\u0027 (Automated)
- Skipped: 3.11.7.2.4 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Recovery Password\u0027 is set to \u0027Enabled: Require 48-digit recovery password\u0027 (Automated)
- Skipped: 3.11.7.2.5 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Allow data recovery agent\u0027 is set to \u0027Enabled: False\u0027 (Automated)
- Skipped: 3.11.7.2.6 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Configure storage of BitLocker recovery information to AD DS:\u0027 is set to \u0027Enabled: Store recovery passwords and key packages\u0027 (Automated)
- Skipped: 3.11.7.2.7 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for operating system drives\u0027 is set to \u0027Enabled: True\u0027 (Automated)
- Skipped: 3.11.7.2.8 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Omit recovery options from the BitLocker setup wizard\u0027 is set to \u0027Enabled: True\u0027 (Automated)
- Skipped: 3.11.7.2.9 (BL) Ensure \u0027Choose how BitLocker-protected operating system drives can be recovered: Save BitLocker recovery information to AD DS for operating system drives\u0027 is set to \u0027Enabled: True\u0027 (Automated)
- Skipped: 3.11.7.2.10 (BL) Ensure \u0027Require additional authentication at startup\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.11.7.2.11 (BL) Ensure \u0027Require additional authentication at startup: Allow BitLocker without a compatible TPM\u0027 is set to \u0027Enabled: False\u0027 (Automated)
- Skipped: 3.11.7.2.12 (BL) Ensure \u0027Require additional authentication at startup: Configure TPM startup key and PIN:\u0027 is set to \u0027Enabled: Do not allow startup key and PIN with TPM\u0027 (Automated)
- Skipped: 3.11.7.2.13 (BL) Ensure \u0027Require additional authentication at startup: Configure TPM startup key:\u0027 is set to \u0027Enabled: Do not allow startup key with TPM\u0027 (Automated)
- Skipped: 3.11.7.2.14 (BL) Ensure \u0027Require additional authentication at startup: Configure TPM startup PIN:\u0027 is set to \u0027Enabled: Require startup PIN with TPM\u0027 (Automated)
- Skipped: 3.11.7.2.15 (BL) Ensure \u0027Require additional authentication at startup: Configure TPM startup:\u0027 is set to \u0027Enabled: Do not allow TPM\u0027 (Automated)

- Skipped: 3.11.7.3.1 (BL) Ensure \u0027Deny write access to removable drives not protected by BitLocker\u0027 is set to \u0027Enabled\u0027 (Automated)
- Skipped: 3.11.7.3.2 (BL) Ensure \u0027Deny write access to removable drives not protected by BitLocker: Do not allow write access to devices configured in another organization\u0027 is set to \u0027Enabled: False\u0027 (Automated)
- Skipped: 3.11.28.11 (L1) Ensure \u0027Turn off Microsoft Defender Antivirus\u0027 is set to \u0027Disabled\u0027 (Automated) - Enabling or disabling this policy may lead to unexpected or unsupported behavior. Changes to this setting are not applied when tamper protection is enabled. It\u0027s recommended that you leave this policy setting unconfigured: https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-microsoftdefenderantivirus#disableantispywaredefender

- Skipped: 3.11.49.1 (L2) Ensure \u0027Prevent Internet Explorer security prompt for Windows Installer scripts\u0027 is set to \u0027Disabled\u0027 (Automated) - IE does not run on Win11

- Skipped: 5.1 (L1) Ensure \u0027Account Logon Audit Credential Validation\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI. 
- Skipped: 5.2 (L1) Ensure \u0027Account Logon Logoff Audit Account Lockout\u0027 is set to include \u0027Failure\u0027 (Automated)  - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.3 (L1) Ensure \u0027Account Logon Logoff Audit Group Membership\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.4 (L1) Ensure \u0027Account Logon Logoff Audit Logoff\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.5 (L1) Ensure \u0027Account Logon Logoff Audit Logon\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.6 (L1) Ensure \u0027Account Management Audit Application Group Management\u0027 is set to \u0027Success and Failure\u0027 (Automated)
- Skipped: 5.7 (L1) Ensure \u0027Audit Authentication Policy Change\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.8 (L1) Ensure \u0027Audit Authorization Policy Change\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.9 (L1) Ensure \u0027Audit Changes to Audit Policy\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.10 (L1) Ensure \u0027Audit File Share Access\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.11 (L1) Ensure \u0027Audit Other Logon Logoff Events\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.12 (L1) Ensure \u0027Audit Security Group Management\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.13 (L1) Ensure \u0027Audit Security System Extension\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.14 (L1) Ensure \u0027Audit Special Logon\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.15 (L1) Ensure \u0027Audit User Account Management\u0027 is set to \u0027Success and Failure\u0027 (Automated - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.16 (L1) Ensure \u0027Detailed Tracking Audit PNP Activity\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.17 (L1) Ensure \u0027Detailed Tracking Audit Process Creation\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.18 (L1) Ensure \u0027Object Access Audit Detailed File Share\u0027 is set to include \u0027Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.19 (L1) Ensure \u0027Object Access Audit Other Object Access Events\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.20 (L1) Ensure \u0027Object Access Audit Removable Storage\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.21 (L1) Ensure \u0027Policy Change Audit MPSSVC Rule Level Policy Change\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.22 (L1) Ensure \u0027Policy Change Audit Other Policy Change Events\u0027 is set to include \u0027Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.23 (L1) Ensure \u0027Privilege Use Audit Sensitive Privilege Use\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.24 (L1) Ensure \u0027System Audit I Psec Driver\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.25 (L1) Ensure \u0027System Audit Other System Events\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.26 (L1) Ensure \u0027System Audit Security State Change\u0027 is set to include \u0027Success\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.
- Skipped: 5.27 (L1) Ensure \u0027System Audit System Integrity\u0027 is set to \u0027Success and Failure\u0027 (Automated) - This needs to be put in another policy that doesn\u0027t use OMAURI.

- Skipped: 21.7 (L1) Ensure \u0027Attack Surface Reduction rules\u0027 are configured (Automated) - Configure this in a separate template outside of OMAURI

- Skipped/Opposed: 69.1 (L2) Ensure \u0027Bluetooth Audio Gateway Service (BTAGService)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/opposed: 69.2 (L2) Ensure \u0027Bluetooth Support Service (bthserv)\u0027 is set to \u0027Disabled\u0027 (Automated)

- Skipped/No OMAURI: 69.4 (L2) Ensure \u0027Downloaded Maps Manager (MapsBroker)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.5 (L2) Ensure \u0027Geolocation Service (lfsvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/Not applicable: 69.6 (L1) Ensure \u0027IIS Admin Service (IISADMIN)\u0027 is set to \u0027Disabled\u0027 or \u0027Not Installed\u0027 (Automated). Not normally installed on an end point and implementing may throw intune error.

- Skipped/No OMAURI: 69.9 (L2) Ensure \u0027Link-Layer Topology Discovery Mapper (lltdsvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.12 (L2) Ensure \u0027Microsoft iSCSI Initiator Service (MSiSCSI)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.13 (L1) Ensure \u0027OpenSSH SSH Server (sshd)\u0027 is set to \u0027Disabled\u0027 or \u0027Not Installed\u0027 (Automated)
- Skipped/No OMAURI: 69.14 (L2) Ensure \u0027Peer Name Resolution Protocol (PNRPsvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.15 (L2) Ensure \u0027Peer Networking Grouping (p2psvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.16 (L2) Ensure \u0027Peer Networking Identity Manager (p2pimsvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.17 (L2) Ensure \u0027PNRP Machine Name Publication Service (PNRPAutoReg)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.18 (L2) Ensure \u0027Print Spooler (Spooler)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.19 (L2) Ensure \u0027Problem Reports and Solutions Control Panel Support (wercplsupport)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.20 (L2) Ensure \u0027Remote Access Auto Connection Manager (RasAuto)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.21 (L2) Ensure \u0027Remote Desktop Configuration (SessionEnv)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.22 (L2) Ensure \u0027Remote Desktop Services (TermService)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.23 (L2) Ensure \u0027Remote Desktop Services UserMode Port Redirector (UmRdpService)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.25 (L2) Ensure \u0027Remote Registry (RemoteRegistry)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.27 (L2) Ensure \u0027Server (LanmanServer)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.29 (L2) Ensure \u0027SNMP Service (SNMP)\u0027 is set to \u0027Disabled\u0027 or \u0027Not Installed\u0027 (Automated)

- Skipped/No OMAURI: 69.34 (L2) Ensure \u0027Windows Error Reporting Service (WerSvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.35 (L2) Ensure \u0027Windows Event Collector (Wecsvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.38 (L2) Ensure \u0027Windows Push Notifications System Service (WpnService)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.39 (L2) Ensure \u0027Windows PushToInstall Service (PushToInstall)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.40 (L2) Ensure \u0027Windows Remote Management (WS-Management) (WinRM)\u0027 is set to \u0027Disabled\u0027 (Automated)

- Skipped/No OMAURI: 69.42 (L1) Ensure \u0027Xbox Accessory Management Service (XboxGipSvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.43 (L1) Ensure \u0027Xbox Live Auth Manager (XblAuthManager)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.44 (L1) Ensure \u0027Xbox Live Game Save (XblGameSave)\u0027 is set to \u0027Disabled\u0027 (Automated)
- Skipped/No OMAURI: 69.45 (L1) Ensure \u0027Xbox Live Networking Service (XboxNetApiSvc)\u0027 is set to \u0027Disabled\u0027 (Automated)
