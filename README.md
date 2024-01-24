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

# Known Issues / Troubleshooting
To verify a configuration applied:
- Open Event Viewer
- Open the log "Application and Services Logs"\Microsoft\Windows\DeviceManagement-Enterprise-Diagnostics-Provider\Admin
- Review any entries with "Error"
  - Ignore event id 2545 (checkNewInstanceData) - this appears to be an Intune bug. See https://answers.microsoft.com/en-us/windows/forum/all/event-2545-microsoft-windows-devicemanagement/a7e0f8e9-685f-44d8-be69-58fd1f8a716e. As of 2024.01.23, I am no longer seeing this in my deployment.
  - Ignore error referencing "./Device/Vendor/MSFT/Policy/ConfigOpoerations/ADMXInstall/Receiver/Properties/Policy/FakePolicy/Version. This is an expected error the informs you that Intune is working properly. See: https://www.reddit.com/r/Intune/comments/n8u51x/intune_fakepolicy_not_found_error/

- Intune remediation failures for User Rights Assignment policies that apply a blank value. (2.2.1 through 2.2.30)
  - May report the error "0x87D1FDE8" (Remediation Failure). Despite this error, the blank policies are applied properly.
  - This appears to be an issue with intune reporting. See the "cause" mentioned here: https://learn.microsoft.com/en-us/troubleshoot/mem/intune/device-configuration/device-configuration-profile-reports-error-2016281112
  - Because blanks are specified using <!CDATA[]]>, Intune expects to receive this value in the response. However, only "blank" is sent back to Intune, resulting in this "error" even though the policy was applied successfully.
  - These blank policies can be refactored into a new policy (Endpoint protection/User Rights) that does not use OMA-URI to prevent this reporting error.

# Audit
Here is the results of an audit of a workstation after running Hardening Kitty Audit (https://github.com/scipag/HardeningKitty) against the **Windows 10 Enterprise benchmark**. 

NOTE: The Windows 10 Enterprise benchmark audit below contains some settings that are not included in the Intune benchmark. The CIS sections below will not map 1-to-1 with the Intune benchmark. If anyone has a public domain tool that will audit against the Intune benchmark, feel free to recommend it. For the most part, the Enterprise benchmark contains more security settings than the Intune benchmark. Auditing against it should provide good coverage of the Intune benchmark.

| CIS Section | CIS Description | Result | Notes |
| :---------- | :-------------- | :----- | :---- |
| 1.1.1 | Length of password history maintained | Passed | Result=None,Recommended=24. The registry value documented by CIS is set successfully. HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\Providers\{GUID}\Default\Device\DeviceLock:DevicePasswordHistory is set to 24. (https://workbench.cisecurity.org/sections/2101248/recommendations/3353873)
| 1.1.2 | Maximum password age | Passed | Result=42,Recommended=365
| 1.1.3 | Minimum password age | Passed | Result=1,Recommended=1
| 1.1.4 | Minimum password length | Medium | Result=0,Recommended=14
| 1.1.5 | Password must meet complexity requirements | Medium | Result=0,Recommended=1
| 1.1.6 | Relax minimum password length limits | Medium | Result=0,Recommended=1
| 1.1.7 | Store passwords using reversible encryption | Passed | Result=0,Recommended=0
| 1.2.1 | Account lockout duration | Passed | Result=10,Recommended=15. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101247)
| 1.2.2 | Account lockout threshold | Passed | Result=10,Recommended=5. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101247)
| 1.2.3 | Allow Administrator account lockout | Passed | Result=1,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101247)
| 1.2.4 | Reset account lockout counter | Passed | Result=10,Recommended=15. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101247)
| 2.2.1 | Access Credential Manager as a trusted caller | Passed | Result=,Recommended=
| 2.2.2 | Access this computer from the network | Passed | Result=BUILTIN\Administrators;BUILTIN\Remote Desktop Users,Recommended=BUILTIN\Remote Desktop Users;BUILTIN\Administrators
| 2.2.3 | Act as part of the operating system | Passed | Result=,Recommended=
| 2.2.4 | Adjust memory quotas for a process | Passed | Result=NT AUTHORITY\LOCAL SERVICE;NT AUTHORITY\NETWORK SERVICE;BUILTIN\Administrators,Recommended=BUILTIN\Administrators;NT AUTHORITY\NETWORK SERVICE;NT AUTHORITY\LOCAL SERVICE
| 2.2.5 | Allow log on locally | Passed | Result=BUILTIN\Administrators;BUILTIN\Users,Recommended=BUILTIN\Users;BUILTIN\Administrators
| 2.2.6 | Allow log on through Remote Desktop Services | Passed | Result=BUILTIN\Administrators;BUILTIN\Remote Desktop Users,Recommended=BUILTIN\Remote Desktop Users;BUILTIN\Administrators
| 2.2.7 | Back up files and directories | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.8 | Change the system time | Passed | Result=NT AUTHORITY\LOCAL SERVICE;BUILTIN\Administrators,Recommended=BUILTIN\Administrators;NT AUTHORITY\LOCAL SERVICE
| 2.2.9 | Change the time zone | Passed | Result=NT AUTHORITY\LOCAL SERVICE;BUILTIN\Administrators;BUILTIN\Users,Recommended=BUILTIN\Users;BUILTIN\Administrators;NT AUTHORITY\LOCAL SERVICE
| 2.2.10 | Create a pagefile | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.11 | Create a token object | Passed | Result=,Recommended=
| 2.2.12 | Create global objects | Passed | Result=NT AUTHORITY\LOCAL SERVICE;NT AUTHORITY\NETWORK SERVICE;BUILTIN\Administrators;NT AUTHORITY\SERVICE,Recommended=NT AUTHORITY\SERVICE;BUILTIN\Administrators;NT AUTHORITY\NETWORK SERVICE;NT AUTHORITY\LOCAL SERVICE
| 2.2.13 | Create permanent shared objects | Passed | Result=,Recommended=
| 2.2.14.1 | Create symbolic links | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.14.2 | Create symbolic links (Hyper-V) | Medium | Result=BUILTIN\Administrators,Recommended=NT VIRTUAL MACHINE\Virtual Machines;BUILTIN\Administrators
| 2.2.15 | Debug programs | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.16 | Deny access to this computer from the network | Passed | Result=NT AUTHORITY\Local account;BUILTIN\Guests,Recommended=BUILTIN\Guests;NT AUTHORITY\Local account
| 2.2.17 | Deny log on as a batch job | Medium | Result=,Recommended=BUILTIN\Guests
| 2.2.18 | Deny log on as a service | Medium | Result=,Recommended=BUILTIN\Guests
| 2.2.19 | Deny log on locally | Passed | Result=BUILTIN\Guests,Recommended=BUILTIN\Guests
| 2.2.20 | Deny log on through Remote Desktop Services | Passed | Result=NT AUTHORITY\Local account;BUILTIN\Guests,Recommended=BUILTIN\Guests;NT AUTHORITY\Local account
| 2.2.21 | Enable computer and user accounts to be trusted for delegation | Passed | Result=,Recommended=
| 2.2.22 | Force shutdown from a remote system | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.23 | Generate security audits | Passed | Result=NT AUTHORITY\LOCAL SERVICE;NT AUTHORITY\NETWORK SERVICE,Recommended=NT AUTHORITY\NETWORK SERVICE;NT AUTHORITY\LOCAL SERVICE
| 2.2.24 | Impersonate a client after authentication | Passed | Result=NT AUTHORITY\LOCAL SERVICE;NT AUTHORITY\NETWORK SERVICE;BUILTIN\Administrators;NT AUTHORITY\SERVICE,Recommended=NT AUTHORITY\SERVICE;BUILTIN\Administrators;NT AUTHORITY\NETWORK SERVICE;NT AUTHORITY\LOCAL SERVICE
| 2.2.25 | Increase scheduling priority | Passed | Result=BUILTIN\Administrators;Window Manager\Window Manager Group,Recommended=Window Manager\Window Manager Group;BUILTIN\Administrators
| 2.2.26 | Load and unload device drivers | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.27 | Lock pages in memory | Passed | Result=,Recommended=
| 2.2.28 | Log on as a batch job | Medium | Result=BUILTIN\Administrators;BUILTIN\Backup Operators;BUILTIN\Performance Log Users,Recommended=BUILTIN\Administrators
| 2.2.29.1 | Log on as a service | Medium | Result=NT SERVICE\ALL SERVICES,Recommended=
| 2.2.29.2 | Log on as a service (Hyper-V) | Medium | Result=NT SERVICE\ALL SERVICES,Recommended=NT VIRTUAL MACHINE\Virtual Machines
| 2.2.30 | Manage auditing and security log | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.31 | Modify an object label | Passed | Result=,Recommended=
| 2.2.32 | Modify firmware environment values | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.33 | Perform volume maintenance tasks | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.34 | Profile single process | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.35 | Profile system performance | Passed | Result=BUILTIN\Administrators;NT SERVICE\WdiServiceHost,Recommended=NT SERVICE\WdiServiceHost;BUILTIN\Administrators
| 2.2.36 | Replace a process level token | Passed | Result=NT AUTHORITY\LOCAL SERVICE;NT AUTHORITY\NETWORK SERVICE,Recommended=NT AUTHORITY\NETWORK SERVICE;NT AUTHORITY\LOCAL SERVICE
| 2.2.37 | Restore files and directories | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.2.38 | Shut down the system | Medium | Result=BUILTIN\Administrators;BUILTIN\Users;BUILTIN\Backup Operators,Recommended=BUILTIN\Users;BUILTIN\Administrators
| 2.2.39 | Take ownership of files or other objects | Passed | Result=BUILTIN\Administrators,Recommended=BUILTIN\Administrators
| 2.3.1.1 | Accounts: Block Microsoft accounts | Passed | Result=3,Recommended=3
| 2.3.1.2 | Accounts: Guest account status | Passed | Result=False,Recommended=False
| 2.3.1.3 | Accounts: Limit local account use of blank passwords to console logon only | Passed | Result=1,Recommended=1
| 2.3.1.4 | Accounts: Rename administrator account | Passed | Result=badmin,Recommended=Administrator
| 2.3.1.5 | Accounts: Rename guest account | Passed | Result=noguest,Recommended=Guest
| 2.3.2.1 | Audit: Force audit policy subcategory settings to override audit policy category settings | Passed | Result=1,Recommended=1
| 2.3.2.2 | Audit: Shut down system immediately if unable to log security audits | Passed | Result=0,Recommended=0
| 2.3.4.1 | Devices: Allowed to format and eject removable media | Passed | Result=2,Recommended=2
| 2.3.4.2 | Devices: Prevent users from installing printer drivers | Passed | Result=1,Recommended=1
| 2.3.6.1 | Domain member: Digitally encrypt or sign secure channel data (always) | Passed | Result=1,Recommended=1
| 2.3.6.2 | Domain member: Digitally encrypt secure channel data (when possible) | Passed | Result=1,Recommended=1
| 2.3.6.3 | Domain member: Digitally sign secure channel data (when possible) | Passed | Result=1,Recommended=1
| 2.3.6.4 | Domain member: Disable machine account password changes | Passed | Result=0,Recommended=0
| 2.3.6.5 | Domain member: Maximum machine account password age | Passed | Result=30,Recommended=30
| 2.3.6.6 | Domain member: Require strong (Windows 2000 or later) session key | Passed | Result=1,Recommended=1
| 2.3.7.1 | Interactive logon: Do not require CTRL+ALT+DEL | Low | Result=1,Recommended=0. Opposed: I will not require users to ctrl+alt+del before logging in. Outdated concept in my opinion.
| 2.3.7.2 | Interactive logon: Don't display last signed-in | Low | Result=0,Recommended=1. Opposed: I don't want users to enter username every login.
| 2.3.7.3 | Interactive logon: Machine account lockout threshold | Passed | Result=10,Recommended=10
| 2.3.7.4 | Interactive logon: Machine inactivity limit | Passed | Result=900,Recommended=900
| 2.3.7.5 | Interactive logon: Message text for users attempting to log on | Low | Result=,Recommended=Not. Opposed. No message has been set.
| 2.3.7.6 | Interactive logon: Message title for users attempting to log on | Low | Result=,Recommended=Not. Opposed. No message title has been set.
| 2.3.7.7 | Interactive logon: Number of previous logons to cache (in case domain controller is not available) | Medium | Result=10,Recommended=4
| 2.3.7.8.1 | Interactive logon: Prompt user to change password before expiration (Max) | Passed | Result=5,Recommended=14
| 2.3.7.8.2 | Interactive logon: Prompt user to change password before expiration (Min) | Passed | Result=5,Recommended=5
| 2.3.7.9 | Interactive logon: Smart card removal behavior | Low | Result=3,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101350)
| 2.3.8.1 | Microsoft network client: Digitally sign communications (always) | Passed | Result=1,Recommended=1
| 2.3.8.2 | Microsoft network client: Digitally sign communications (if server agrees) | Passed | Result=1,Recommended=1
| 2.3.8.3 | Microsoft network client: Send unencrypted password to third-party SMB servers | Passed | Result=0,Recommended=0
| 2.3.9.1 | Microsoft network server: Amount of idle time required before suspending session | Passed | Result=15,Recommended=15
| 2.3.9.2 | Microsoft network server: Digitally sign communications (always) | Passed | Result=1,Recommended=1
| 2.3.9.3 | Microsoft network server: Digitally sign communications (if client agrees) | Passed | Result=1,Recommended=1
| 2.3.9.4 | Microsoft network server: Disconnect clients when logon hours expire | Passed | Result=1,Recommended=1
| 2.3.9.5 | Microsoft network server: Server SPN target name validation level | Medium | Result=,Recommended=1
| 2.3.10.1 | Network access: Allow anonymous SID/Name translation | Passed | Result=0,Recommended=0
| 2.3.10.2 | Network access: Do not allow anonymous enumeration of SAM accounts | Passed | Result=1,Recommended=1
| 2.3.10.3 | Network access: Do not allow anonymous enumeration of SAM accounts and shares | Passed | Result=1,Recommended=1
| 2.3.10.4 | Network access: Do not allow storage of passwords and credentials for network authentication | Medium | Result=0,Recommended=1
| 2.3.10.5 | Network access: Let Everyone permissions apply to anonymous users | Passed | Result=0,Recommended=0
| 2.3.10.6 | Network access: Named Pipes that can be accessed anonymously | Passed | Result=,Recommended=
| 2.3.10.7 | Network access: Remotely accessible registry paths | Passed | Result=System\CurrentControlSet\Control\ProductOptions;System\CurrentControlSet\Control\Server Applications;Software\Microsoft\Windows NT\CurrentVersion,Recommended=System\CurrentControlSet\Control\ProductOptions;System\CurrentControlSet\Control\Server Applications;Software\Microsoft\Windows NT\CurrentVersion
| 2.3.10.8 | Network access: Remotely accessible registry paths and sub-paths | Passed | Result=System\CurrentControlSet\Control\Print\Printers;System\CurrentControlSet\Services\Eventlog;Software\Microsoft\OLAP Server;Software\Microsoft\Windows NT\CurrentVersion\Print;Software\Microsoft\Windows NT\CurrentVersion\Windows;System\CurrentControlSet\Control\ContentIndex;System\CurrentControlSet\Control\Terminal Server;System\CurrentControlSet\Control\Terminal Server\UserConfig;System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration;Software\Microsoft\Windows NT\CurrentVersion\Perflib;System\CurrentControlSet\Services\SysmonLog,Recommended=System\CurrentControlSet\Control\Print\Printers;System\CurrentControlSet\Services\Eventlog;Software\Microsoft\OLAP Server;Software\Microsoft\Windows NT\CurrentVersion\Print;Software\Microsoft\Windows NT\CurrentVersion\Windows;System\CurrentControlSet\Control\ContentIndex;System\CurrentControlSet\Control\Terminal Server;System\CurrentControlSet\Control\Terminal Server\UserConfig;System\CurrentControlSet\Control\Terminal Server\DefaultUserConfiguration;Software\Microsoft\Windows NT\CurrentVersion\Perflib;System\CurrentControlSet\Services\SysmonLog
| 2.3.10.9 | Network access: Restrict anonymous access to Named Pipes and Shares | Passed | Result=1,Recommended=1
| 2.3.10.10 | Network access: Restrict clients allowed to make remote calls to SAM, Result=O:BAG:BAD:(A;;RC;;;BA), Recommended=O:BAG:BAD:(A;;RC;;;BA), Severity=Passed
| 2.3.10.11 | Network access: Shares that can be accessed anonymously | Passed | Result=,Recommended=
| 2.3.10.12 | Network access: Sharing and security model for local accounts | Passed | Result=0,Recommended=0
| 2.3.11.1 | Network security: Allow Local System to use computer identity for NTLM | Passed | Result=1,Recommended=1
| 2.3.11.2 | Network security: Allow LocalSystem NULL session fallback | Passed | Result=0,Recommended=0
| 2.3.11.3 | Network security: Allow PKU2U authentication requests to this computer to use online identities | Passed | Result=0,Recommended=0
| 2.3.11.4 | Network security: Configure encryption types allowed for Kerberos | Medium | Result=2147483644,Recommended=2147483640
| 2.3.11.5 | Network security: Do not store LAN Manager hash value on next password change | Passed | Result=1,Recommended=1
| 2.3.11.6 | Network security: Force logoff when logon hours expires | Passed | Result=0,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101374)
| 2.3.11.7 | Network security: LAN Manager authentication level | Passed | Result=5,Recommended=5
| 2.3.11.8 | Network security: LDAP client signing requirements | Passed | Result=1,Recommended=1
| 2.3.11.9 | Network security: Minimum session security for NTLM SSP based (including secure RPC) clients | Passed | Result=537395200,Recommended=537395200
| 2.3.11.10 | Network security: Minimum session security for NTLM SSP based (including secure RPC) servers | Medium | Result=536870912,Recommended=537395200
| 2.3.14.1 | System cryptography: Force strong key protection for user keys stored on the computer | Medium | Result=,Recommended=1
| 2.3.15.1 | System objects: Require case insensitivity for non-Windows subsystem | Passed | Result=1,Recommended=1
| 2.3.15.2 | System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links) | Passed | Result=1,Recommended=1
| 2.3.17.1 | User Account Control: Admin Approval Mode for the Built-in Administrator account | Passed | Result=1,Recommended=1
| 2.3.17.2 | User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode | Passed | Result=2,Recommended=2
| 2.3.17.3 | User Account Control: Behavior of the elevation prompt for standard users | Medium | Result=1,Recommended=0
| 2.3.17.4 | User Account Control: Detect application installations and prompt for elevation | Passed | Result=1,Recommended=1
| 2.3.17.5 | User Account Control: Only elevate UIAccess applications that are installed in secure locations | Passed | Result=1,Recommended=1
| 2.3.17.6 | User Account Control: Run all administrators in Admin Approval Mode | Passed | Result=1,Recommended=1
| 2.3.17.7 | User Account Control: Switch to the secure desktop when prompting for elevation | Passed | Result=1,Recommended=1
| 2.3.17.8 | User Account Control: Virtualize file and registry write failures to per-user locations | Passed | Result=1,Recommended=1
| 5.1.1 | Bluetooth Audio Gateway Service (BTAGService) | Medium | Result=3,Recommended=4
| 5.1.2 | Bluetooth Audio Gateway Service (BTAGService) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.2.1 | Bluetooth Support Service (bthserv) | Medium | Result=3,Recommended=4
| 5.2.2 | Bluetooth Support Service (bthserv) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.3.1 | Computer Browser (Browser) | Passed | Result=,Recommended=4
| 5.3.2 | Computer Browser (Browser) (Service Startup type) (!Check for false positive for service "bowser"!) | Medium | Result=Manual,Recommended=Disabled
| 5.4.1 | Downloaded Maps Manager (MapsBroker) | Medium | Result=2,Recommended=4
| 5.4.2 | Downloaded Maps Manager (MapsBroker) (Service Startup type) | Medium | Result=Automatic,Recommended=Disabled
| 5.5.1 | Geolocation Service (lfsvc) | Medium | Result=3,Recommended=4
| 5.5.2 | Geolocation Service (lfsvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.6.1 | IIS Admin Service (IISADMIN) | Passed | Result=,Recommended=4
| 5.6.2 | IIS Admin Service (IISADMIN) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.7.1 | Infrared monitor service (irmon) | Medium | Result=,Recommended=4
| 5.7.2 | Infrared monitor service (irmon) (Service Startup type) | Medium | Result=,Recommended=Disabled
| 5.8.1 | Internet Connection Sharing (ICS) (SharedAccess) | Medium | Result=3,Recommended=4
| 5.8.2 | Internet Connection Sharing (ICS) (SharedAccess) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.9.1 | Link-Layer Topology Discovery Mapper (lltdsvc) | Medium | Result=3,Recommended=4
| 5.9.2 | Link-Layer Topology Discovery Mapper (lltdsvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.10.1 | LxssManager (LxssManager) | Passed | Result=,Recommended=4
| 5.10.2 | LxssManager (LxssManager) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.11.1 | Microsoft FTP Service (FTPSVC) | Passed | Result=,Recommended=4
| 5.11.2 | Microsoft FTP Service (FTPSVC) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.12.1 | Microsoft iSCSI Initiator Service (MSiSCSI) | Medium | Result=3,Recommended=4
| 5.12.2 | Microsoft iSCSI Initiator Service (MsiSCSI) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.13.1 | OpenSSH SSH Server (sshd) | Passed | Result=,Recommended=4
| 5.13.2 | OpenSSH SSH Server (sshd) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.14.1 | Peer Name Resolution Protocol (PNRPsvc) | Medium | Result=3,Recommended=4
| 5.14.2 | Peer Name Resolution Protocol (PNRPsvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.15.1 | Peer Networking Grouping (p2psvc) | Medium | Result=3,Recommended=4
| 5.15.2 | Peer Networking Grouping (p2psvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.16.1 | Peer Networking Identity Manager (p2pimsvc) | Medium | Result=3,Recommended=4
| 5.16.2 | Peer Networking Identity Manager (p2pimsvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.17.1 | PNRP Machine Name Publication Service (PNRPAutoReg) | Medium | Result=3,Recommended=4
| 5.17.2 | PNRP Machine Name Publication Service (PNRPAutoReg) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.18.1 | Print Spooler (Spooler) | Medium | Result=2,Recommended=4
| 5.18.2 | Print Spooler (Spooler) (Service Startup type) | Medium | Result=Automatic,Recommended=Disabled
| 5.19.1 | Problem Reports and Solutions Control Panel Support (wercplsupport) | Medium | Result=3,Recommended=4
| 5.19.2 | Problem Reports and Solutions Control Panel Support (wercplsupport) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.20.1 | Remote Access Auto Connection Manager (RasAuto) | Medium | Result=3,Recommended=4
| 5.20.2 | Remote Access Auto Connection Manager (RasAuto) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.21.1 | Remote Desktop Configuration (SessionEnv) | Medium | Result=3,Recommended=4
| 5.21.2 | Remote Desktop Configuration (SessionEnv) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.22.1 | Remote Desktop Services (TermService) | Medium | Result=3,Recommended=4
| 5.22.2 | Remote Desktop Services (TermService) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.23.1 | Remote Desktop Services UserMode Port Redirector (UmRdpService) | Medium | Result=3,Recommended=4
| 5.23.2 | Remote Desktop Services UserMode Port Redirector (UmRdpService) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.24.1 | Remote Procedure Call (RPC) Locator (RpcLocator) | Medium | Result=3,Recommended=4
| 5.24.2 | Remote Procedure Call (RPC) Locator (RpcLocator) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.25.1 | Remote Registry (RemoteRegistry) | Passed | Result=4,Recommended=4
| 5.25.2 | Remote Registry (RemoteRegistry) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.26.1 | Routing and Remote Access (RemoteAccess) | Passed | Result=4,Recommended=4
| 5.26.2 | Routing and Remote Access (RemoteAccess) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.27.1 | Server (LanmanServer) | Medium | Result=2,Recommended=4
| 5.27.2 | Server (LanmanServer) (Service Startup type) | Medium | Result=Automatic,Recommended=Disabled
| 5.28.1 | Simple TCP/IP Services (simptcp) | Passed | Result=,Recommended=4
| 5.28.2 | Simple TCP/IP Services (simptcp) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.29.1 | SNMP Service (SNMP) | Passed | Result=,Recommended=4
| 5.29.2 | SNMP Service (SNMP) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.30.1 | Special Administration Console Helper (sacsvr) | Medium | Result=,Recommended=4
| 5.30.2 | Special Administration Console Helper (sacsvr) (Service Startup type) | Medium | Result=,Recommended=Disabled
| 5.31.1 | SSDP Discovery (SSDPSRV) | Passed | Result=4,Recommended=4
| 5.31.2 | SSDP Discovery (SSDPSRV) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.32.1 | UPnP Device Host (upnphost) | Medium | Result=3,Recommended=4
| 5.32.2 | UPnP Device Host (upnphost) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.33.1 | Web Management Service (WMSvc) | Passed | Result=,Recommended=4
| 5.33.2 | Web Management Service (WMSvc) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.34.1 | Windows Error Reporting Service (WerSvc) | Medium | Result=3,Recommended=4
| 5.34.2 | Windows Error Reporting Service (WerSvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.35.1 | Windows Event Collector (Wecsvc) | Medium | Result=3,Recommended=4
| 5.35.2 | Windows Event Collector (Wecsvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.36.1 | Windows Media Player Network Sharing Service (WMPNetworkSvc) | Medium | Result=3,Recommended=4
| 5.36.2 | Windows Media Player Network Sharing Service (WMPNetworkSvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.37.1 | Windows Mobile Hotspot Service (icssvc) | Medium | Result=3,Recommended=4
| 5.37.2 | Windows Mobile Hotspot Service (icssvc) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.38.1 | Windows Push Notifications System Service (WpnService) | Medium | Result=2,Recommended=4
| 5.38.2 | Windows Push Notifications System Service (WpnService) (Service Startup type) | Medium | Result=Automatic,Recommended=Disabled
| 5.39.1 | Windows PushToInstall Service (PushToInstall) | Medium | Result=3,Recommended=4
| 5.39.2 | Windows PushToInstall Service (PushToInstall) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.40.1 | Windows Remote Management (WS-Management) (WinRM) | Medium | Result=3,Recommended=4
| 5.40.2 | Windows Remote Management (WS-Management) (WinRM) (Service Startup type) | Medium | Result=Manual,Recommended=Disabled
| 5.41.1 | World Wide Web Publishing Service (W3SVC) | Passed | Result=,Recommended=4
| 5.41.2 | World Wide Web Publishing Service (W3SVC) (Service Startup type) | Passed | Result=,Recommended=Disabled
| 5.42.1 | Xbox Accessory Management Service (XboxGipSvc) | Passed | Result=4,Recommended=4
| 5.42.2 | Xbox Accessory Management Service (XboxGipSvc) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.43.1 | Xbox Live Auth Manager (XblAuthManager) | Passed | Result=4,Recommended=4
| 5.43.2 | Xbox Live Auth Manager (XblAuthManager) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.44.1 | Xbox Live Game Save (XblGameSave) | Passed | Result=4,Recommended=4
| 5.44.2 | Xbox Live Game Save (XblGameSave) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 5.45.1 | Xbox Live Networking Service (XboxNetApiSvc) | Passed | Result=4,Recommended=4
| 5.45.2 | Xbox Live Networking Service (XboxNetApiSvc) (Service Startup type) | Passed | Result=Disabled,Recommended=Disabled
| 9.1.1 | EnableFirewall (Domain Profile, Policy) | Medium | Result=0,Recommended=1
| 9.1.2 | Inbound Connections (Domain Profile, Policy) | Passed | Result=1,Recommended=1
| 9.1.3 | Outbound Connections (Domain Profile, Policy) | Passed | Result=0,Recommended=0
| 9.1.4 | Display a notification (Domain Profile, Policy) | Passed | Result=0,Recommended=1. The registry value documented by CIS is set successfully. HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\DomainProfile:DisableNotifications is set to 1. (https://workbench.cisecurity.org/sections/2101259/recommendations/3353899)
| 9.1.5 | Name of log file (Domain Profile, Policy) | Passed | Result=%SystemRoot%\System32\logfiles\firewall\pfirewall.log,Recommended=%SystemRoot%\System32\logfiles\firewall\domainfw.log. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101259)
| 9.1.6 | Log size limit (Domain Profile, Policy) | Medium | Result=4096,Recommended=16384
| 9.1.7 | Log dropped packets (Domain Profile, Policy) | Medium | Result=0,Recommended=1
| 9.1.8 | Log successful connections (Domain Profile, Policy) | Passed | Result=0,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101259)
| 9.2.1 | EnableFirewall (Private Profile, Policy) | Medium | Result=0,Recommended=1
| 9.2.2 | Inbound Connections (Private Profile, Policy) | Passed | Result=1,Recommended=1
| 9.2.3 | Outbound Connections (Private Profile, Policy) | Passed | Result=0,Recommended=0
| 9.2.4 | Display a notification (Private Profile, Policy) | Passed | Result=0,Recommended=1. The registry value documented by CIS is set successfully. HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\PublicProfile:DisableNotifications is set to 1. (https://workbench.cisecurity.org/sections/2101270/recommendations/3353909)
| 9.2.5 | Name of log file (Private Profile, Policy) | Passed | Result=%SystemRoot%\System32\logfiles\firewall\pfirewall.log,Recommended=%SystemRoot%\System32\logfiles\firewall\privatefw.log. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101270)
| 9.2.6 | Log size limit (Private Profile, Policy) | Medium | Result=4096,Recommended=16384
| 9.2.7 | Log dropped packets (Private Profile, Policy) | Medium | Result=0,Recommended=1
| 9.2.8 | Log successful connections (Private Profile, Policy) | Passed | Result=0,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101270)
| 9.3.1 | EnableFirewall (Public Profile, Policy) | Medium | Result=0,Recommended=1
| 9.3.2 | Inbound Connections (Public Profile, Policy) | Passed | Result=1,Recommended=1
| 9.3.3 | Outbound Connections (Public Profile, Policy) | Passed | Result=0,Recommended=0
| 9.3.4 | Display a notification (Public Profile, Policy) | Passed | Result=0,Recommended=1. The registry value documented by CIS is set successfully. HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\Mdm\StandardProfile:DisableNotifications is set to 1. (https://workbench.cisecurity.org/sections/2101272/recommendations/3353919)
| 9.3.5 | Apply local firewall rules (Public Profile, Policy) | Passed | Result=0,Recommended=0
| 9.3.6 | Apply local connection security rules (Public Profile, Policy) | Passed | Result=0,Recommended=0
| 9.3.7 | Name of log file (Public Profile, Policy) | Passed | Result=%SystemRoot%\System32\logfiles\firewall\pfirewall.log,Recommended=%SystemRoot%\System32\logfiles\firewall\publicfw.log. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101272)
| 9.3.8 | Log size limit (Public Profile, Policy) | Medium | Result=4096,Recommended=16384
| 9.3.9 | Log dropped packets (Public Profile, Policy) | Medium | Result=0,Recommended=1
| 9.3.10 | Log successful connections (Public Profile, Policy) | Passed | Result=0,Recommended=1. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101272)
| 17.1.1 | Credential Validation | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.2.1 | Application Group Management | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.2.2 | Security Group Management | Passed | Result=Success,Recommended=Success
| 17.2.3 | User Account Management | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.3.1 | Plug and Play Events | Passed | Result=Success,Recommended=Success
| 17.3.2 | Process Creation | Passed | Result=Success,Recommended=Success
| 17.5.1 | Account Lockout | Passed | Result=Failure,Recommended=Failure
| 17.5.2 | Group Membership | Passed | Result=Success,Recommended=Success
| 17.5.3 | Logoff | Passed | Result=Success,Recommended=Success
| 17.5.4 | Logon | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.5.5 | Other Logon/Logoff Events | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.5.6 | Special Logon | Passed | Result=Success,Recommended=Success
| 17.6.1 | Detailed File Share | Passed | Result=Failure,Recommended=Failure
| 17.6.2 | File Share | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.6.3 | Other Object Access Events | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.6.4 | Removable Storage | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.7.1 | Audit Policy Change | Passed | Result=Success,Recommended=Success
| 17.7.2 | Authentication Policy Change | Passed | Result=Success,Recommended=Success
| 17.7.3 | Authorization Policy Change | Passed | Result=Success,Recommended=Success
| 17.7.4 | MPSSVC Rule-Level Policy Change | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.7.5 | Other Policy Change Events | Passed | Result=Failure,Recommended=Failure
| 17.8.1 | Sensitive Privilege Use | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.9.1 | IPsec Driver | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.9.2 | Other System Events | Passed | Result=Success and Failure,Recommended=Success and Failure
| 17.9.3 | Security State Change | Passed | Result=Success and Failure,Recommended=Success
| 17.9.4 | Security System Extension | Passed | Result=Success,Recommended=Success
| 17.9.5 | System Integrity | Passed | Result=Success and Failure,Recommended=Success and Failure
| 18.1.1.1 | Personalization: Prevent enabling lock screen camera | Passed | Result=1,Recommended=1
| 18.1.1.2 | Personalization: Prevent enabling lock screen slide show | Passed | Result=1,Recommended=1
| 18.1.2.2 | Regional and Language Options: Allow users to enable online speech recognition services | Passed | Result=0,Recommended=0
| 18.1.3 | Allow Online Tips | Medium | Result=1,Recommended=0
| 18.3.1 | LAPS AdmPwd GPO Extension / CSE, Result=, Recommended=C:\Program Files\LAPS\CSE\AdmPwd.dll, Severity=Medium
| 18.3.2 | Do not allow password expiration time longer than required by policy | Medium | Result=0,Recommended=1
| 18.3.3 | Enable local admin password management | Medium | Result=0,Recommended=1
| 18.3.4 | Password Settings: Password Complexity | Passed | Result=4,Recommended=4
| 18.3.5 | Password Settings: Password Length | Medium | Result=14,Recommended=15
| 18.3.6 | Password Settings: Password Age (Days) | Passed | Result=30,Recommended=30
| 18.4.1 | Apply UAC restrictions to local accounts on network logons | Passed | Result=0,Recommended=0
| 18.4.2 | Configure RPC packet level privacy setting for incoming connections | Medium | Result=,Recommended=1
| 18.4.3 | Configure SMB v1 client driver | Passed | Result=4,Recommended=4
| 18.4.4 | Configure SMB v1 server | Passed | Result=0,Recommended=0
| 18.4.5 | Enable Structured Exception Handling Overwrite Protection (SEHOP) | Passed | Result=0,Recommended=0
| 18.4.6 | LSA Protection | Medium | Result=,Recommended=1
| 18.4.7 | NetBT NodeType configuration | Medium | Result=0,Recommended=2
| 18.4.8 | WDigest Authentication | Passed | Result=0,Recommended=0
| 18.5.1 | MSS: (AutoAdminLogon) Enable Automatic Logon (not recommended) | Passed | Result=0,Recommended=0
| 18.5.2 | MSS: (DisableIPSourceRouting IPv6) IP source routing protection level (protects against packet spoofing) | Passed | Result=2,Recommended=2
| 18.5.3 | MSS: (DisableIPSourceRouting) IP source routing protection level (protects against packet spoofing) | Passed | Result=2,Recommended=2
| 18.5.4 | MSS: (DisableSavePassword) Prevent the dial-up password from being saved | Passed | Result=1,Recommended=1
| 18.5.5 | MSS: (EnableICMPRedirect) Allow ICMP redirects to override OSPF generated routes | Passed | Result=0,Recommended=0
| 18.5.6 | MSS: (KeepAliveTime) How often keep-alive packets are sent in milliseconds | Passed | Result=300000,Recommended=300000
| 18.5.7 | MSS: (NoNameReleaseOnDemand) Allow the computer to ignore NetBIOS name release requests except from WINS servers | Passed | Result=1,Recommended=1
| 18.5.8 | MSS: (PerformRouterDiscovery) Allow IRDP to detect and configure Default Gateway addresses (could lead to DoS) | Passed | Result=0,Recommended=0
| 18.5.9 | MSS: (SafeDllSearchMode) Enable Safe DLL search mode (recommended) | Passed | Result=1,Recommended=1
| 18.5.10 | MSS: (ScreenSaverGracePeriod) The time in seconds before the screen saver grace period expires (0 recommended) | Passed | Result=5,Recommended=5
| 18.5.11 | MSS: (TcpMaxDataRetransmissions IPv6) How many times unacknowledged data is retransmitted | Passed | Result=3,Recommended=3
| 18.5.12 | MSS: (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted | Passed | Result=3,Recommended=3
| 18.5.13 | MSS: (WarningLevel) Percentage threshold for the security event log at which the system will generate a warning | Passed | Result=90,Recommended=90
| 18.6.4.1 | DNS Client: Configure NetBIOS settings | Medium | Result=,Recommended=2
| 18.6.4.2 | DNS Client: Turn off multicast name resolution (LLMNR) | Passed | Result=0,Recommended=0
| 18.6.5.1 | Fonts: Enable Font Providers | Medium | Result=1,Recommended=0
| 18.6.8.1 | Lanman Workstation: Enable insecure guest logons | Passed | Result=0,Recommended=0
| 18.6.9.1.1 | Link-Layer Topology Discovery: Turn on Mapper I/O (LLTDIO) driver (AllowLLTDIOOndomain) | Passed | Result=0,Recommended=0
| 18.6.9.1.2 | Link-Layer Topology Discovery: Turn on Mapper I/O (LLTDIO) driver (AllowLLTDIOOnPublicNet) | Passed | Result=0,Recommended=0
| 18.6.9.1.3 | Link-Layer Topology Discovery: Turn on Mapper I/O (LLTDIO) driver (EnableLLTDIO) | Passed | Result=0,Recommended=0
| 18.6.9.1.4 | Link-Layer Topology Discovery: Turn on Mapper I/O (LLTDIO) driver (ProhibitLLTDIOOnPrivateNet) | Passed | Result=0,Recommended=0
| 18.6.9.2.1 | Turn on Responder (RSPNDR) driver (AllowRspndrOnDomain) | Passed | Result=0,Recommended=0
| 18.6.9.2.2 | Turn on Responder (RSPNDR) driver (AllowRspndrOnPublicNet) | Passed | Result=0,Recommended=0
| 18.6.9.2.3 | Turn on Responder (RSPNDR) driver (EnableRspndr) | Passed | Result=0,Recommended=0
| 18.6.9.2.4 | Turn on Responder (RSPNDR) driver (ProhibitRspndrOnPrivateNet) | Passed | Result=0,Recommended=0
| 18.6.10.2 | Turn off Microsoft Peer-to-Peer Networking Services | Medium | Result=0,Recommended=1
| 18.6.11.2 | Network Connections: Prohibit installation and configuration of Network Bridge on your DNS domain network | Passed | Result=0,Recommended=0
| 18.6.11.3 | Network Connections: Prohibit use of Internet Connection Sharing on your DNS domain network | Passed | Result=0,Recommended=0
| 18.6.11.4 | Network Connections: Require domain users to elevate when setting a network's location | Medium | Result=0,Recommended=1
| 18.6.14.1.1 | Network Provider: Hardened UNC Paths (NETLOGON), Result=RequireMutualAuthentication=1,RequireIntegrity=1, Recommended=RequireMutualAuthentication=1,RequireIntegrity=1, Severity=Passed
| 18.6.14.1.2 | Network Provider: Hardened UNC Paths (SYSVOL), Result=RequireMutualAuthentication=1,RequireIntegrity=1, Recommended=RequireMutualAuthentication=1,RequireIntegrity=1, Severity=Passed
| 18.6.19.2.1 | Disable IPv6 | Medium | Result=0,Recommended=255
| 18.6.20.1.1 | Windows Connect Now: Configuration of wireless settings using Windows Connect Now (EnableRegistrars) | Medium | Result=1,Recommended=0
| 18.6.20.1.2 | Windows Connect Now: Configuration of wireless settings using Windows Connect Now (DisableUPnPRegistrar) | Medium | Result=1,Recommended=0
| 18.6.20.1.3 | Windows Connect Now: Configuration of wireless settings using Windows Connect Now (DisableInBand802DOT11Registrar) | Medium | Result=1,Recommended=0
| 18.6.20.1.4 | Windows Connect Now: Configuration of wireless settings using Windows Connect Now (DisableFlashConfigRegistrar) | Medium | Result=1,Recommended=0
| 18.6.20.1.5 | Windows Connect Now: Configuration of wireless settings using Windows Connect Now (DisableWPDRegistrar) | Medium | Result=1,Recommended=0
| 18.6.20.2 | Windows Connect Now: Prohibit access of the Windows Connect Now wizards | Passed | Result=1,Recommended=1
| 18.6.21.1 | Windows Connection Manager: Minimize the number of simultaneous connections to the Internet or a Windows Domain | Passed | Result=3,Recommended=3
| 18.6.21.2 | Windows Connection Manager: Prohibit connection to non-domain networks when connected to domain authenticated network | Passed | Result=1,Recommended=1
| 18.6.23.2.1 | WLAN Settings: Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services | Medium | Result=1,Recommended=0
| 18.7.1 | Printers: Allow Print Spooler to accept client connections | Passed | Result=2,Recommended=2
| 18.7.2 | Configure Redirection Guard | Medium | Result=,Recommended=1
| 18.7.3 | Configure RPC connection settings (RpcUseNamedPipeProtocol) | Medium | Result=,Recommended=0
| 18.7.4 | Configure RPC connection settings (RpcAuthentication) | Medium | Result=,Recommended=0
| 18.7.5 | Configure RPC listener settings (RpcProtocols) | Medium | Result=,Recommended=5
| 18.7.6 | Configure RPC listener settings (ForceKerberosForRpc) | Passed | Result=,Recommended=0
| 18.7.7 | Configure RPC over TCP port | Medium | Result=,Recommended=0
| 18.7.8 | Limits print driver installation to Administrators | Medium | Result=,Recommended=1
| 18.7.9 | Manage processing of Queue-specific files | Medium | Result=,Recommended=1
| 18.7.10 | Printers: Point and Print Restrictions: When installing drivers for a new connection | Passed | Result=0,Recommended=0
| 18.7.11 | Printers: Point and Print Restrictions: When updating drivers for an existing connection | Passed | Result=0,Recommended=0
| 18.8.1.1 | Notifications: Turn off notifications network usage | Medium | Result=0,Recommended=1
| 18.9.3.1 | Audit Process Creation: Include command line in process creation events | Passed | Result=1,Recommended=1
| 18.9.4.1 | Credentials Delegation: Encryption Oracle Remediation | Passed | Result=0,Recommended=0
| 18.9.4.2 | Credentials Delegation: Remote host allows delegation of non-exportable credentials | Passed | Result=1,Recommended=1
| 18.9.5.1 | Device Guard: Turn On Virtualization Based Security (Policy) | Passed | Result=1,Recommended=1
| 18.9.5.2 | Device Guard: Select Platform Security Level (Policy) | Passed | Result=3,Recommended=3
| 18.9.5.3 | Device Guard: Virtualization Based Protection of Code Integrity (Policy) | Medium | Result=,Recommended=1
| 18.9.5.4 | Device Guard: Require UEFI Memory Attributes Table (Policy) | Medium | Result=,Recommended=1
| 18.9.5.5 | Device Guard: Credential Guard Configuration (Policy) | Passed | Result=1,Recommended=1
| 18.9.5.6 | Device Guard: Secure Launch Configuration (Policy) | Passed | Result=1,Recommended=1
| 18.9.7.1.1 | Device Installation: Device Installation Restrictions: Prevent installation of devices that match an ID | Medium | Result=0,Recommended=1
| 18.9.7.1.2 | Device Installation: Device Installation Restrictions: Prevent installation of devices that match ID PCI\CC_0C0A (Thunderbolt) | Medium | Result=0,Recommended=PCI\CC_0C0A
| 18.9.7.1.3 | Device Installation: Device Installation Restrictions: Prevent installation of devices that match an ID (Retroactive) | Medium | Result=0,Recommended=1
| 18.9.7.1.4 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match an device setup class | Medium | Result=0,Recommended=1
| 18.9.7.1.5.1 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match d48179be-ec20-11d1-b6b8-00c04fa372a7 (SBP-2 drive), Result=0, Recommended=d48179be-ec20-11d1-b6b8-00c04fa372a7, Severity=Medium
| 18.9.7.1.5.2 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match 7ebefbc0-3200-11d2-b4c2-00a0C9697d07 (SBP-2 drive), Result=0, Recommended=7ebefbc0-3200-11d2-b4c2-00a0C9697d07, Severity=Medium
| 18.9.7.1.5.3 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match c06ff265-ae09-48f0-812c-16753d7cba83 (SBP-2 drive), Result=0, Recommended=c06ff265-ae09-48f0-812c-16753d7cba83, Severity=Medium
| 18.9.7.1.5.4 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match 6bdd1fc1-810f-11d0-bec7-08002be2092f (SBP-2 drive), Result=0, Recommended=6bdd1fc1-810f-11d0-bec7-08002be2092f, Severity=Medium
| 18.9.7.1.6 | Device Installation: Device Installation Restrictions: Prevent installation of devices using drivers that match an device setup class (Retroactive) | Medium | Result=0,Recommended=1
| 18.9.7.2 | Device Installation: Device Installation Restrictions: Prevent device metadata retrieval from the Internet | Passed | Result=1,Recommended=1
| 18.9.13.1 | Early Launch Antimalware: Boot-Start Driver Initialization Policy | Passed | Result=3,Recommended=3
| 18.9.19.2 | Group Policy: Do not apply during periodic background processing | Medium | Result=1,Recommended=0
| 18.9.19.3 | Group Policy: Process even if the Group Policy objects have not changed | Passed | Result=0,Recommended=0
| 18.9.19.4 | Group Policy: Continue experiences on this device | Passed | Result=0,Recommended=0
| 18.9.19.5 | Group Policy: Turn off background refresh of Group Policy | Passed | Result=0,Recommended=0
| 18.9.20.1.1 | Internet Communication Management: Internet Communication settings: Turn off access to the Store | Medium | Result=0,Recommended=1
| 18.9.20.1.2 | Internet Communication Management: Internet Communication settings: Turn off downloading of print drivers over HTTP | Medium | Result=0,Recommended=1
| 18.9.20.1.3 | Internet Communication Management: Internet Communication settings: Turn off handwriting personalization data sharing | Medium | Result=0,Recommended=1
| 18.9.20.1.4 | Internet Communication Management: Internet Communication settings: Turn off handwriting recognition error reporting | Medium | Result=0,Recommended=1
| 18.9.20.1.5 | Internet Communication Management: Internet Communication settings: Turn off Internet Connection Wizard if URL connection is referring to Microsoft.com | Passed | Result=1,Recommended=1
| 18.9.20.1.6 | Internet Communication Management: Internet Communication settings: Turn off Internet download for Web publishing and online ordering wizards | Medium | Result=0,Recommended=1
| 18.9.20.1.7 | Internet Communication Management: Internet Communication settings: Turn off printing over HTTP | Medium | Result=0,Recommended=1
| 18.9.20.1.8 | Internet Communication Management: Internet Communication settings: Turn off Registration if URL connection is referring to Microsoft.com | Passed | Result=1,Recommended=1
| 18.9.20.1.9 | Internet Communication Management: Internet Communication settings: Turn off Search Companion content file updates | Passed | Result=1,Recommended=1
| 18.9.20.1.10 | Internet Communication Management: Internet Communication settings: Turn off the 'Order Prints' picture task | Medium | Result=0,Recommended=1
| 18.9.20.1.11 | Internet Communication Management: Internet Communication settings: Turn off the 'Publish to Web' task for files and folders | Medium | Result=0,Recommended=1
| 18.9.20.1.12 | Internet Communication Management: Internet Communication settings: Turn off the Windows Messenger Customer Experience Improvement Program | Medium | Result=0,Recommended=2
| 18.9.20.1.13 | Internet Communication Management: Internet Communication settings: Turn off Windows Customer Experience Improvement Program | Passed | Result=0,Recommended=0
| 18.9.20.1.14.1 | Internet Communication Management: Internet Communication settings: Turn off Windows Error Reporting 1 | Passed | Result=0,Recommended=0
| 18.9.20.1.14.2 | Internet Communication Management: Internet Communication settings: Turn off Windows Error Reporting 2 | Passed | Result=1,Recommended=1
| 18.9.23.1.1 | Kerberos: Support device authentication using certificate (DevicePKInitBehavior) | Passed | Result=0,Recommended=0
| 18.9.23.1.2 | Kerberos: Support device authentication using certificate (DevicePKInitEnabled) | Passed | Result=1,Recommended=1
| 18.9.24.1 | Kernel DMA Protection: Enumeration policy for external devices incompatible with Kernel DMA Protection | Passed | Result=0,Recommended=0
| 18.9.25.1 | Local Security Authority: Allow Custom SSPs and APs to be loaded into LSASS | Medium | Result=,Recommended=0
| 18.9.25.2 | Local Security Authority: Configures LSASS to run as a protected process | Medium | Result=,Recommended=1
| 18.9.26.1 | Locale Services: Disallow copying of user input methods to the system account for sign-in | Passed | Result=1,Recommended=1
| 18.9.27.1 | Logon: Block user from showing account details on sign-in | Passed | Result=1,Recommended=1
| 18.9.27.2 | Logon: Do not display network selection UI | Passed | Result=1,Recommended=1
| 18.9.27.3 | Logon: Do not enumerate connected users on domain-joined computers | Passed | Result=1,Recommended=1
| 18.9.27.4 | Logon: Enumerate local users on domain-joined computers | Passed | Result=0,Recommended=0
| 18.9.27.5 | Logon: Turn off app notifications on the lock screen | Passed | Result=1,Recommended=1
| 18.9.27.6 | Logon: Turn off picture password sign-in | Passed | Result=1,Recommended=1
| 18.9.27.7 | Logon: Turn on convenience PIN sign-in | Passed | Result=0,Recommended=0
| 18.9.30.1 | OS Policies: Allow Clipboard synchronization across devices | Medium | Result=1,Recommended=0
| 18.9.30.2 | OS Policies: Allow upload of User Activities | Medium | Result=1,Recommended=0
| 18.9.32.6.1 | Sleep Settings: Allow network connectivity during connected-standby (on battery) | Passed | Result=0,Recommended=0
| 18.9.32.6.2 | Sleep Settings: Allow network connectivity during connected-standby (plugged in) | Medium | Result=1,Recommended=0
| 18.9.32.6.3 | Sleep Settings: Allow standby states (S1-S3) when sleeping (on battery) | Medium | Result=1,Recommended=0
| 18.9.32.6.4 | Sleep Settings: Allow standby states (S1-S3) when sleeping (plugged in) | Medium | Result=1,Recommended=0
| 18.9.32.6.5 | Sleep Settings: Require a password when a computer wakes (on battery) | Passed | Result=1,Recommended=1
| 18.9.32.6.6 | Sleep Settings: Require a password when a computer wakes (plugged in) | Passed | Result=1,Recommended=1
| 18.9.34.1 | Remote Assistance: Configure Offer Remote Assistance | Passed | Result=0,Recommended=0
| 18.9.34.2 | Remote Assistance: Configure Solicited Remote Assistance | Passed | Result=0,Recommended=0
| 18.9.35.1 | Remote Procedure Call: Enable RPC Endpoint Mapper Client Authentication | Passed | Result=1,Recommended=1
| 18.9.35.2 | Remote Procedure Call: Restrict Unauthenticated RPC clients | Passed | Result=1,Recommended=1
| 18.9.46.5.1 | Troubleshooting and Diagnostics: Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider | Passed | Result=0,Recommended=0
| 18.9.46.11.1 | Windows Performance PerfTrack: Enable/Disable PerfTrack | Medium | Result=1,Recommended=0
| 18.9.48.1 | User Profiles: Turn off the advertising ID | Passed | Result=1,Recommended=1
| 18.9.50.1.1 | Time Providers: Enable Windows NTP Client | Passed | Result=1,Recommended=1
| 18.9.50.1.2 | Time Providers: Enable Windows NTP Server | Passed | Result=0,Recommended=0
| 18.10.3.1 | App Package Deployment: Allow a Windows app to share application data between users | Passed | Result=0,Recommended=0
| 18.10.3.2 | App Package Deployment: Prevent non-admin users from installing packaged Windows apps | Medium | Result=0,Recommended=1
| 18.10.4.1 | App Privacy: Let Windows apps activate with voice while the system is locked | Medium | Result=0,Recommended=2
| 18.10.5.1 | App runtime: Allow Microsoft accounts to be optional | Passed | Result=1,Recommended=1
| 18.10.5.2 | App runtime: Block launching Universal Windows apps with Windows Runtime API access from hosted content | Passed | Result=1,Recommended=1
| 18.10.7.1 | AutoPlay Policies: Disallow Autoplay for non-volume devices | Passed | Result=1,Recommended=1
| 18.10.7.2 | AutoPlay Policies: Set the default behavior for AutoRun | Passed | Result=1,Recommended=1
| 18.10.7.3 | AutoPlay Policies: Turn off Autoplay | Passed | Result=255,Recommended=255
| 18.10.8.1.1 | Biometrics: Facial Features: Configure enhanced anti-spoofing | Medium | Result=,Recommended=1
| 18.10.9.1.1 | BitLocker Drive Encryption: Fixed Data Drives: Allow access to BitLocker-protected fixed data drives from earlier versions of Windows, Result=, Recommended=<none>, Severity=Medium
| 18.10.9.1.2 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered | Medium | Result=0,Recommended=1
| 18.10.9.1.3 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Allow data recovery agent | Passed | Result=1,Recommended=1
| 18.10.9.1.4 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Recovery Password | Medium | Result=,Recommended=2
| 18.10.9.1.5 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Recovery Key | Medium | Result=,Recommended=2
| 18.10.9.1.6 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Omit recovery options from the BitLocker setup wizard | Medium | Result=,Recommended=1
| 18.10.9.1.7 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Save BitLocker recovery information to AD DS for fixed data drives | Medium | Result=,Recommended=0
| 18.10.9.1.8 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Configure storage of BitLocker recovery information to AD DS | Medium | Result=,Recommended=1
| 18.10.9.1.9 | BitLocker Drive Encryption: Fixed Data Drives: Choose how BitLocker-protected fixed drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives | Medium | Result=,Recommended=0
| 18.10.9.1.10 | BitLocker Drive Encryption: Fixed Data Drives: Configure use of hardware-based encryption for fixed data drives | Medium | Result=,Recommended=0
| 18.10.9.1.11 | BitLocker Drive Encryption: Fixed Data Drives: Configure use of passwords for fixed data drives | Passed | Result=0,Recommended=0
| 18.10.9.1.12 | BitLocker Drive Encryption: Fixed Data Drives: Configure use of smart cards on fixed data drives | Medium | Result=,Recommended=1
| 18.10.9.1.13 | BitLocker Drive Encryption: Fixed Data Drives: Configure use of smart cards on fixed data drives: Require use of smart cards on fixed data drives | Medium | Result=0,Recommended=1
| 18.10.9.2.1 | BitLocker Drive Encryption: Operating System Drives: Allow enhanced PINs for startup | Medium | Result=0,Recommended=1
| 18.10.9.2.2 | BitLocker Drive Encryption: Operating System Drives: Allow Secure Boot for integrity validation | Medium | Result=0,Recommended=1
| 18.10.9.2.3 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered | Medium | Result=0,Recommended=1
| 18.10.9.2.4 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Allow data recovery agent | Medium | Result=1,Recommended=0
| 18.10.9.2.5 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Recovery Password | Medium | Result=,Recommended=1
| 18.10.9.2.6 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Recovery Key | Medium | Result=1,Recommended=0
| 18.10.9.2.7 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Omit recovery options from the BitLocker setup wizard | Medium | Result=0,Recommended=1
| 18.10.9.2.8 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Save BitLocker recovery information to AD DS for operating system drives | Medium | Result=0,Recommended=1
| 18.10.9.2.9 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Configure storage of BitLocker recovery information to AD DS | Medium | Result=0,Recommended=1
| 18.10.9.2.10 | BitLocker Drive Encryption: Operating System Drives: Choose how BitLocker-protected operating system drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for operating system drives | Medium | Result=0,Recommended=1
| 18.10.9.2.11 | BitLocker Drive Encryption: Operating System Drives: Configure use of hardware-based encryption for operating system drives: Restrict crypto algorithms or cipher suites | Medium | Result=,Recommended=2.16.840.1.101.3.4.1.2;2.16.840.1.101.3.4.1.42
| 18.10.9.2.12 | BitLocker Drive Encryption: Operating System Drives: Configure use of passwords for operating system drives | Medium | Result=,Recommended=0
| 18.10.9.2.13 | BitLocker Drive Encryption: Operating System Drives: Require additional authentication at startup | Medium | Result=0,Recommended=1
| 18.10.9.2.14 | BitLocker Drive Encryption: Operating System Drives: Require additional authentication at startup: Allow BitLocker without a compatible TPM | Medium | Result=1,Recommended=0
| 18.10.9.3.1 | BitLocker Drive Encryption: Removable Data Drives: Allow access to BitLocker-protected removable data drives from earlier versions of Windows, Result=, Recommended=<none>, Severity=Medium
| 18.10.9.3.2 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered | Medium | Result=0,Recommended=1
| 18.10.9.3.3 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Allow data recovery agent | Medium | Result=,Recommended=1
| 18.10.9.3.4 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Recovery Password | Medium | Result=,Recommended=0
| 18.10.9.3.5 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Recovery Key | Medium | Result=,Recommended=0
| 18.10.9.3.6 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Omit recovery options from the BitLocker setup wizard | Medium | Result=,Recommended=1
| 18.10.9.3.7 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Save BitLocker recovery information to AD DS for removable data drives | Medium | Result=,Recommended=0
| 18.10.9.3.8 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Configure storage of BitLocker recovery information to AD DS | Medium | Result=,Recommended=1
| 18.10.9.3.9 | BitLocker Drive Encryption: Removable Data Drives: Choose how BitLocker-protected removable drives can be recovered: Choose how BitLocker-protected removable drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for removable data drives | Medium | Result=,Recommended=0
| 18.10.9.3.10 | BitLocker Drive Encryption: Removable Data Drives: Configure use of hardware-based encryption for removable data drives | Medium | Result=,Recommended=1
| 18.10.9.3.11 | BitLocker Drive Encryption: Removable Data Drives: Configure use of passwords for removable data drives | Medium | Result=,Recommended=0
| 18.10.9.3.12 | BitLocker Drive Encryption: Removable Data Drives: Configure use of smart cards on removable data drives | Medium | Result=,Recommended=1
| 18.10.9.3.13 | BitLocker Drive Encryption: Removable Data Drives: Configure use of smart cards on removable data drives: Require use of smart cards on removable data drives | Medium | Result=,Recommended=1
| 18.10.9.3.14 | BitLocker Drive Encryption: Removable Data Drives: Deny write access to removable drives not protected by BitLocker | Medium | Result=,Recommended=1
| 18.10.9.3.15 | BitLocker Drive Encryption: Removable Data Drives: Do not allow write access to devices configured in another organization | Medium | Result=,Recommended=0
| 18.10.9.4 | BitLocker Drive Encryption: Disable new DMA devices when this computer is locked | Medium | Result=0,Recommended=1
| 18.10.10.1 | Camera: Allow Use of Camera | Medium | Result=1,Recommended=0
| 18.10.12.1 | Cloud Content: Turn off cloud consumer account state content | Medium | Result=,Recommended=1
| 18.10.12.2 | Cloud Content: Turn off cloud optimized content | Medium | Result=0,Recommended=1
| 18.10.12.3 | Cloud Content: Turn off Microsoft consumer experiences | Medium | Result=0,Recommended=1
| 18.10.13.1 | Connect: Require pin for pairing | Medium | Result=0,Recommended=1
| 18.10.14.1 | Credential User Interface: Do not display the password reveal button | Passed | Result=1,Recommended=1
| 18.10.14.2 | Credential User Interface: Enumerate administrator accounts on elevation | Passed | Result=0,Recommended=0
| 18.10.14.3 | Credential User Interface: Prevent the use of security questions for local accounts | Passed | Result=1,Recommended=1
| 18.10.15.1 | Data Collection and Preview Builds: Allow Diagnostic Data | Medium | Result=2,Recommended=1
| 18.10.15.2 | Data Collection and Preview Builds: Configure Authenticated Proxy usage for the Connected User Experience and Telemetry service | Medium | Result=0,Recommended=1
| 18.10.15.3 | Data Collection and Preview Builds: Disable OneSettings Downloads | Medium | Result=,Recommended=1
| 18.10.15.4 | Data Collection and Preview Builds: Do not show feedback notifications | Medium | Result=0,Recommended=1
| 18.10.15.5 | Data Collection and Preview Builds: Enable OneSettings Auditing | Medium | Result=,Recommended=1
| 18.10.15.6 | Data Collection and Preview Builds: Limit Diagnostic Log Collection | Medium | Result=,Recommended=1
| 18.10.15.7 | Data Collection and Preview Builds: Limit Dump Collection | Medium | Result=,Recommended=1
| 18.10.15.8 | Data Collection and Preview Builds: Toggle user control over Insider builds | Medium | Result=1,Recommended=0
| 18.10.16.1 | Delivery Optimization: Download Mode | Medium | Result=1,Recommended=2
| 18.10.17.1 | Desktop App Installer: Enable App Installer | Medium | Result=,Recommended=0
| 18.10.17.2 | Desktop App Installer: Enable App Installer Experimental Features | Medium | Result=,Recommended=0
| 18.10.17.3 | Desktop App Installer: Enable App Installer Hash Override | Medium | Result=,Recommended=0
| 18.10.17.4 | Desktop App Installer: Enable App Installer ms-appinstaller protocol | Medium | Result=,Recommended=0
| 18.10.26.1.1 | Event Log Service: Application: Control Event Log behavior when the log file reaches its maximum size | Passed | Result=0,Recommended=0
| 18.10.26.1.2 | Event Log Service: Application: Specify the maximum log file size (KB) | Passed | Result=102400,Recommended=32768
| 18.10.26.2.1 | Event Log Service: Security: Control Event Log behavior when the log file reaches its maximum size | Passed | Result=0,Recommended=0
| 18.10.26.2.2 | Event Log Service: Security: Specify the maximum log file size (KB) | Passed | Result=2097152,Recommended=196608
| 18.10.26.3.1 | Event Log Service: Setup: Control Event Log behavior when the log file reaches its maximum size | Passed | Result=0,Recommended=0
| 18.10.26.3.2 | Event Log Service: Setup: Specify the maximum log file size (KB) | Passed | Result=102400,Recommended=32768
| 18.10.26.4.1 | Event Log Service: System: Control Event Log behavior when the log file reaches its maximum size | Passed | Result=0,Recommended=0
| 18.10.26.4.2 | Event Log Service: System: Specify the maximum log file size (KB) | Passed | Result=204800,Recommended=32768
| 18.10.29.2 | File Explorer: Turn off Data Execution Prevention for Explorer | Passed | Result=0,Recommended=0
| 18.10.29.3 | File Explorer: Turn off heap termination on corruption | Passed | Result=0,Recommended=0
| 18.10.29.4 | File Explorer: Turn off shell protocol protected mode | Passed | Result=0,Recommended=0
| 18.10.33.1 | HomeGroup: Prevent the computer from joining a homegroup | Passed | Result=1,Recommended=1
| 18.10.35.1 | Internet Explorer: Disable Internet Explorer 11 as a standalone browser | Passed | Result=1,Recommended=1
| 18.10.37.2 | Location and Sensors: Turn off location | Medium | Result=0,Recommended=1
| 18.10.41.1 | Messaging: Allow Message Service Cloud Sync | Medium | Result=1,Recommended=0
| 18.10.42.1 | Microsoft account: Block all consumer Microsoft account user authentication | Passed | Result=1,Recommended=1
| 18.10.43.5.1 | MAPS: Configure local setting override for reporting to Microsoft MAPS | Passed | Result=0,Recommended=0
| 18.10.43.5.2 | MAPS: Join Microsoft MAPS | Medium | Result=2,Recommended=0
| 18.10.43.6.1.1 | Attack Surface Reduction rules | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.1.1 | ASR: Block all Office applications from creating child processes (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.1.2 | ASR: Block all Office applications from creating child processes | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.2.1 | ASR: Block Office applications from creating executable content (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.2.2 | ASR: Block Office applications from creating executable content | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.3.1 | ASR: Block execution of potentially obfuscated scripts (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.3.2 | ASR: Block execution of potentially obfuscated scripts | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.4.1 | ASR: Block Office applications from injecting code into other processes (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.4.2 | ASR: Block Office applications from injecting code into other processes | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.5.1 | ASR: Block Adobe Reader from creating child processes (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.5.2 | ASR: Block Adobe Reader from creating child processes | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.6.1 | ASR: Block Win32 API calls from Office macros (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.6.2 | ASR: Block Win32 API calls from Office macros | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.7.1 | ASR: Block credential stealing from the Windows local security authority subsystem (lsass.exe) (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.7.2 | ASR: Block credential stealing from the Windows local security authority subsystem (lsass.exe) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.8.1 | ASR: Block untrusted and unsigned processes that run from USB (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.8.2 | ASR: Block untrusted and unsigned processes that run from USB | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.9.1 | ASR: Block executable content from email client and webmail (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.9.2 | ASR: Block executable content from email client and webmail | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.10.1 | ASR: Block JavaScript or VBScript from launching downloaded executable content (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.10.2 | ASR: Block JavaScript or VBScript from launching downloaded executable content | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.11.1 | ASR: Block Office communication application from creating child processes (Policy) | Medium | Result=2,Recommended=1
| 18.10.43.6.1.2.11.2 | ASR: Block Office communication application from creating child processes | Medium | Result=2,Recommended=1
| 18.10.43.6.1.2.12.1 | ASR: Block persistence through WMI event subscription (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.12.2 | ASR: Block persistence through WMI event subscription | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.13.1 | ASR: Block abuse of exploited vulnerable signed drivers (Policy) | Passed | Result=1,Recommended=1
| 18.10.43.6.1.2.13.1 | ASR: Block abuse of exploited vulnerable signed drivers | Passed | Result=1,Recommended=1
| 18.10.43.6.3.1 | Network Protection: Prevent users and apps from accessing dangerous websites | Medium | Result=,Recommended=1
| 18.10.43.7.1 | MpEngine: Enable file hash computation feature | Passed | Result=1,Recommended=1
| 18.10.43.10.1 | Real-time Protection: Scan all downloaded files and attachments | Passed | Result=0,Recommended=0
| 18.10.43.10.2 | Real-time Protection: Turn off real-time protection | Passed | Result=0,Recommended=0
| 18.10.43.10.3 | Real-time Protection: Turn on behavior monitoring (Policy) | Passed | Result=0,Recommended=0
| 18.10.43.10.4 | Real-time Protection: Turn on script scanning | Passed | Result=0,Recommended=0
| 18.10.43.12.1 | Reporting: Configure Watson events | Passed | Result=1,Recommended=1
| 18.10.43.13.1 | Scan: Scan removable drives | Passed | Result=0,Recommended=0
| 18.10.43.13.2 | Scan: Turn on e-mail scanning | Passed | Result=0,Recommended=0
| 18.10.43.15 | Configure detection for potentially unwanted applications | Medium | Result=0,Recommended=1
| 18.10.43.16 | Turn off Microsoft Defender Antivirus | Passed | Result=0,Recommended=0
| 18.10.44.1 | Allow auditing events in Microsoft Defender Application Guard | Medium | Result=,Recommended=1
| 18.10.44.2 | Allow camera and microphone access in Microsoft Defender Application Guard | Medium | Result=,Recommended=0
| 18.10.44.3 | Allow data persistence for Microsoft Defender Application Guard | Medium | Result=,Recommended=0
| 18.10.44.4 | Allow files to download and save to the host operating system from Microsoft Defender Application Guard | Medium | Result=,Recommended=0
| 18.10.44.5 | Configure Microsoft Defender Application Guard clipboard settings: Clipboard behavior setting | Medium | Result=,Recommended=1
| 18.10.44.6 | Turn on Microsoft Defender Application Guard in Managed Mode | Medium | Result=,Recommended=1
| 18.10.50.1 | News and interests: Enable news and interests on the taskbar | Medium | Result=,Recommended=0
| 18.10.51.1 | OneDrive: Prevent the usage of OneDrive for file storage | Medium | Result=0,Recommended=1
| 18.10.56.1 | Push To Install: Turn off Push To Install service | Passed | Result=1,Recommended=1
| 18.10.57.2.2 | Remote Desktop Connection Client: Do not allow passwords to be saved | Passed | Result=1,Recommended=1
| 18.10.57.3.2.1 | Remote Desktop Session Host: Allow users to connect remotely by using Remote Desktop Services | Passed | Result=1,Recommended=1
| 18.10.57.3.3.1 | Remote Desktop Session Host: Device and Resource Redirection: Allow UI Automation redirection | Medium | Result=,Recommended=0
| 18.10.57.3.3.2 | Remote Desktop Session Host: Device and Resource Redirection: Do not allow COM port redirection | Passed | Result=1,Recommended=1
| 18.10.57.3.3.3 | Remote Desktop Session Host: Device and Resource Redirection: Do not allow drive redirection | Passed | Result=1,Recommended=1
| 18.10.57.3.3.4 | Remote Desktop Session Host: Device and Resource Redirection: Do not allow location redirection | Medium | Result=,Recommended=1
| 18.10.57.3.3.5 | Remote Desktop Session Host: Device and Resource Redirection: Do not allow LPT port redirection | Passed | Result=1,Recommended=1
| 18.10.57.3.3.6 | Remote Desktop Session Host: Device and Resource Redirection: Do not allow supported Plug and Play device redirection | Passed | Result=1,Recommended=1
| 18.10.57.3.3.7 | Remote Desktop Session Host: Do not allow WebAuthn redirection | Medium | Result=,Recommended=1
| 18.10.57.3.9.1 | Remote Desktop Session Host: Security: Always prompt for password upon connection | Medium | Result=0,Recommended=1
| 18.10.57.3.9.2 | Remote Desktop Session Host: Security: Require secure RPC communication | Passed | Result=1,Recommended=1
| 18.10.57.3.9.3 | Remote Desktop Session Host: Security: Require use of specific security layer for remote (RDP) connections | Passed | Result=2,Recommended=2
| 18.10.57.3.9.4 | Remote Desktop Session Host: Security: Require user authentication for remote connections by using Network Level Authentication | Medium | Result=0,Recommended=1
| 18.10.57.3.9.5 | Remote Desktop Session Host: Security: Set client connection encryption level | Passed | Result=3,Recommended=3
| 18.10.57.3.10.1 | Remote Desktop Session Host: Session Time Limits: Set time limit for active but idle Remote Desktop Services sessions | Passed | Result=900000,Recommended=900000
| 18.10.57.3.10.2 | Remote Desktop Session Host: Session Time Limits: Set time limit for disconnected sessions | Passed | Result=60000,Recommended=60000
| 18.10.57.3.11.1 | Remote Desktop Session Host: Temporary folders: Do not delete temp folders upon exit | Passed | Result=1,Recommended=1
| 18.10.58.1 | RSS Feeds: Prevent downloading of enclosures | Passed | Result=1,Recommended=1
| 18.10.59.2 | Search: Allow Cloud Search | Medium | Result=1,Recommended=0
| 18.10.59.3 | Search: Allow Cortana | Medium | Result=1,Recommended=0
| 18.10.59.4 | Search: Allow Cortana above lock screen | Medium | Result=1,Recommended=0
| 18.10.59.5 | Search: Allow indexing of encrypted files | Medium | Result=1,Recommended=0
| 18.10.59.7 | Search: Allow search highlights | Medium | Result=,Recommended=0
| 18.10.59.6 | Search: Allow search and Cortana to use location | Medium | Result=1,Recommended=0
| 18.10.63.1 | Software Protection Platform: Turn off KMS Client Online AVS Validation | Medium | Result=0,Recommended=1
| 18.10.66.1 | Store: Disable all apps from Microsoft Store | Medium | Result=,Recommended=1
| 18.10.66.2 | Store: Only display the private store within the Microsoft Store | Medium | Result=0,Recommended=1
| 18.10.66.3 | Store: Turn off Automatic Download and Install of updates | Medium | Result=,Recommended=4
| 18.10.66.4 | Store: Turn off the offer to update to the latest version of Windows | Passed | Result=1,Recommended=1
| 18.10.66.5 | Store: Turn off the Store application | Medium | Result=0,Recommended=1
| 18.10.72.1 | Widgest: Allow widgets | Medium | Result=,Recommended=0
| 18.10.76.1.1.1 | File Explorer: Configure Windows Defender SmartScreen | Passed | Result=1,Recommended=1
| 18.10.76.1.1.2 | File Explorer: Configure Windows Defender SmartScreen to warn and prevent bypass | Medium | Result=Warn,Recommended=Block
| 18.10.76.2.1 | Configure Windows Defender SmartScreen | Medium | Result=,Recommended=1
| 18.10.76.2.2 | Prevent bypassing Microsoft Defender SmartScreen prompts for sites | Medium | Result=,Recommended=1
| 18.10.78.1 | Windows Game Recording and Broadcasting: Enables or disables Windows Game Recording and Broadcasting | Medium | Result=1,Recommended=0
| 18.10.80.1 | Windows Ink Workspace: Allow suggested apps in Windows Ink Workspace | Medium | Result=1,Recommended=0
| 18.10.80.2 | Windows Ink Workspace: Allow Windows Ink Workspace | Passed | Result=1,Recommended=1
| 18.10.81.1 | Windows Installer: Allow user control over installs | Passed | Result=0,Recommended=0
| 18.10.81.2 | Windows Installer: Always install with elevated privileges | Passed | Result=0,Recommended=0
| 18.10.81.3 | Windows Installer: Prevent Internet Explorer security prompt for Windows Installer scripts | Medium | Result=1,Recommended=0
| 10.10.82.1 | Windows Logon Options: Enable MPR notifications for the system | Medium | Result=,Recommended=0
| 18.10.82.2 | Windows Logon Options: Sign-in and lock last interactive user automatically after a restart | Passed | Result=1,Recommended=1
| 18.10.87.1 | Turn on PowerShell Script Block Logging | Passed | Result=1,Recommended=1
| 18.10.87.2 | Turn on PowerShell Transcription | Passed | Result=1,Recommended=1
| 18.10.89.1.1 | WinRM Client: Allow Basic authentication | Passed | Result=0,Recommended=0
| 18.10.89.1.2 | WinRM Client: Allow unencrypted traffic | Passed | Result=0,Recommended=0
| 18.10.89.1.3 | WinRM Client: Disallow Digest authentication | Passed | Result=0,Recommended=0
| 18.10.89.2.1 | WinRM Service: Allow Basic authentication | Passed | Result=0,Recommended=0
| 18.10.89.2.2 | WinRM Service: Allow remote server management through WinRM | Passed | Result=0,Recommended=0
| 18.10.89.2.3 | WinRM Service: Allow unencrypted traffic | Passed | Result=0,Recommended=0
| 18.10.89.2.4 | WinRM Service: Disallow WinRM from storing RunAs credentials | Passed | Result=1,Recommended=1
| 18.10.90.1 | Windows Remote Shell: Allow Remote Shell Access | Passed | Result=0,Recommended=0
| 18.10.91.1 | Windows Sandbox: Allow clipboard sharing with Windows Sandbox | Medium | Result=,Recommended=0
| 18.10.91.2 | Windows Sandbox: Allow networking in Windows Sandbox | Medium | Result=,Recommended=0
| 18.10.92.2.1 | App and browser protection: Prevent users from modifying settings | Passed | Result=1,Recommended=1
| 18.10.93.1.1 | Windows Update: Legacy Policies: No auto-restart with logged on users for scheduled automatic updates installations | Passed | Result=0,Recommended=0
| 18.10.93.2.1 | Windows Update: Manage end user experience: Configure Automatic Updates | Passed | Result=0,Recommended=0
| 18.10.93.2.2 | Windows Update: Manage end user experience: Configure Automatic Updates: Scheduled install day | Medium | Result=,Recommended=0
| 18.10.93.2.3 | Windows Update: Manage end user experience: Remove access to 'Pause updates' feature | Medium | Result=,Recommended=1
| 18.10.93.4.1.1 | Windows Update: Manage updates offered from Windows Update: Manage preview builds (ManagePreviewBuilds) | Medium | Result=,Recommended=1
| 18.10.93.4.1.2 | Windows Update: Manage updates offered from Windows Update: Manage preview builds (ManagePreviewBuildsPolicyValue) | Medium | Result=,Recommended=0
| 18.10.93.4.2.1 | Windows Update: Manage updates offered from Windows Update: Select when Preview Builds and Feature Updates are received (DeferFeatureUpdates) | Medium | Result=,Recommended=1
| 18.10.93.4.2.2 | Windows Update: Manage updates offered from Windows Update: Select when Preview Builds and Feature Updates are received (BranchReadinessLevel) | Passed | Result=,Recommended=2. This policy is not in the Intune benchmark. (see https://workbench.cisecurity.org/benchmarks/14355/sections/2101622)
| 18.10.93.4.2.3 | Windows Update: Manage updates offered from Windows Update: Select when Preview Builds and Feature Updates are received (DeferFeatureUpdatesPeriodInDays) | Medium | Result=,Recommended=180
| 18.10.93.4.3.1 | Windows Update: Manage updates offered from Windows Update: Select when Quality Updates are received (DeferQualityUpdates) | Medium | Result=,Recommended=1
| 18.10.93.4.3.2 | Windows Update: Manage updates offered from Windows Update: Select when Quality Updates are received (DeferQualityUpdatesPeriodInDays) | Medium | Result=,Recommended=0

# Extras
Firefox can be a pain to work with OMA-URIs. I created a stylesheet to make it a lot easier and that can be seen in the screenshot above. To install, go into the "Extras" folder for instructions.

# Status
All settings of CIS Intune benchmark implemented with the exception of Bitlocker. A seperate bitlocker configuration will be created.
