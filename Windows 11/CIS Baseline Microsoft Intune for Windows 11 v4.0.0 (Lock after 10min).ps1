# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Lock after 10min)"
$intune_policy_description = "Lock devices after 10 minutes of inactivity."
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
        "displayName" = "45.9 (L1) Ensure 'Interactive logon: Machine inactivity limit' is set to '900 or fewer second(s), but not 0' (Automated)"
        "description" = "Implemented. 600 seconds (10 minutes)"
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/LocalPoliciesSecurityOptions/InteractiveLogon_MachineInactivityLimit"
        "value" = 600
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