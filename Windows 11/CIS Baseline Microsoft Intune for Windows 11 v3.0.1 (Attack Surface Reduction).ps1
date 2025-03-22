# Configuration
$intune_policy_name = "[testing] CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Attack Surface Reduction CIS 21.7)"
$intune_policy_description = "Enable and Configure ASR rules to comply with CIS 21.7"

# ASR Configurations
####################
# https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference#asr-rule-to-guid-matrix
# NOTE: Some features of ASR rules require the cloud-protection to be set to HIGH. See https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference#per-asr-rule-alert-and-notification-details
# Valid options are:   
# - "off" - Protection Off
# - "block" - Action will be blocked and logged
# - "audit" - Action will be logged, but will NOT be blocked (useful when researching environment before setting to block)
# - "warn" - User will be warned about the action and can allow via the prompt. Any action allowed will only be allowed for 24 hours. This is not a valid option for some rules. 

# CIS 21.7 Recommended
$block_vuln_drivers = "block"            # Block abuse of exploited vulnerable signed drivers	56a863a9-875e-4185-98a7-b882c64b5ce5
$block_adobe_child = "block"             # Block Adobe Reader from creating child processes	7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c
$block_office_child = "block"            # Block all Office applications from creating child processes	d4f940ab-401b-4efc-aadc-ad5f3c50688a
$block_cred_stealing_lsass = "block"     # Block credential stealing from the Windows local security authority subsystem (lsass.exe)	9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2
$block_executable_email = "block"        # Block executable content from email client and webmail	be9ba2d9-53ea-4cdc-84e5-9b1eeee46550
$block_obfuscated_scripts = "block"      # (Requires Cloud Protection Enabled) Block execution of potentially obfuscated scripts	5beb7efe-fd9a-4556-801d-275e5ffc04cc
$block_executable_scripts = "block"      # (Does NOT support "warn" option) Block JavaScript or VBScript from launching downloaded executable content	d3e037e1-3eb8-44c8-a917-57927947596d
$block_executable_office = "block"       # Block Office applications from creating executable content	3b576869-a4ec-4529-8536-b80a7769e899
$block_injecting_office = "block"        # Block Office applications from injecting code into other processes	75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84
$block_office_comms_child = "warn"       # (Opposed: Unable to open web links in Outlook when this is enabled) Block Office communication application from creating child processes	26190899-1602-49e8-8b27-eb1d0a1ce869
$block_wmi_persistence = "block"         # (Does NOT support "warn" option) Block persistence through WMI event subscription  e6db77e5-3df2-4cf1-b95a-636979351e5b **** NOTE: File and folder exclusions not supported.	
$block_untrusted_usb_processes = "block" # Block untrusted and unsigned processes that run from USB	b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4
$block_apis_from_office_macros = "audit" # (Opposed: Can cause issues with Office Apps) Block Win32 API calls from Office macros.	92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b

# Additional Hardening - Not Officially Documented/Recommended by CIS
$block_prevalence = "block" # (Requires Cloud Protection Enabled) Block executable files from running unless they meet a prevalence, age, or trusted list criterion (List managed by Microsoft)	01443614-cd74-433a-b99e-2ecdc07bfc25
$block_wmi_psexec_processes = "block" # Block process creations originating from PSExec and WMI commands	d1e49aac-8f56-4280-b9ba-993a6d77406c
$block_safe_mode = "off" # Block rebooting machine in Safe Mode (preview)	33ddedf1-c6e0-47cb-833e-de6133960387
$block_fake_system_tools = "audit" # (Observed issues opening legitimate tools in some cases) Block use of copied or impersonated system tools (preview)	c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb
$block_webshells = "block" # Block Webshell creation for Servers	a8f5898e-1dc8-49a9-9878-85004b8a61e6
$block_advanced_ransomware = "block" # (Requires Cloud Protection Enabled, Does NOT support "warn" option) Use advanced protection against ransomware	c1db55ab-c21a-4637-bb3f-a12568109d35

# Add global exclusions for Attack Surface Reduction (recommended)
# Exclusions will ensure compatibility with known software in the environment. Failure to add exclusion could potentially result in blocking legitimate software.
# NOTE: This will set the exclusion for every ASR rule. For more granular control (allow an exclusion for a specific ASR rule), you will need to either modify 
#       in Intune after importing, or update the $params in the code below.
# Reference: https://learn.microsoft.com/en-us/defender-endpoint/configure-extension-file-exclusions-microsoft-defender-antivirus
$global_asr_exclusions = @(
  "C:\Program Files\Microsoft EPM Agent\EPMClient"  
  ,"C:\Program Files\Windows Defender Advanced Threat Protection"
  ,"C:\Program Files\Tenable\Nessus Agent"
  ,"C:\Program Files (x86)\Adobe\Acrobat 2020"
  ,"C:\Program Files (x86)\Adobe\Acrobat 2020\Acrobat\AcroCEF\AcroCEF.exe"
  ,"C:\Program Files (x86)\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"
  ,"C:\Program Files (x86)\Solarwinds Discovery Agent"
  ,"C:\windows\system32\wbem\WmiPrvSE.exe"
)

# End Config
############

# Params
###########
$params = @{
  name = "$($intune_policy_name)"
  description = "$($intune_policy_description)"
  settings = @(
      @{
          "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSetting"
          settingInstance = @{
              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationGroupSettingCollectionInstance"
              groupSettingCollectionValue = @(
                  @{
                      children = @(
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  # Uncomment to set up a rule-specific exclusion
                                  # children = @(
                                  #     @{
                                  #         "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
                                  #         settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts_perruleexclusions"
                                  #         simpleSettingCollectionValue = @(
                                  #             @{
                                  #                 "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
                                  #                 value = "C:\exclusion.exe"
                                  #             }
                                  #         )
                                  #     }
                                  # )
                                  settingValueTemplateReference = @{
                                      settingValueTemplateId = "8b17ebce-496f-4b58-9d89-dd1c3861de39"
                                  }
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts_$($block_obfuscated_scripts)"
                              }
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutionofpotentiallyobfuscatedscripts"
                              settingInstanceTemplateReference = @{
                                  settingInstanceTemplateId = "e416083e-05e3-4237-b8ec-a6ad49c4571e"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwin32apicallsfromofficemacros_$($block_apis_from_office_macros)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablefilesrunningunlesstheymeetprevalenceagetrustedlistcriterion_$($block_prevalence)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficecommunicationappfromcreatingchildprocesses"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficecommunicationappfromcreatingchildprocesses_$($block_office_comms_child)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockallofficeapplicationsfromcreatingchildprocesses_$($block_office_child)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockjavascriptorvbscriptfromlaunchingdownloadedexecutablecontent"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockjavascriptorvbscriptfromlaunchingdownloadedexecutablecontent_$($block_executable_scripts)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuntrustedunsignedprocessesthatrunfromusb"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuntrustedunsignedprocessesthatrunfromusb_$($block_untrusted_usb_processes)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockadobereaderfromcreatingchildprocesses_$($block_adobe_child)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockcredentialstealingfromwindowslocalsecurityauthoritysubsystem_$($block_cred_stealing_lsass)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwebshellcreationforservers"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockwebshellcreationforservers_$($block_webshells)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockabuseofexploitedvulnerablesigneddrivers"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockabuseofexploitedvulnerablesigneddrivers_$($block_vuln_drivers)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockpersistencethroughwmieventsubscription"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockpersistencethroughwmieventsubscription_$($block_wmi_persistence)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuseofcopiedorimpersonatedsystemtools"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockuseofcopiedorimpersonatedsystemtools_$($block_fake_system_tools)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfrominjectingcodeintootherprocesses"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfrominjectingcodeintootherprocesses_$($block_injecting_office)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_useadvancedprotectionagainstransomware_$($block_advanced_ransomware)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockprocesscreationsfrompsexecandwmicommands"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockprocesscreationsfrompsexecandwmicommands_$($block_wmi_psexec_processes)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfromcreatingexecutablecontent"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockofficeapplicationsfromcreatingexecutablecontent_$($block_executable_office)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockrebootingmachineinsafemode"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockrebootingmachineinsafemode_$($block_safe_mode)"
                              }
                          },
                          @{
                              "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance"
                              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablecontentfromemailclientandwebmail"
                              choiceSettingValue = @{
                                  "@odata.type" = "#microsoft.graph.deviceManagementConfigurationChoiceSettingValue"
                                  children = @()
                                  value = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules_blockexecutablecontentfromemailclientandwebmail_$($block_executable_email)"
                              }
                          }
                      )
                  }
              )
              settingInstanceTemplateReference = @{
                  settingInstanceTemplateId = "19600663-e264-4c02-8f55-f2983216d6d7"
              }
              settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductionrules"
          }
      }
  )
  platforms = "windows10"
  technologies = "mdm,microsoftSense"
  templateReference = @{
      templateId = "e8c053d6-9f95-42b1-a7f1-ebfd71c67a4b_1"
  }
}
############

# Exclusion Params
##################
$addlParams = @();
if ($global_asr_exclusions -and $global_asr_exclusions.Count -gt 0) {
  $addlParams += @{
      settingInstance = @{
          "@odata.type" = "#microsoft.graph.deviceManagementConfigurationSimpleSettingCollectionInstance"
          settingDefinitionId = "device_vendor_msft_policy_config_defender_attacksurfacereductiononlyexclusions"
          settingInstanceTemplateReference = @{
              settingInstanceTemplateId = "0eaea6bb-736e-44ed-a450-b2ef5bea1377"
          }
          simpleSettingCollectionValue = @()
      }
    }

  foreach ($excl in $global_asr_exclusions) {
    $addlParams.settingInstance.simpleSettingCollectionValue += @{
      "@odata.type" = "#microsoft.graph.deviceManagementConfigurationStringSettingValue"
      value = "$($excl)"
    }
  }

  $params.settings += $addlParams
}
###########

# Validate options
$invalidInput = get-variable "block_*" | where-object -Property Value -NotIn @("off","block","audit","warn")
if ($invalidInput) {
  Write-Host -ForegroundColor Red -BackgroundColor Black "Error: Invalid value set for ASR configuration. It must be off, block, audit, or warn"
  $invalidInput
  return 1
}

$module = Get-Module -ListAvailable -Name Microsoft.Graph.Beta.DeviceManagement
if ($module) {
    if ($module.Version.major -lt 2 -or $module.Version.minor -lt 26 -or $module.Version.Build -lt 1) {
        write-host -ForegroundColor Yellow -BackgroundColor Black "Microsoft.Graph.Beta.DeviceManagement module must be updated..." 
        Update-Module Microsoft.Graph.Beta.DeviceManagement -force
    }
} 
else {
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "The Microsoft.Graph.Beta.DeviceManagement module is not currently installed, but is required."
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "Module will now be installed."
    Install-Module Microsoft.Graph.Beta.DeviceManagement -Scope CurrentUser -Repository PSGallery -force
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Loading Microsoft.Graph.Beta.DeviceManagement Module..."
Import-Module Microsoft.Graph.Beta.DeviceManagement
Import-Module Microsoft.Graph.Authentication

Write-Host "Loading configuration..."
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
    # This URL is what Intune itself uses. There is no non-beta endpoint available.
    $uri = "https://graph.microsoft.com/beta/deviceManagement/configurationPolicies"
    $config  = Invoke-MgGraphRequest -Uri $uri -Method Post -Body ($params | ConvertTo-Json -Depth 100)
    Write-Host -ForegroundColor Green -BackgroundColor Black "Configuration has been written to Intune. You will need to assign your configuration to groups/devices before it will apply."
    $config
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