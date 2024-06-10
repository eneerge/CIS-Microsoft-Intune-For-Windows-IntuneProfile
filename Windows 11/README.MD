# Windows 11 CIS Microsoft Intune for Windows v3.0.1
These configuratuon templates aim to implement all aspects of the CIS Microsoft Intune for Windows v3.0.1 benchmark including L1 and L2 policies.

| Status  | CIS Section | Level | Configuration Description
| :------ | :-----------| :-----| :------------------------|
| Skipped | 3.10.9.1.1 | BL | Ensure 'Prevent installation of devices that match any of these device IDs' is set to 'Enabled' (Automated)
| Skipped | 3.10.9.1.2 | BL | Ensure 'Prevent installation of devices that match any of these device IDs Also apply to matching devices that are already installed.' is set to 'True' (checked) (Automated)
| Skipped | 3.10.9.1.3 | BL | Ensure 'Prevent installation of devices that match any of these device IDs Prevent installation of devices that match any of these device IDs' is set to 'PCI\CC_0C0A' (Automated)
| Skipped | 3.10.9.1.4 | BL | Ensure 'Prevent installation of devices using drivers that match these device setup classes' is set to 'Enabled' (Automated)
| Skipped | 3.10.9.1.5 | BL | Ensure 'Prevent installation of devices using drivers that match these device setup classes Also apply to matching devices that are already installed.' is set to 'True' (checked) (Automated)
| Skipped | 3.10.9.1.6 | BL | Ensure 'Prevent installation of devices using drivers that match these device setup classes Prevent installation of devices using drivers for these device setup' is set to 'IEEE 1394 device setup classes' (Automated)
| Skipped | 3.11.7.1.1 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled' (Automated)
| Skipped | 3.11.7.1.2 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Recovery Key' is set to 'Enabled Allow 256-bit recovery key' (Automated)
| Skipped | 3.11.7.1.3 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Recovery Password' is set to 'Enabled Allow 48-digit recovery password' (Automated)*/
| Skipped | 3.11.7.1.4 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Allow data recovery agent' is set to 'Enabled True' (Automated)
| Skipped | 3.11.7.1.5 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Configure storage of BitLocker recovery information to AD DS' is set to 'Enabled Backup recovery passwords and key packages' (Automated)
| Skipped | 3.11.7.1.6 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives' is set to 'Enabled False' (Automated)
| Skipped | 3.11.7.1.7 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Omit recovery options from the BitLocker setup wizard' is set to 'Enabled True' (Automated)
| Skipped | 3.11.7.1.8 | BL | Ensure 'Choose how BitLocker-protected fixed drives can be recovered Save BitLocker recovery information to AD DS for fixed data drives' is set to 'Enabled False' (Automated)
| Skipped | 3.11.7.2.1 | BL | Ensure 'Allow enhanced PINs for startup' is set to 'Enabled' (Automated)
| Skipped | 3.11.7.2.2 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered' is set to 'Enabled' (Automated)
| Skipped | 3.11.7.2.3 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Recovery Key' is set to 'Enabled Do not allow 256-bit recovery key' (Automated)
| Skipped | 3.11.7.2.4 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Recovery Password' is set to 'Enabled Require 48-digit recovery password' (Automated)
| Skipped | 3.11.7.2.5 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Allow data recovery agent' is set to 'Enabled False' (Automated)
| Skipped | 3.11.7.2.6 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Configure storage of BitLocker recovery information to AD DS' is set to 'Enabled Store recovery passwords and key packages' (Automated)
| Skipped | 3.11.7.2.7 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Do not enable BitLocker until recovery information is stored to AD DS for operating system drives' is set to 'Enabled True' (Automated)
| Skipped | 3.11.7.2.8 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Omit recovery options from the BitLocker setup wizard' is set to 'Enabled True' (Automated)
| Skipped | 3.11.7.2.9 | BL | Ensure 'Choose how BitLocker-protected operating system drives can be recovered Save BitLocker recovery information to AD DS for operating system drives' is set to 'Enabled True' (Automated)
| Skipped | 3.11.7.2.10 | BL | Ensure 'Require additional authentication at startup' is set to 'Enabled' (Automated)
| Skipped | 3.11.7.2.11 | BL | Ensure 'Require additional authentication at startup Allow BitLocker without a compatible TPM' is set to 'Enabled False' (Automated)
| Skipped | 3.11.7.2.12 | BL | Ensure 'Require additional authentication at startup Configure TPM startup key and PIN' is set to 'Enabled Do not allow startup key and PIN with TPM' (Automated)
| Skipped | 3.11.7.2.13 | BL | Ensure 'Require additional authentication at startup Configure TPM startup key' is set to 'Enabled Do not allow startup key with TPM' (Automated)
| Skipped | 3.11.7.2.14 | BL | Ensure 'Require additional authentication at startup Configure TPM startup PIN' is set to 'Enabled Require startup PIN with TPM' (Automated)
| Skipped | 3.11.7.2.15 | BL | Ensure 'Require additional authentication at startup Configure TPM startup' is set to 'Enabled Do not allow TPM' (Automated)
| Skipped | 3.11.7.3.1 | BL | Ensure 'Deny write access to removable drives not protected by BitLocker' is set to 'Enabled' (Automated)
| Skipped | 3.11.7.3.2 | BL | Ensure 'Deny write access to removable drives not protected by BitLocker Do not allow write access to devices configured in another organization' is set to 'Enabled False' (Automated)
| Skipped | 3.11.28.11 | L1 | Ensure 'Turn off Microsoft Defender Antivirus' is set to 'Disabled' (Automated) - Enabling or disabling this policy may lead to unexpected or unsupported behavior. Changes to this setting are not applied when tamper protection is enabled. It's recommended that you leave this policy setting unconfigured https//learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-microsoftdefenderantivirus#disableantispywaredefender
| Skipped | 3.11.49.1 | L2 | Ensure 'Prevent Internet Explorer security prompt for Windows Installer scripts' is set to 'Disabled' (Automated) - IE does not run on Win11
| Skipped | 5.1 | L1 | Ensure 'Account Logon Audit Credential Validation' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI. 
| Skipped | 5.2 | L1 | Ensure 'Account Logon Logoff Audit Account Lockout' is set to include 'Failure' (Automated)  - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.3 | L1 | Ensure 'Account Logon Logoff Audit Group Membership' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.4 | L1 | Ensure 'Account Logon Logoff Audit Logoff' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.5 | L1 | Ensure 'Account Logon Logoff Audit Logon' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.6 | L1 | Ensure 'Account Management Audit Application Group Management' is set to 'Success and Failure' (Automated)
| Skipped | 5.7 | L1 | Ensure 'Audit Authentication Policy Change' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.8 | L1 | Ensure 'Audit Authorization Policy Change' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.9 | L1 | Ensure 'Audit Changes to Audit Policy' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.10 | L1 | Ensure 'Audit File Share Access' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.11 | L1 | Ensure 'Audit Other Logon Logoff Events' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.12 | L1 | Ensure 'Audit Security Group Management' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.13 | L1 | Ensure 'Audit Security System Extension' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.14 | L1 | Ensure 'Audit Special Logon' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.15 | L1 | Ensure 'Audit User Account Management' is set to 'Success and Failure' (Automated - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.16 | L1 | Ensure 'Detailed Tracking Audit PNP Activity' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.17 | L1 | Ensure 'Detailed Tracking Audit Process Creation' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.18 | L1 | Ensure 'Object Access Audit Detailed File Share' is set to include 'Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.19 | L1 | Ensure 'Object Access Audit Other Object Access Events' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.20 | L1 | Ensure 'Object Access Audit Removable Storage' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.21 | L1 | Ensure 'Policy Change Audit MPSSVC Rule Level Policy Change' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.22 | L1 | Ensure 'Policy Change Audit Other Policy Change Events' is set to include 'Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.23 | L1 | Ensure 'Privilege Use Audit Sensitive Privilege Use' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.24 | L1 | Ensure 'System Audit I Psec Driver' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.25 | L1 | Ensure 'System Audit Other System Events' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.26 | L1 | Ensure 'System Audit Security State Change' is set to include 'Success' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 5.27 | L1 | Ensure 'System Audit System Integrity' is set to 'Success and Failure' (Automated) - This needs to be put in another policy that doesn't use OMAURI.
| Skipped | 21.7 | L1 | Ensure 'Attack Surface Reduction rules' are configured (Automated) - Configure this in a separate template outside of OMAURI
| Skipped/Opposed | 69.1 | L2 | Ensure 'Bluetooth Audio Gateway Service (BTAGService)' is set to 'Disabled' (Automated)
| Skipped/opposed | 69.2 | L2 | Ensure 'Bluetooth Support Service (bthserv)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.4 | L2 | Ensure 'Downloaded Maps Manager (MapsBroker)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.5 | L2 | Ensure 'Geolocation Service (lfsvc)' is set to 'Disabled' (Automated)
| Skipped/Not applicable | 69.6 | L1 | Ensure 'IIS Admin Service (IISADMIN)' is set to 'Disabled' or 'Not Installed' (Automated). Not normally installed on an end point and implementing may throw intune error.
| Skipped/No OMAURI | 69.9 | L2 | Ensure 'Link-Layer Topology Discovery Mapper (lltdsvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.12 | L2 | Ensure 'Microsoft iSCSI Initiator Service (MSiSCSI)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.13 | L1 | Ensure 'OpenSSH SSH Server (sshd)' is set to 'Disabled' or 'Not Installed' (Automated)
| Skipped/No OMAURI | 69.14 | L2 | Ensure 'Peer Name Resolution Protocol (PNRPsvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.15 | L2 | Ensure 'Peer Networking Grouping (p2psvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.16 | L2 | Ensure 'Peer Networking Identity Manager (p2pimsvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.17 | L2 | Ensure 'PNRP Machine Name Publication Service (PNRPAutoReg)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.18 | L2 | Ensure 'Print Spooler (Spooler)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.19 | L2 | Ensure 'Problem Reports and Solutions Control Panel Support (wercplsupport)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.20 | L2 | Ensure 'Remote Access Auto Connection Manager (RasAuto)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.21 | L2 | Ensure 'Remote Desktop Configuration (SessionEnv)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.22 | L2 | Ensure 'Remote Desktop Services (TermService)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.23 | L2 | Ensure 'Remote Desktop Services UserMode Port Redirector (UmRdpService)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.25 | L2 | Ensure 'Remote Registry (RemoteRegistry)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.27 | L2 | Ensure 'Server (LanmanServer)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.29 | L2 | Ensure 'SNMP Service (SNMP)' is set to 'Disabled' or 'Not Installed' (Automated)
| Skipped/No OMAURI | 69.34 | L2 | Ensure 'Windows Error Reporting Service (WerSvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.35 | L2 | Ensure 'Windows Event Collector (Wecsvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.38 | L2 | Ensure 'Windows Push Notifications System Service (WpnService)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.39 | L2 | Ensure 'Windows PushToInstall Service (PushToInstall)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.40 | L2 | Ensure 'Windows Remote Management (WS-Management) (WinRM)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.42 | L1 | Ensure 'Xbox Accessory Management Service (XboxGipSvc)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.43 | L1 | Ensure 'Xbox Live Auth Manager (XblAuthManager)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.44 | L1 | Ensure 'Xbox Live Game Save (XblGameSave)' is set to 'Disabled' (Automated)
| Skipped/No OMAURI | 69.45 | L1 | Ensure 'Xbox Live Networking Service (XboxNetApiSvc)' is set to 'Disabled' (Automated)
