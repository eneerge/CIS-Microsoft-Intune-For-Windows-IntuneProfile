# Configuration
$intune_policy_name = "[test] CIS Baseline Microsoft Intune for Windows 11 v4.0.1 (User Rights Policies)"
$intune_policy_description = "These policies apply User Rights Policies mapped to CIS 89.1 to 89.35"

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
	version = 20260323
    #89.1
    userRightsAccessCredentialManagerAsTrustedCaller = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    #89.2
    userRightsAllowAccessFromNetwork = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "Remote Desktop Users"; description = $null; securityIdentifier = $null }
        )
    }
    #89.3
    userRightsActAsPartOfTheOperatingSystem = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    #89.4
    userRightsLocalLogOn = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "Users"; description = $null; securityIdentifier = $null }
        )
    }
    #89.5
    userRightsBackupData = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    #89.6
    userRightsChangeSystemTime = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "LOCAL SERVICE"; description = $null; securityIdentifier = $null }
        )
    }
    #89.7
    userRightsCreateGlobalObjects = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "LOCAL SERVICE"; description = $null; securityIdentifier = $null },
            @{ name = "NETWORK SERVICE"; description = $null; securityIdentifier = $null },
            @{ name = "SERVICE"; description = $null; securityIdentifier = $null }
        )
    }
    #89.8
    userRightsCreatePageFile = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    #89.9
    userRightsCreatePermanentSharedObjects = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    #89.10
    userRightsCreateSymbolicLinks = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.11
    userRightsCreateToken = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    #89.12
    userRightsDebugPrograms = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    #89.13
    userRightsBlockAccessFromNetwork = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "blocked"
        localUsersOrGroups = @(
            @{ name = "Guests"; description = $null; securityIdentifier = $null },
            @{ name = "Local account"; description = $null; securityIdentifier = $null }
        )
    }
    #89.14
    userRightsDenyLocalLogOn = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "blocked"
        localUsersOrGroups = @(
            @{ name = "Guests"; description = $null; securityIdentifier = $null }
        )
    }

    # Missing
    # 89.15 (L1) Ensure 'Deny Log On As Batch Job' to include 'Guests' - There is no configuration option in Intune for this configuration profile type.
    # 89.16 (L1) Ensure 'Deny Log On As Service Job' to include 'Guests' - There is no configuration option in Intune for this configuration profile type.
    # 89.17
    userRightsRemoteDesktopServicesLogOn = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "blocked"
        localUsersOrGroups = @(
            @{ name = "Guests"; description = $null; securityIdentifier = $null },
            @{ name = "Local account"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.18
    userRightsDelegation = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    # 89.19
    userRightsGenerateSecurityAudits = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "LOCAL SERVICE"; description = $null; securityIdentifier = $null },
            @{ name = "NETWORK SERVICE"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.20
    userRightsImpersonateClient = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "LOCAL SERVICE"; description = $null; securityIdentifier = $null },
            @{ name = "NETWORK SERVICE"; description = $null; securityIdentifier = $null },
            @{ name = "SERVICE"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.21
    userRightsIncreaseSchedulingPriority = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null },
            @{ name = "Window Manager\Window Manager Group"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.22
    userRightsLoadUnloadDrivers = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.23
    userRightsLockMemory = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    # 89.24 (L2) Ensure 'Log On As Batch Job' is set to 'Administrators' - There is no configuration option in Intune for this configuration profile type.

    # 89.25
    userRightsManageAuditingAndSecurityLogs = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.26
    userRightsManageVolumes = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.27
    userRightsModifyFirmwareEnvironment = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.28
    userRightsModifyObjectLabels = @{
        "@odata.type"     = "#microsoft.graph.deviceManagementUserRightsSetting"
        state             = "allowed"
        localUsersOrGroups = @()
    }
    # 89.29
    userRightsProfileSingleProcess = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.30(L1) Ensure 'Profile System Performance' is set to 'Administrators, NT SERVICE\WdiServiceHost' - There is no configuration option in Intune for this configuration profile type.

    # 89.31
    userRightsRemoteShutdown = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }
    # 89.32(L1) Ensure 'Replace Process Level Token' is set to 'LOCAL SERVICE, NETWORK SERVICE' - There is no configuration option in Intune for this configuration profile type.

    # 89.33
    userRightsRestoreData = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
    }

    # 89.34(L1) Ensure 'Shut Down The System' is set to 'Administrators, Users' - There is no configuration option in Intune for this configuration profile type.

    # 89.35
    userRightsTakeOwnership = @{
        "@odata.type" = "#microsoft.graph.deviceManagementUserRightsSetting"
        state         = "allowed"
        localUsersOrGroups = @(
            @{ name = "Administrators"; description = $null; securityIdentifier = $null }
        )
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