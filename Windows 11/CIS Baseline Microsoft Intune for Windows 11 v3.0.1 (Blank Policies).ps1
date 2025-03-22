# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Blank Policies)"
$intune_policy_description = "These policies that push a blank value can not be applied properly using OMAURI, so they are applied using an Enpoint Protection Config"

# End Config
############

$module = Get-Module -ListAvailable -Name Microsoft.Graph.Beta.DeviceManagement
if ($module) {
    if ($module.Version.major -lt 2 -or $module.Version.minor -lt 26 -or $module.Version.Build -lt 1) {
        write-host -ForegroundColor Yellow -BackgroundColor Black "Microsoft.Graph.Beta.DeviceManagement module must be updated..." 
        Update-Module Microsoft.Graph.Beta.DeviceManagement -force
    }
} 
else {
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "The Microsoft.Graph.Beta.DeviceManagement module is not currently installed, but is required."
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "The BETA version of the Microsoft Graph DeviceManagement module must be installed due to limitations in the release version."
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "Beta module will now be installed..."
    Install-Module Microsoft.Graph.Beta.DeviceManagement -Scope CurrentUser -Repository PSGallery -force
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Loading Microsoft.Graph.Beta.DeviceManagement Module..."
Import-Module Microsoft.Graph.Beta.DeviceManagement


$params = @{
	"@odata.type" = "#microsoft.graph.windows10EndpointProtectionConfiguration"
	supportsScopeTags = $true
	deviceManagementApplicabilityRuleOsEdition = $null
	deviceManagementApplicabilityRuleOsVersion = $null
	deviceManagementApplicabilityRuleDeviceMode = $null
	description = $intune_policy_description
	displayName = $intune_policy_name
	version = 20250314
    userRightsActAsPartOfTheOperatingSystem = @{
      state = "allowed"
      localUsersOrGroups = @()
    }
    userRightsAccessCredentialManagerAsTrustedCaller = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
    userRightsCreatePermanentSharedObjects = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
    userRightsCreateToken = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
    userRightsDelegation = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
    userRightsLockMemory = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
    userRightsModifyObjectLabels = @{
        state = "allowed"
        localUsersOrGroups = @()
    }
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
  $out = New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $params -ErrorVariable newConfigError -ErrorAction SilentlyContinue
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