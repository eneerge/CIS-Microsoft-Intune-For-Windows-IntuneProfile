Import-Module Microsoft.Graph.Beta.DeviceManagement
$tenant_id = "" #Read-Host " "
$webSignInAllowedUrls = "mydomain.com" # separate each url with a semicolon

if ($tenant_id -eq "") {
  Write-Host "Please configure your Azure tenant id."
  return 1
}


$params = @{
  "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
  roleScopeTagIds = @(
    "0"
  )
  supportsScopeTags = $true
  deviceManagementApplicabilityRuleOsEdition = $null
  deviceManagementApplicabilityRuleOsVersion = $null
  deviceManagementApplicabilityRuleDeviceMode = $null
  description = "These settings are not defined in the CIS benchmark, but provide additional hardening/privacy configurations."
  displayName = "CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Ameliorations)"
  version = 1
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
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Search?WT.mc_id=Portal-fx#allowusingdiacritics
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Search - Prevent Remote Queries"
        "description" = "If enabled, clients will be unable to query this computer's index remotely. Thus, when they're browsing network shares that are stored on this computer, they won't search them using the index. If disabled, client search requests will use this computer's index."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Search/PreventRemoteQueries"
        "value" = 0
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
        "description" = "Prevents windows from being minimized or restored when the active window is shaken back and forth with the mouse."
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
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Browser?WT.mc_id=Portal-fx#configuretelemetryformicrosoft365analytics
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Browser - Configure Telemetry For Microsoft 365 Analytics to 'No data collected or sent'"
        "description" = "If disabled or not configured, Microsoft Edge doesn't send browsing history data to Desktop Analytics."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Browser/ConfigureTelemetryForMicrosoft365Analytics"
        "value" = 0
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-Browser?WT.mc_id=Portal-fx#enableextendedbookstelemetry
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Browser - Disable Extended Books Telemetry"
        "description" = "This policy setting lets you decide how much data to send to Microsoft about the book you're reading from the Books tab in Microsoft Edge."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Browser/EnableExtendedBooksTelemetry"
        "value" = 0
    },
    <#@{ # This configuration is only valid for Windows Insider and is not currently applicable to production builds of Windows 11
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-windowsai#disableaidataanalysis
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows AI - Disable Windows Recall"
        "description" = "This policy setting allows you to determine whether end users have the option to allow snapshots to be saved on their PCs."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/WindowsAI/DisableAIDataAnalysis"
        "value" = 1
    },#>
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-windowsai#disableaidataanalysis
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows AI - Turn off Copilot"
        "description" = "This policy setting allows you to turn off Windows Copilot."
        "omaUri" = "./User/Vendor/MSFT/Policy/Config/WindowsAI/TurnOffWindowsCopilot"
        "value" = 1
    },
    @{
        # https://learn.microsoft.com/en-us/windows/client-management/mdm/policy-csp-experience#configurechaticon
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Windows Taskbar - Hide Chat Icon"
        "description" = "This policy setting allows you to configure the Chat icon on the taskbar."
        "omaUri" = "./Device/Vendor/MSFT/Policy/Config/Experience/ConfigureChatIcon"
        "value" = 2
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

Connect-MgGraph
New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $params
