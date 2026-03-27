# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Ameliorations)"
$intune_policy_description = "These settings are not defined in the CIS benchmark, but provide additional hardening/privacy configurations."
$webSignInAllowedUrls = @(
    'https://login.microsoftonline.com'
    'https://login.microsoft.com'
    'https://aadcdn.msftauth.net'
    'https://aadcdn.msauth.net'
    'https://secure.aadcdn.microsoftonline-p.com'
) -join ';'

$useDeviceCodeAuth = $false # Set this to $true if you receive permission errors. These errors may occur if your PIM tokens aren't elevated properly after activating a PIM role.

# End Config
############
Import-Module Microsoft.Graph.Beta.DeviceManagement

$params = @{
  "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
  supportsScopeTags = $true
  deviceManagementApplicabilityRuleOsEdition = $null
  deviceManagementApplicabilityRuleOsVersion = $null
  deviceManagementApplicabilityRuleDeviceMode = $null
  description = "$($intune_policy_description)"
  displayName = "$($intune_policy_name)"
  version = 20260324
  omaSettings = @(
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-search#configuresearchontaskbarmode
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - Appearance In Taskbar"
        "description" = "Show icon only"
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/ConfigureSearchOnTaskbarMode"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-search#donotusewebresults
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - Do Not Use Web Results"
        "description" = "Don't search web in start menu"
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/DoNotUseWebResults"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Search?WT.mc_id=Portal-fx#allowcortanainaad
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - Allow Cortana In AAD"
        "description" = "Disable the Cortana opt-in page during windows setup out of the box experience."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/AllowCortanaInAAD"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Search?WT.mc_id=Portal-fx#preventremotequeries
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - Prevent Remote Queries"
        "description" = "If enabled, clients will be unable to query this computer's index remotely. Thus, when they're browsing network shares that are stored on this computer, they won't search them using the index. If disabled, client search requests will use this computer's index."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/PreventRemoteQueries"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Search?WT.mc_id=Portal-fx#allowusingdiacritics
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - AllowUsingDiacritics"
        "description" = "This policy setting allows words that contain diacritic characters to be treated as separate words."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/AllowUsingDiacritics"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-dnsclient#dns_smartmultihomednameresolution
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "DNS Client - Turn off smart multi-homed name resolution"
        "description" = "Specifies that a multi-homed DNS client should optimize name resolution across networks by sending LLMNR and NetBIOS requests at the same time as normal DNS requests."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/ADMX_DnsClient/DNS_SmartMultiHomedNameResolution"
        "value" = "<disabled/>"
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-desktop#nowindowminimizingshortcuts
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Desktop - Disable Aero Shake"
        "description" = "Prevents windows from (annoyingly) being minimized or restored when the active window is shaken back and forth with the mouse."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/ADMX_Desktop/NoWindowMinimizingShortcuts"
        "value" = "<disabled/>"
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-admx-startmenu?WT.mc_id=Portal-fx#showstartondisplaywithforegroundonwinkey
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Start Menu and Taskbar - Show start menu on the display the user is using."
        "description" = "This policy setting allows the Start screen to appear on the display the user is using when they press the Windows logo key. This setting only applies to users who are using multiple displays."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/ADMX_StartMenu/ShowStartOnDisplayWithForegroundOnWinKey"
        "value" = "<enabled/>"
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-internetexplorer?WT.mc_id=Portal-fx#allowsoftwarewhensignatureisinvalid
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Internet Explorer - Do Not Allow Software When Signature Is Invalid"
        "description" = "This policy setting allows you to manage whether software, such as ActiveX controls and file downloads, can be installed or run by the user even though the signature is invalid."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/InternetExplorer/AllowSoftwareWhenSignatureIsInvalid"
        "value" = "<disabled/>"
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Authentication?WT.mc_id=Portal-fx#allowaadpasswordreset
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Authentication - Allow password reset for Entra user on Windows sign-on screen"
        "description" = "This policy allows the Microsoft Entra tenant administrator to enable the self-service password reset feature on the Windows sign-in screen."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Authentication/AllowAadPasswordReset"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Authentication?WT.mc_id=Portal-fx#enablewebsignin
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Authentication - Allow web sign (Passwordless Support)"
        "description" = "Specifies whether web-based sign-in is allowed for signing in to Windows. Allows for supporting passwordless login via Microsoft Authenticator App."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Authentication/EnableWebSignIn"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Authentication?WT.mc_id=Portal-fx#configurewebsigninallowedurls
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Authentication - Configure which URLs are supported for Web Sign-in (Mitigate CVE-2021-27092)"
        "description" = "Specifies a list of URLs that are navigable in Web Sign-in based authentication scenarios."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Authentication/ConfigureWebSignInAllowedUrls"
        "value" = $webSignInAllowedUrls
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-ControlPolicyConflict?WT.mc_id=Portal-fx#mdmwinsovergp
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Control Policy Conflict - MDM Wins Over Group Policy"
        "description" = "This policy is used to ensure that MDM policy wins over GP when policy is configured on MDM channel."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/ControlPolicyConflict/MDMWinsOverGP"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-dataprotection?WT.mc_id=Portal-fx#allowdirectmemoryaccess
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Data Protection - Block Direct Memory Access When Not Logged In"
        "description" = "This policy setting allows you to block direct memory access (DMA) for all hot pluggable PCI downstream ports until a user logs into Windows."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/DataProtection/AllowDirectMemoryAccess"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Power?WT.mc_id=Portal-fx#selectlidcloseactiononbattery
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Power - When on battery, Hibernate on Laptop Lid Close"
        "description" = "This policy setting specifies the action that Windows takes when a user closes the lid on a mobile PC."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Power/SelectLidCloseActionOnBattery"
        "value" = 2
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Power?WT.mc_id=Portal-fx#selectlidcloseactionpluggedin
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Power - When plugged in, Do Nothing on Laptop Lid Close"
        "description" = "This policy setting specifies the action that Windows takes when a user closes the lid on a mobile PC."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Power/SelectLidCloseActionPluggedIn"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Power?WT.mc_id=Portal-fx#selectlidcloseactionpluggedin
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Time Language Settings - Configure Time Zone to Central Standard Time (CST)"
        "description" = "Specifies the time zone to be applied to the device. This is the standard Windows name for the target time zone."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/TimeLanguageSettings/ConfigureTimeZone"
        "value" = "Central Standard Time"
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Browser?WT.mc_id=Portal-fx#enableextendedbookstelemetry
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Browser - Disable Extended Books Telemetry"
        "description" = "This policy setting lets you decide how much data to send to Microsoft about the book you're reading from the Books tab in Microsoft Edge."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Browser/EnableExtendedBooksTelemetry"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-webthreatdefense#automaticdatacollection
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "AutomaticDataCollection - Submit additional info when detecting suspicious website"
        "description" = "When Enhanced Phishing protection detects enter information on a suspicious website, additional information such as content, sounds, and application memory are sent to Microsoft so research can be conducted to see if it's actually malicious."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/WebThreatDefense/AutomaticDataCollection"
        "value" = 0            # 1 = enabled | 0 = disabled
    },
    
    @{ # This configuration is only valid for Windows Insider and is not currently applicable to production builds of Windows 11
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-windowsai#disableaidataanalysis
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows AI - Disable Windows Recall"
        "description" = "This policy setting allows you to determine whether end users have the option to allow snapshots to be saved on their PCs."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/WindowsAI/DisableAIDataAnalysis"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-windowsai#turnoffwindowscopilot
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows AI - Turn off Copilot"
        "description" = "This policy setting allows you to turn off Windows Copilot."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/WindowsAI/TurnOffWindowsCopilot"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-update#allowmuupdateservice
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Update - Enable Microsoft Update for Apps other then OS"
        "description" = "Allows the IT admin to manage whether to scan for app updates from Microsoft Update."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Update/AllowMUUpdateService"
        "value" = 1
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

New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $params -ErrorVariable newConfigError -ErrorAction SilentlyContinue

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