# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Non OMA-URI Settings)"
$intune_policy_description = "Implements settings that can't be implemented using OMA-URI."
$useDeviceCodeAuth = $false # Set this to $true if you receive permission errors. These errors may occur if your PIM tokens aren't elevated properly after activating a PIM role.

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

$policyParams = @{
    "name"            = $intune_policy_name
    "description"     = $intune_policy_description
    "platforms"       = "windows10"
    "technologies"    = "mdm"
    "roleScopeTagIds" = @("0")
    "settings"        = @(
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
                "settingDefinitionId" = "device_vendor_msft_dmclient_provider_{providerid}"
                "groupSettingCollectionValue" = @(
                    @{
                        "children" = @(
                            # 15.1 (L1) Ensure 'Config refresh' is set to 'Enabled'
                            @{
                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                                "settingDefinitionId" = "device_vendor_msft_dmclient_provider_{providerid}_configrefresh_enabled"
                                "choiceSettingValue" = @{
                                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                    "value" = "device_vendor_msft_dmclient_provider_{providerid}_configrefresh_enabled_true"
                                    "children" = @()
                                }
                            },
                            # 15.2(L1) Ensure 'Refresh cadence' is set to '90' (or less)
                            @{
                                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingInstance"
                                "settingDefinitionId" = "device_vendor_msft_dmclient_provider_{providerid}_configrefresh_cadence"
                                "simpleSettingValue" = @{
                                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationIntegerSettingValue"
                                    "value" = 90
                                }
                            }
                        )
                    }
                )
            }
        },

        # 49.11 (L1) Ensure 'Interactive logon: Smart card removal behavior' is set to 'Lock Workstation' or higher
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                "settingDefinitionId" = "device_vendor_msft_policy_config_localpoliciessecurityoptions_interactivelogon_smartcardremovalbehavior"
                "choiceSettingValue" = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                    "value" = "device_vendor_msft_policy_config_localpoliciessecurityoptions_interactivelogon_smartcardremovalbehavior_1"
                    "children" = @()
                }
            }
        },

        # 68.4 (L1) Ensure 'Let Apps Activate With Voice Above Lock' is set to 'Enabled: Force Deny'
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                "settingDefinitionId" = "device_vendor_msft_policy_config_privacy_letappsactivatewithvoiceabovelock"
                "choiceSettingValue" = @{
                    "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                    "value" = "device_vendor_msft_policy_config_privacy_letappsactivatewithvoiceabovelock_2"
                    "children" = @()
                }
            }
        },

        # 89.15(L1) Ensure 'Deny Log On As Batch Job' to include 'Guests'
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                "settingDefinitionId" = "device_vendor_msft_policy_config_userrights_denylogonasbatchjob"
                "simpleSettingCollectionValue" = @(
                    @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        "value" = "Guests"
                    }
                )
            }
        },

        # 89.16(L1) Ensure 'Deny Log On As Service Job' to include 'Guests'
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                "settingDefinitionId" = "device_vendor_msft_policy_config_userrights_denylogonasservice"
                "simpleSettingCollectionValue" = @(
                    @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        "value" = "Guests"
                    }
                )
            }
        },

        # 89.34(L1) Ensure 'Shut Down The System' is set to 'Administrators, Users'
        @{
            "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
            "settingInstance" = @{
                "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                "settingDefinitionId" = "device_vendor_msft_policy_config_userrights_shutdownthesystem"
                "simpleSettingCollectionValue" = @(
                    @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        "value" = "Administrators"
                    },
                    @{
                        "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                        "value" = "Users"
                    }
                )
            }
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

Invoke-MgGraphRequest `
    -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies" `
    -Body ($policyParams | ConvertTo-Json -Depth 30) `
    -ContentType "application/json" `
    -ErrorVariable newConfigError `
    -ErrorAction SilentlyContinue

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