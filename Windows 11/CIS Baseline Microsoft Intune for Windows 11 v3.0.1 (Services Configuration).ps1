# Implements CIS v3.0.1 - 69.1 to 69.45
# This should be configured to automatically run as a platform script in Intune or another RMM tool.

#69.1	(L2) Ensure 'Bluetooth Audio Gateway Service (BTAGService)' is set to 'Disabled'
#Set-Service -Name BTAGService -StartupType Disabled -ErrorAction SilentlyContinue # Bluetooh

#69.2 (L2) Ensure 'Bluetooth Support Service (bthserv)' is set to 'Disabled'
#Set-Service -Name bthserv -StartupType Disabled -ErrorAction SilentlyContinue # Bluetooth

#69.3 (L1) Ensure 'Computer Browser (Browser)' is set to 'Disabled' or 'Not Installed'
# (doesn't exist on Windows 11)
#Set-Service -Name browser -StartupType Disabled -ErrorAction SilentlyContinue

#69.4 (L2) Ensure 'Downloaded Maps Manager (MapsBroker)' is set to 'Disabled'
Set-Service -Name MapsBroker -StartupType Disabled -ErrorAction SilentlyContinue

#69.5	(L2) Ensure 'Geolocation Service (lfsvc)' is set to 'Disabled'
Set-Service -Name lfsvc -StartupType Disabled -ErrorAction SilentlyContinue

# 69.6	(L1) Ensure 'IIS Admin Service (IISADMIN)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
#Set-Service -Name IISADMIN -StartupType Disabled -ErrorAction SilentlyContinue

#69.7	(L1) Ensure 'Infrared monitor service (irmon)' is set to 'Disabled' or 'Not Installed'
# (doesn't exist on Windows 11)
#Set-Service -Name irmon -StartupType Disabled -ErrorAction SilentlyContinue

#69.8	(L1) Ensure 'Internet Connection Sharing (ICS) (SharedAccess)' is set to 'Disabled'
Set-Service -Name SharedAccess -StartupType Disabled -ErrorAction SilentlyContinue

#69.9	(L2) Ensure 'Link-Layer Topology Discovery Mapper (lltdsvc)' is set to 'Disabled'
Set-Service -Name lltdsvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.10	(L1) Ensure 'LxssManager (LxssManager)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name LxssManager -StartupType Disabled -ErrorAction SilentlyContinue    # Prior to 24h2, will not exist by default
Set-Service -Name WSLService -StartupType Disabled -ErrorAction SilentlyContinue     # After 24h2, will not exist by default

#69.11	(L1) Ensure 'Microsoft FTP Service (FTPSVC)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
Set-Service -Name FTPSVC -StartupType Disabled -ErrorAction SilentlyContinue

#69.12	(L2) Ensure 'Microsoft iSCSI Initiator Service (MSiSCSI)' is set to 'Disabled'
Set-Service -Name MSiSCSI -StartupType Disabled -ErrorAction SilentlyContinue

#69.13	(L1) Ensure 'OpenSSH SSH Server (sshd)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
Set-Service -Name sshd -StartupType Disabled -ErrorAction SilentlyContinue

#69.14	(L2) Ensure 'Peer Name Resolution Protocol (PNRPsvc)' is set to 'Disabled'
Set-Service -Name PNRPsvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.15	(L2) Ensure 'Peer Networking Grouping (p2psvc)' is set to 'Disabled'
Set-Service -Name p2psvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.16	(L2) Ensure 'Peer Networking Identity Manager (p2pimsvc)' is set to 'Disabled'
Set-Service -Name p2pimsvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.17	(L2) Ensure 'PNRP Machine Name Publication Service (PNRPAutoReg)' is set to 'Disabled'
Set-Service -Name PNRPAutoReg -StartupType Disabled -ErrorAction SilentlyContinue

#69.18	(L2) Ensure 'Print Spooler (Spooler)' is set to 'Disabled'
# Opposed: Required for printing
#Set-Service -Name Spooler -StartupType Disabled -ErrorAction SilentlyContinue

#69.19	(L2) Ensure 'Problem Reports and Solutions Control Panel Support (wercplsupport)' is set to 'Disabled'
Set-Service -Name wercplsupport -StartupType Disabled -ErrorAction SilentlyContinue

#69.20	(L2) Ensure 'Remote Access Auto Connection Manager (RasAuto)' is set to 'Disabled'
Set-Service -Name RasAuto -StartupType Disabled -ErrorAction SilentlyContinue

#69.21	(L2) Ensure 'Remote Desktop Configuration (SessionEnv)' is set to 'Disabled'
Set-Service -Name SessionEnv -StartupType Disabled -ErrorAction SilentlyContinue

#69.22	(L2) Ensure 'Remote Desktop Services (TermService)' is set to 'Disabled'
Set-Service -Name TermService -StartupType Disabled -ErrorAction SilentlyContinue

#69.23	(L2) Ensure 'Remote Desktop Services UserMode Port Redirector (UmRdpService)' is set to 'Disabled'
Set-Service -Name UmRdpService -StartupType Disabled -ErrorAction SilentlyContinue

#69.24	(L1) Ensure 'Remote Procedure Call (RPC) Locator (RpcLocator)' is set to 'Disabled'
Set-Service -Name RpcLocator -StartupType Disabled -ErrorAction SilentlyContinue

#69.25	(L2) Ensure 'Remote Registry (RemoteRegistry)' is set to 'Disabled'
Set-Service -Name RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue

#69.26	(L1) Ensure 'Routing and Remote Access (RemoteAccess)' is set to 'Disabled'
Set-Service -Name RemoteAccess -StartupType Disabled -ErrorAction SilentlyContinue

#69.27	(L2) Ensure 'Server (LanmanServer)' is set to 'Disabled'
Set-Service -Name LanmanServer -StartupType Disabled -ErrorAction SilentlyContinue

#69.28	(L1) Ensure 'Simple TCP/IP Services (simptcp)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name simptcp -StartupType Disabled -ErrorAction SilentlyContinue

#69.29	(L2) Ensure 'SNMP Service (SNMP)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name SNMP -StartupType Disabled -ErrorAction SilentlyContinue

#69.30	(L1) Ensure 'Special Administration Console Helper (sacsvr)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name sacsvr -StartupType Disabled -ErrorAction SilentlyContinue

#69.31	(L1) Ensure 'SSDP Discovery (SSDPSRV)' is set to 'Disabled'
Set-Service -Name SSDPSRV -StartupType Disabled -ErrorAction SilentlyContinue

#69.32	(L1) Ensure 'UPnP Device Host (upnphost)' is set to 'Disabled'
Set-Service -Name upnphost -StartupType Disabled -ErrorAction SilentlyContinue

#69.33	(L1) Ensure 'Web Management Service (WMSvc)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name WMSvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.34	(L2) Ensure 'Windows Error Reporting Service (WerSvc)' is set to 'Disabled'
Set-Service -Name WerSvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.35	(L2) Ensure 'Windows Event Collector (Wecsvc)' is set to 'Disabled'
Set-Service -Name Wecsvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.36	(L1) Ensure 'Windows Media Player Network Sharing Service (WMPNetworkSvc)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name WMPNetworkSvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.37	(L1) Ensure 'Windows Mobile Hotspot Service (icssvc)' is set to 'Disabled'
Set-Service -Name icssvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.38	(L2) Ensure 'Windows Push Notifications System Service (WpnService)' is set to 'Disabled'
Set-Service -Name WpnService -StartupType Disabled -ErrorAction SilentlyContinue

#69.39	(L2) Ensure 'Windows PushToInstall Service (PushToInstall)' is set to 'Disabled'
Set-Service -Name PushToInstall -StartupType Disabled -ErrorAction SilentlyContinue

#69.40	(L2) Ensure 'Windows Remote Management (WS-Management) (WinRM)' is set to 'Disabled'
Set-Service -Name WinRM -StartupType Disabled -ErrorAction SilentlyContinue

#69.41	(L1) Ensure 'World Wide Web Publishing Service (W3SVC)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name W3SVC -StartupType Disabled -ErrorAction SilentlyContinue

#69.42	(L1) Ensure 'Xbox Accessory Management Service (XboxGipSvc)' is set to 'Disabled'
Set-Service -Name XboxGipSvc -StartupType Disabled -ErrorAction SilentlyContinue

#69.43	(L1) Ensure 'Xbox Live Auth Manager (XblAuthManager)' is set to 'Disabled'
Set-Service -Name XblAuthManager -StartupType Disabled -ErrorAction SilentlyContinue

#69.44	(L1) Ensure 'Xbox Live Game Save (XblGameSave)' is set to 'Disabled'
Set-Service -Name XblGameSave -StartupType Disabled -ErrorAction SilentlyContinue

#69.45	(L1) Ensure 'Xbox Live Networking Service (XboxNetApiSvc)' is set to 'Disabled'
Set-Service -Name XboxNetApiSvc -StartupType Disabled -ErrorAction SilentlyContinue