# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Lock after 5min)"
$intune_policy_description = "Lock devices after 5 minutes of inactivity."

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
        "description" = "Implemented. 300 seconds."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/LocalPoliciesSecurityOptions/InteractiveLogon_MachineInactivityLimit"
        "value" = 300
    }
  )
}

Write-Host "Connecting to Microsoft Graph..."
try {
  Connect-MgGraph -NoWelcome -Scopes "DeviceManagementManagedDevices.Read.All, DeviceManagementManagedDevices.ReadWrite.All, DeviceManagementConfiguration.ReadWrite.All, DeviceManagementConfiguration.Read.All" -ErrorAction Stop
  Write-Host "Connected."
}
catch {
    Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR: " $_.ToString()
    Write-Host -ForegroundColor Red -BackgroundColor Black $_.ScriptStackTrace
}

$Context = Get-MgContext
if ($null -eq $Context) {
    Write-Host -ForegroundColor Red -BackgroundColor Black "There was an error connecting to Intune."
    return 1
}

Write-Host "Writing Config to Intune..."

try {
    $out = New-MgDeviceManagementDeviceConfiguration -BodyParameter $params -ErrorVariable newConfigError -ErrorAction SilentlyContinue
    Write-Host -ForegroundColor Green -BackgroundColor Black "Configuration has been written to Intune. You will need to assign your configuration to groups/devices before it will apply."
    $out
  }
catch {
    Write-Host -ForegroundColor Red -BackgroundColor Black "ERROR: " $_.ToString()
    Write-Host -ForegroundColor Red -BackgroundColor Black $_.ScriptStackTrace
    return 1
}

if ($newConfigError) {
  Write-Host -ForegroundColor Red -BackgroundColor Black $newConfigError
  Write-Host -ForegroundColor Red -BackgroundColor Black "There was an error writing the configuration."
  Write-Host -ForegroundColor Magenta -BackgroundColor Black "Tips: "
  Write-Host -ForegroundColor Magenta -BackgroundColor Black "- Make sure you are authenticating with a user who has Intune permission."
  Write-Host -ForegroundColor Magenta -BackgroundColor Black "- If you are using PIM, be sure to activate the Intune Administrator role."
  Disconnect-MGGraph | Out-Null
  return 1
}

Disconnect-MGGraph | Out-Null