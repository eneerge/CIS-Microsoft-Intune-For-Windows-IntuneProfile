# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Lock Never)"
$intune_policy_description = "Never lock devices (for presentation machines, teleprompters, etc)"
$useDeviceCodeAuth = $false # Set this to $true if you receive permission errors. These errors may occur if your PIM tokens aren't elevated properly after activating a PIM role.

# End Config
############

$module = Get-Module -ListAvailable -Name Microsoft.Graph.DeviceManagement
if ($module) {
    if ($module.Version.major -lt 2 -or $module.Version.minor -lt 26 -or $module.Version.Build -lt 1) {
        write-host -ForegroundColor Yellow -BackgroundColor Black "Microsoft.Graph.DeviceManagement module must be updated..." 
        Update-Module Microsoft.Graph.DeviceManagement -force
    }
} 
else {
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "The Microsoft.Graph.DeviceManagement module is not currently installed, but is required."
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "Module will now be installed."
    Install-Module Microsoft.Graph.DeviceManagement -Scope CurrentUser -Repository PSGallery -force
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Loading Microsoft.Graph.DeviceManagement Module..."
Import-Module Microsoft.Graph.DeviceManagement

Write-Host "Loading configuration..."

$params = @{
  # Windows 10 is still referenced in the odata.type for now
  "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
  supportsScopeTags = $true
  deviceManagementApplicabilityRuleOsEdition = $null
  deviceManagementApplicabilityRuleOsVersion = $null
  deviceManagementApplicabilityRuleDeviceMode = $null
  description = $intune_policy_description
  displayName = $intune_policy_name
  version = 20250312
  omaSettings = @(
    @{
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "26.7 (L1) Ensure 'Device Password Enabled: Max Inactivity Time Device Lock' is set to '15 or fewer minutes, but not 0'"
        "description" = "Opposed. Disabled for this configuration."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/DeviceLock/MaxInactivityTimeDeviceLock"
        "value" = 0
    },
    @{
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "49.8 (L1) Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0'"
        "description" = "Opposed. Timeout will be set to 599940 (max)"
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/LocalPoliciesSecurityOptions/InteractiveLogon_MachineInactivityLimit"
        "value" = 599940
    },
    @{
      "@odata.type" = "#microsoft.graph.omaSettingString"
      "displayName" = "Disable screen saver"
      "description" = "Screensaver will be disabled"
      "omaUri" = "./User/Vendor/MSFT/Policy/Config/ADMX_ControlPanelDisplay/CPL_Personalization_EnableScreenSaver"
      "value" = "<disabled/>"
    },
    @{
      "@odata.type" = "#microsoft.graph.omaSettingString"
      "displayName" = "Disable password protected screen saver"
      "description" = ""
      "omaUri" = "./User/Vendor/MSFT/Policy/Config/ADMX_ControlPanelDisplay/CPL_Personalization_ScreenSaverIsSecure"
      "value" = "<disabled/>"
    },
    @{
      "@odata.type" = "#microsoft.graph.omaSettingString"
      "displayName" = "Set screen saver timeout to high value."
      "description" = "Backup in the event screen saver is enabled"
      "omaUri" = "./User/Vendor/MSFT/Policy/Config/ADMX_ControlPanelDisplay/CPL_Personalization_ScreenSaverTimeOut"
      "value" = "<enabled/><data id=`"ScreenSaverTimeOutFreqSpin`" value=`"9999`"/>"
    }
  )
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Connecting to Microsoft Graph..."
if ($useDeviceCodeAuth -eq $false) {     
  Connect-MgGraph -NoWelcome -ContextScope Process -Scopes "DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All" -ErrorVariable mgConnectError -ErrorAction SilentlyContinue
}
else {
  Connect-MgGraph -NoWelcome  -ContextScope Process -UseDeviceCode -Scopes "DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All" -ErrorVariable mgConnectError -ErrorAction SilentlyContinue
}
if ($mgConnectError) {
    Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR: " $mgConnectError.Exception.Message
    Write-Host -ForegroundColor Cyan -BackgroundColor Black $mgConnectError.Exception.StackTrace
    return 1
}
else {
  Write-Host -ForegroundColor Green -BackgroundColor Black "Connected."
}

$Context = Get-MgContext
if ($null -eq $Context) {
    Write-Host -ForegroundColor Red -BackgroundColor Black "There was an error connecting to Intune."
    return 1
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Writing Config to Intune..."

New-MgDeviceManagementDeviceConfiguration -BodyParameter $params -ErrorVariable newConfigError -ErrorAction SilentlyContinue

if ($newConfigError) {
    Write-Host -ForegroundColor Red -BackgroundColor Black $newConfigError
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "There was an error writing the configuration."
    Write-Host -ForegroundColor Cyan -BackgroundColor Black "Tips: "
    Write-Host -ForegroundColor Cyan -BackgroundColor Black "- Make sure you are authenticating with a user who has Intune permission."
    Write-Host -ForegroundColor Cyan -BackgroundColor Black "- If you are using PIM, be sure to activate the Intune Administrator role."
    Write-Host -ForegroundColor Cyan -BackgroundColor Black "- PIM may be reusing stale cache. Try setting `$useDeviceCodeAuth at the top of this script to `$true"
    Disconnect-MGGraph | Out-Null
    return 1
}
else {
    Write-Host -ForegroundColor Green -BackgroundColor Black "Configuration has been written to Intune. You will need to assign your configuration to groups/devices before it will apply."
}

Disconnect-MGGraph | Out-Null