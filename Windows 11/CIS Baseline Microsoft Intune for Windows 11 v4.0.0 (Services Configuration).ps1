# Implements CIS v4.0.0 - 81.1 to 81.42
# This should be configured to automatically run as a platform script in Intune or another RMM tool.

# 81.1 (L2) Ensure 'Bluetooth Audio Gateway Service (BTAGService)' is set to 'Disabled'
# Opposed: We will allow Bluetooth to function.
#Set-Service -Name BTAGService -StartupType Disabled -ErrorAction SilentlyContinue # Bluetooh

# 81.2 (L2) Ensure 'Bluetooth Support Service (bthserv)' is set to 'Disabled'
# Opposed: We will allow Bluetooth to function.
#Set-Service -Name bthserv -StartupType Disabled -ErrorAction SilentlyContinue # Bluetooth

# 81.3 (L1) Ensure 'Computer Browser (Browser)' is set to 'Disabled' or 'Not Installed'
# (doesn't exist on Windows 11)
Set-Service -Name browser -StartupType Disabled -ErrorAction SilentlyContinue

# 81.4 (L2) Ensure 'Downloaded Maps Manager (MapsBroker)' is set to 'Disabled'
Set-Service -Name MapsBroker -StartupType Disabled -ErrorAction SilentlyContinue

# 81.5 (L2) Ensure 'GameInput Service (GameInputSvc)' is set to 'Disabled'
Set-Service -Name GameInputSvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.6 (L2) Ensure 'Geolocation Service (lfsvc)' is set to 'Disabled'
Set-Service -Name lfsvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.7	(L1) Ensure 'IIS Admin Service (IISADMIN)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
Set-Service -Name IISADMIN -StartupType Disabled -ErrorAction SilentlyContinue

# 81.8	(L1) Ensure 'Infrared monitor service (irmon)' is set to 'Disabled' or 'Not Installed'
# (doesn't exist on Windows 11)
Set-Service -Name irmon -StartupType Disabled -ErrorAction SilentlyContinue

# 81.9	(L2) Ensure 'Link-Layer Topology Discovery Mapper (lltdsvc)' is set to 'Disabled'
Set-Service -Name lltdsvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.10	(L1) Ensure 'LxssManager (LxssManager)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name LxssManager -StartupType Disabled -ErrorAction SilentlyContinue    # Prior to 24h2, will not exist by default
Set-Service -Name WSLService -StartupType Disabled -ErrorAction SilentlyContinue     # After 24h2, will not exist by default

# 81.11	(L1) Ensure 'Microsoft FTP Service (FTPSVC)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
Set-Service -Name FTPSVC -StartupType Disabled -ErrorAction SilentlyContinue

# 81.12	(L2) Ensure 'Microsoft iSCSI Initiator Service (MSiSCSI)' is set to 'Disabled'
Set-Service -Name MSiSCSI -StartupType Disabled -ErrorAction SilentlyContinue

# 81.13	(L1) Ensure 'OpenSSH SSH Server (sshd)' is set to 'Disabled' or 'Not Installed'
# (not installed by default)
Set-Service -Name sshd -StartupType Disabled -ErrorAction SilentlyContinue

# 81.14	(L2) Ensure 'Print Spooler (Spooler)' is set to 'Disabled'
# Opposed: Required for printing
#Set-Service -Name Spooler -StartupType Disabled -ErrorAction SilentlyContinue

# 81.15	(L2) Ensure 'Problem Reports and Solutions Control Panel Support (wercplsupport)' is set to 'Disabled'
Set-Service -Name wercplsupport -StartupType Disabled -ErrorAction SilentlyContinue

# 81.16	(L2) Ensure 'Remote Access Auto Connection Manager (RasAuto)' is set to 'Disabled'
Set-Service -Name RasAuto -StartupType Disabled -ErrorAction SilentlyContinue

# 81.17	(L2) Ensure 'Remote Desktop Configuration (SessionEnv)' is set to 'Disabled'
Set-Service -Name SessionEnv -StartupType Disabled -ErrorAction SilentlyContinue

# 81.18	(L2) Ensure 'Remote Desktop Services (TermService)' is set to 'Disabled'
Set-Service -Name TermService -StartupType Disabled -ErrorAction SilentlyContinue

# 81.19	(L2) Ensure 'Remote Desktop Services UserMode Port Redirector (UmRdpService)' is set to 'Disabled'
Set-Service -Name UmRdpService -StartupType Disabled -ErrorAction SilentlyContinue

# 81.20	(L1) Ensure 'Remote Procedure Call (RPC) Locator (RpcLocator)' is set to 'Disabled'
Set-Service -Name RpcLocator -StartupType Disabled -ErrorAction SilentlyContinue

# 81.21	(L2) Ensure 'Remote Registry (RemoteRegistry)' is set to 'Disabled'
Set-Service -Name RemoteRegistry -StartupType Disabled -ErrorAction SilentlyContinue

# 81.22	(L1) Ensure 'Routing and Remote Access (RemoteAccess)' is set to 'Disabled'
Set-Service -Name RemoteAccess -StartupType Disabled -ErrorAction SilentlyContinue

# 81.23	(L2) Ensure 'Server (LanmanServer)' is set to 'Disabled'
Set-Service -Name LanmanServer -StartupType Disabled -ErrorAction SilentlyContinue

# 81.24	(L1) Ensure 'Simple TCP/IP Services (simptcp)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name simptcp -StartupType Disabled -ErrorAction SilentlyContinue

# 81.25	(L2) Ensure 'SNMP Service (SNMP)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name SNMP -StartupType Disabled -ErrorAction SilentlyContinue

# 81.26	(L1) Ensure 'Special Administration Console Helper (sacsvr)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name sacsvr -StartupType Disabled -ErrorAction SilentlyContinue

# 81.27	(L1) Ensure 'SSDP Discovery (SSDPSRV)' is set to 'Disabled'
Set-Service -Name SSDPSRV -StartupType Disabled -ErrorAction SilentlyContinue

# 81.28	(L1) Ensure 'UPnP Device Host (upnphost)' is set to 'Disabled'
Set-Service -Name upnphost -StartupType Disabled -ErrorAction SilentlyContinue

# 81.29	(L1) Ensure 'Web Management Service (WMSvc)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name WMSvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.30	(L2) Ensure 'Windows Error Reporting Service (WerSvc)' is set to 'Disabled'
Set-Service -Name WerSvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.31	(L2) Ensure 'Windows Event Collector (Wecsvc)' is set to 'Disabled'
Set-Service -Name Wecsvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.32	(L1) Ensure 'Windows Media Player Network Sharing Service (WMPNetworkSvc)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name WMPNetworkSvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.33	(L1) Ensure 'Windows Mobile Hotspot Service (icssvc)' is set to 'Disabled'
Set-Service -Name icssvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.34	(L2) Ensure 'Windows Push Notifications System Service (WpnService)' is set to 'Disabled'
# Opposed: May interfere with Intune Device Management functionality
Set-Service -Name WpnService -StartupType Automatic -ErrorAction SilentlyContinue

# 81.35	(L2) Ensure 'Windows PushToInstall Service (PushToInstall)' is set to 'Disabled'
# Opposed: We allow installing from Microsoft Store
Set-Service -Name PushToInstall -StartupType Manual -ErrorAction SilentlyContinue

# 81.36	(L2) Ensure 'Windows Remote Management (WS-Management) (WinRM)' is set to 'Disabled'
# Warning: WinRM is utilized by lots of network/device management software.
# We do not use it in our environment and this recommendation has been implemented.
Set-Service -Name WinRM -StartupType Disabled -ErrorAction SilentlyContinue

# 81.37 (L2) Ensure 'WinHTTP Web Proxy Auto-Discovery Service (WinHttpAutoProxySvc)' is set to 'Disabled'
# Opposed: Service startup options can't be configured in latest version of Windows and it breaks network connections if forced through hacks
# Set-Service -Name WinHttpAutoProxySvc -StartupType Manual -ErrorAction SilentlyContinue

# 81.38	(L1) Ensure 'World Wide Web Publishing Service (W3SVC)' is set to 'Disabled' or 'Not Installed'
Set-Service -Name W3SVC -StartupType Disabled -ErrorAction SilentlyContinue

# 81.39	(L1) Ensure 'Xbox Accessory Management Service (XboxGipSvc)' is set to 'Disabled'
Set-Service -Name XboxGipSvc -StartupType Disabled -ErrorAction SilentlyContinue

# 81.40	(L1) Ensure 'Xbox Live Auth Manager (XblAuthManager)' is set to 'Disabled'
Set-Service -Name XblAuthManager -StartupType Disabled -ErrorAction SilentlyContinue

# 81.41	(L1) Ensure 'Xbox Live Game Save (XblGameSave)' is set to 'Disabled'
Set-Service -Name XblGameSave -StartupType Disabled -ErrorAction SilentlyContinue

# 81.42	(L1) Ensure 'Xbox Live Networking Service (XboxNetApiSvc)' is set to 'Disabled'
Set-Service -Name XboxNetApiSvc -StartupType Disabled -ErrorAction SilentlyContinue