# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v4.0.0 (Bitlocker)"
$intune_policy_description = "Bitlocker CIS Baseline Policy implemented using OMAURI"
$useDeviceCodeAuth = $false # Set this to $true if you receive permission errors. These errors may occur if your PIM tokens aren't elevated properly after activating a PIM role.

# End Config
##################################

$module = Get-Module -ListAvailable -Name Microsoft.Graph.DeviceManagement
if ($module) {
    if ($module.Version.major -lt 2 -or $module.Version.minor -lt 26 -or $module.Version.Build -lt 1) {
        write-host -ForegroundColor Yellow -BackgroundColor Black "Microsoft.Graph.DeviceManagement module must be updated..." 
        Update-Module Microsoft.Graph.DeviceManagement -force
    }
} 
else {
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "The Microsoft.Graph.DeviceManagement module is not currently installed, but is required."
    Write-Host -ForegroundColor Yellow -BackgroundColor Black "Module will now be installed..."
    Install-Module Microsoft.Graph.DeviceManagement -Scope CurrentUser -Repository PSGallery -force
}

Write-Host -ForegroundColor Cyan -BackgroundColor Black "Loading Microsoft.Graph.DeviceManagement Module..."
Import-Module Microsoft.Graph.DeviceManagement

$params = @{
  "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
  supportsScopeTags = $true
  deviceManagementApplicabilityRuleOsEdition = $null
  deviceManagementApplicabilityRuleOsVersion = $null
  deviceManagementApplicabilityRuleDeviceMode = $null
  description = $intune_policy_description
  displayName = $intune_policy_name
  version = 20260324
  omaSettings = @(
    ############################
    # Fixed Drives 4.11.7.1
    ############################
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "4.11.7.1.1 through 4.11.7.1.8 (BL) Fixed Data Drives"
        "description" = "Implemented most. Opposed #4.11.7.1.2, #4.11.7.1.6, and #4.11.7.1.8 because we want to force backing up recovery key and passwords to Entra"
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/FixedDrivesRecoveryOptions"

        # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#fixeddrivesrecoveryoptions
        # 4.11.7.1.1 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled' 
        "value" = "<enabled/>" +

            # 4.11.7.1.2 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Recovery Key' is set to 'Enabled: Allow 256-bit recovery key' 
            # Opposed: We will -REQUIRE- a 256-bit recovery key instead of simply "allowing" one as recommended by CIS
            "<data id=`"FDVRecoveryKeyUsageDropDown_Name`" value=`"1`"/>" +

            # 4.11.7.1.3 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Recovery Password' is set to 'Enabled: Allow 48-digit recovery password' 
            "<data id=`"FDVRecoveryPasswordUsageDropDown_Name`" value=`"2`"/>" +

            # 4.11.7.1.4 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Allow data recovery agent' is set to 'Enabled: True' 
            "<data id=`"FDVAllowDRA_Name`" value=`"true`"/>" +

            # 4.11.7.1.5 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Configure storage of BitLocker recovery information to AD DS' is set to 'Enabled: Backup recovery passwords and key packages' 
            "<data id=`"FDVActiveDirectoryBackupDropDown_Name`" value=`"1`"/>" +

            # 4.11.7.1.6 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives' is set to 'Enabled: False' 
            # Opposed: We do not want to enable Bitlocker until all key informaiton has been backed up to prevent data loss.
            "<data id=`"FDVRequireActiveDirectoryBackup_Name`" value=`"true`"/>" +

            # 4.11.7.1.7 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Omit recovery options from the BitLocker setup wizard' is set to 'Enabled: True' 
            "<data id=`"FDVHideRecoveryPage_Name`" value=`"true`"/>" +

            # 4.11.7.1.8 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Save BitLocker recovery information to AD DS for fixed data drives' is set to 'Enabled: False' 
            # Opposed: We will save the Bitlocker key information in Entra so that recovery can be performed if required
            "<data id=`"FDVActiveDirectoryBackup_Name`" value=`"true`"/>"
    },

    ############################
    # Operating System Drives 4.11.7.2
    ############################
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "4.11.7.2.1 through 4.11.7.2.8"
        "description" = "Implemented all except 4.11.7.2.2 and 4.11.7.2.3"
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/SystemDrivesRecoveryOptions"

        # 4.11.7.2.1 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered' is set to 'Enabled' 
        "value" = "<enabled/>" +

            # 4.11.7.2.2 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Recovery Key' is set to 'Enabled: Do not allow 256-bit recovery key' 
            # Opposed: We will require a 256-bit recovery key
            "<data id=`"OSRecoveryKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 4.11.7.2.3 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Recovery Password' is set to 'Enabled: Require 48-digit recovery password'
            # Opposed: Key is backed up to Azure and we prefer to use a Key for restoration. However, password is still allowed if user wants to create.
            "<data id=`"OSRecoveryPasswordUsageDropDown_Name`" value=`"2`"/>" +

            # 4.11.7.2.4 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Allow data recovery agent' is set to 'Enabled: False' 
            "<data id=`"OSAllowDRA_Name`" value=`"false`"/>" +

            # 4.11.7.2.5 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Configure storage of BitLocker recovery information to AD DS:' is set to 'Enabled: Store recovery passwords and key packages' 
            "<data id=`"OSActiveDirectoryBackupDropDown_Name`" value=`"1`"/>" +

            # 4.11.7.2.6 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for operating system drives' is set to 'Enabled: True' 
            "<data id=`"OSRequireActiveDirectoryBackup_Name`" value=`"true`"/>" +

            # 4.11.7.2.7 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Omit recovery options from the BitLocker setup wizard' is set to 'Enabled: True' 
            "<data id=`"OSHideRecoveryPage_Name`" value=`"true`"/>" +

            # 4.11.7.2.8 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Save BitLocker recovery information to AD DS for operating system drives' is set to 'Enabled: True' 
            "<data id=`"OSActiveDirectoryBackup_Name`" value=`"true`"/>"
    },
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "4.11.7.2.9 to 4.11.7.2.13"
        "description" = "Implemented"

        # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#systemdrivesrequirestartupauthentication
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/SystemDrivesRequireStartupAuthentication"

        # 4.11.7.2.9 (BL) Ensure 'Require additional authentication at startup' is set to 'Enabled'
        "value" = "<enabled/>" +

            # 3.11.7.2.9 (BL) Ensure 'Require additional authentication at startup: Allow BitLocker without a compatible TPM' is set to 'Enabled: False'
            "<data id=`"ConfigureNonTPMStartupKeyUsage_Name`" value=`"false`"/>" +

            # 4.11.7.2.10 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup key and PIN:' is set to 'Enabled: Do not allow startup key and PIN with TPM'
            "<data id=`"ConfigureTPMPINKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 4.11.7.2.11 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup key:' is set to 'Enabled: Do not allow startup key with TPM'
            "<data id=`"ConfigureTPMStartupKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 4.11.7.2.12 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup PIN:' is set to 'Enabled: Require startup PIN with TPM'
            # Warning: If silent encryption is desired, this setting must be configured to "Do not allow startup PIN with TPM" and an exception to this recommendation will be needed. Please also see recommendation Require additional authentication at startup: Configure TPM startup:' is set to 'Enabled: Do not allow TPM' for needed configuration change for silent encryption.
            # Opposed: No startup pin. We accept the risk of dumping the memory contents. DMA mitigations have been enabled.
            "<data id=`"ConfigurePINUsageDropDown_Name`" value=`"0`"/>" +

            # 4.11.7.2.13 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup:' is set to 'Enabled: Do not allow TPM'
            # Opposed: Will allow encryption using TPM only.
            "<data id=`"ConfigureTPMUsageDropDown_Name`" value=`"1`"/>"
    },
    @{
        # 4.11.7.2.14 (BL) Ensure 'Enforce drive encryption type on operating system drives: Select the encryption type: (Device)' is set to 'Enabled: Used Space Only encryption' or 'Enabled: Full encryption'
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "4.11.7.2.14"
        "description" = "Implemented. Used spaced only encryption."

        # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp?WT.mc_id=Portal-fx#systemdrivesencryptiontype
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/FixedDrivesEncryptionType"
        "value" = "<enabled/><data id=`"FDVEncryptionTypeDropDown_Name`" value=`"2`"/>"
    },
    ############################
    # Removable Drives 4.11.7.3
    ############################
    @{
         # 4.11.7.3.1 (BL) Ensure 'Deny write access to removable drives not protected by BitLocker' is set to 'Enabled'
         # 4.11.7.3.2 (BL) Ensure 'Deny write access to removable drives not protected by BitLocker: Do not allow write access to devices configured in another organization' is set to 'Enabled: False'
         # Opposed: We will allow writing to removable drives that aren't encrypted.
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "4.11.7.3.1 and 4.11.7.3.2 (BL) Ensure 'Deny write access to removable drives not protected by BitLocker' is set to 'Enabled' and (BL) Do not allow write access to devices configured in another organization' is set to 'Enabled: False'"
        "description" = "Opposed. Will allow write access to removable drives without encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/RemovableDrivesRequireEncryption"
        "value" = "<disabled/>"
    },
    ############################
    # Encryption Methods 4.11.7.4 - 4.11.7.6
    ############################
    @{
         # Set the encryption method
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#encryptionmethodbydrivetype
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Set the encryption method for all drive types to Xts-Aes 128"
        "description" = "Set secure encryption methods and trigger the encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/EncryptionMethodByDriveType"
        "value" = "<enabled/>" +
            # Fixed Drive
            # 4.11.7.4 (BL) Ensure 'Choose drive encryption method and cipher strength (Windows 10 [Version 1511] and later): Select the encryption method for fixed data drives' is set to 'XTS-AES 128-bit (default)' or 'XTS-AES 256-bit'
            "<data id=`"EncryptionMethodWithXtsFdvDropDown_Name`" value=`"6`"/>" +

            # OS Drive
            # 4.11.7.5 (BL) Ensure 'Choose drive encryption method and cipher strength (Windows 10 [Version 1511] and later): Select the encryption method for operating system drives' is set to 'XTS-AES 128-bit (default)' or 'XTS-AES 256-bit'
            "<data id=`"EncryptionMethodWithXtsOsDropDown_Name`" value=`"6`"/>" +

            # Removable Drive
            # 4.11.7.6 (BL) Ensure 'Choose drive encryption method and cipher strength (Windows 10 [Version 1511] and later): Select the encryption method for removable data drives' is set to 'XTS-AES 128-bit' or higher
            "<data id=`"EncryptionMethodWithXtsRdvDropDown_Name`" value=`"6`"/>"
    },

    ##########################
    ## Bitlocker Enablement 8.1 - 8.3
    ##########################
    @{
         # Allow/Require standard/non-admin user to encrypt after entra join. This makes encryption required and triggers the device to encrypt.
         # 8.1 (BL) Ensure 'Require Device Encryption' is set to 'Enabled'
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#requiredeviceencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Require Bitlocker Encryption"
        "description" = "Require encryption to be enabled."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryption"
        "value" = 1
    },
    @{
         # Silently encrypt drives without prompting
         # 8.2 (BL) Ensure 'Allow Warning For Other Disk Encryption' is set to 'Disabled'
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#allowwarningforotherdiskencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Silently encrypt drives without warning."
        "description" = "Silently encryption without warning."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/AllowWarningForOtherDiskEncryption"
        "value" = 0
    },
    @{
         # Allow/Require standard/non-admin user to encrypt after entra join. This makes encryption required and triggers the device to encrypt.
         # 8.3 (BL) Ensure 'Allow Warning For Other Disk Encryption: Allow Standard User Encryption' is set to 'Enabled'
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#allowstandarduserencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Allow standard user encryption"
        "description" = "Allow users with non-admin to complete the Bitlocker encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/AllowStandardUserEncryption"
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