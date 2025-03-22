# Configuration
$intune_policy_name = "CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Bitlocker)"
$intune_policy_description = "Bitlocker CIS Baseline Policy implemented using OMAURI"

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
  version = 20250314
  omaSettings = @(
    ############################
    # Fixed Drives
    ############################
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "3.11.7.1.1 through 3.11.7.1.8 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled'"
        "description" = "Implemented most. Opposed #3.11.7.1.3, #3.11.7.1.6, and #3.11.7.1.8 because we want to force backing up recovery key and passwords to Entra"
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/FixedDrivesRecoveryOptions"

        # 3.11.7.1.1 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled' 
        "value" = "<enabled/>" +

            # 3.11.7.1.2 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Recovery Key' is set to 'Enabled: Allow 256-bit recovery key' 
            # Opposed: We will require a 256-bit recovery key instead of simply "allowing" one as recommended by CIS
            "<data id=`"FDVRecoveryKeyUsageDropDown_Name`" value=`"1`"/>" +

            # 3.11.7.1.3 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Recovery Password' is set to 'Enabled: Allow 48-digit recovery password' 
            "<data id=`"FDVRecoveryPasswordUsageDropDown_Name`" value=`"2`"/>" +

            # 3.11.7.1.4 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Allow data recovery agent' is set to 'Enabled: True' 
            "<data id=`"FDVAllowDRA_Name`" value=`"true`"/>" +

            # 3.11.7.1.5 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Configure storage of BitLocker recovery information to AD DS' is set to 'Enabled: Backup recovery passwords and key packages' 
            "<data id=`"FDVActiveDirectoryBackupDropDown_Name`" value=`"1`"/>" +

            # 3.11.7.1.6 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for fixed data drives' is set to 'Enabled: False' 
            # Opposed: We do not want to enable Bitlocker until all key informaiton has been backed up to prevent data loss.
            "<data id=`"FDVRequireActiveDirectoryBackup_Name`" value=`"true`"/>" +

            # 3.11.7.1.7 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Omit recovery options from the BitLocker setup wizard' is set to 'Enabled: True' 
            "<data id=`"FDVHideRecoveryPage_Name`" value=`"true`"/>" +

            # 3.11.7.1.8 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Save BitLocker recovery information to AD DS for fixed data drives' is set to 'Enabled: False' 
            # Opposed: We will save the Bitlocker key information in Entra so that recovery can be performed if required
            "<data id=`"FDVActiveDirectoryBackup_Name`" value=`"true`"/>"
    },

    ############################
    # Operating System Drives
    ############################
    @{
         # 3.11.7.2.1 (BL) Ensure 'Allow enhanced PINs for startup' is set to 'Enabled'
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "3.11.7.2.1 (BL) Ensure 'Allow enhanced PINs for startup' is set to 'Enabled'"
        "description" = "Implemented. Opposed. We will accept the risk associated with not having a startup pin, thus enhanced pins will also be disabled."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/SystemDrivesEnhancedPIN"
        "value" = "<enabled/>"
    },
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "3.11.7.2.2 through 3.11.7.2.9 (BL) Ensure 'Choose how BitLocker-protected fixed drives can be recovered' is set to 'Enabled'"
        "description" = "Implemented all except 3.11.7.2.3"
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/SystemDrivesRecoveryOptions"

        # 3.11.7.2.2 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered' is set to 'Enabled' 
        "value" = "<enabled/>" +

            # 3.11.7.2.3 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Recovery Key' is set to 'Enabled: Do not allow 256-bit recovery key' 
            # Opposed: We will require a 256-bit recovery key so data can be recovered from secondary drives
            "<data id=`"OSRecoveryKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 3.11.7.2.4 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Recovery Password' is set to 'Enabled: Require 48-digit recovery password'
            # Opposed: Key is backed up to Azure and we prefer to use a Key for restoration. However, password is still allowed if one wants to create.
            "<data id=`"OSRecoveryPasswordUsageDropDown_Name`" value=`"2`"/>" +

            # 3.11.7.2.5 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Allow data recovery agent' is set to 'Enabled: False' 
            "<data id=`"OSAllowDRA_Name`" value=`"false`"/>" +

            # 3.11.7.2.6 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Configure storage of BitLocker recovery information to AD DS:' is set to 'Enabled: Store recovery passwords and key packages' 
            "<data id=`"OSActiveDirectoryBackupDropDown_Name`" value=`"1`"/>" +

            # 3.11.7.2.7 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Do not enable BitLocker until recovery information is stored to AD DS for operating system drives' is set to 'Enabled: True' 
            "<data id=`"OSRequireActiveDirectoryBackup_Name`" value=`"true`"/>" +

            # 3.11.7.2.8 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Omit recovery options from the BitLocker setup wizard' is set to 'Enabled: True' 
            "<data id=`"OSHideRecoveryPage_Name`" value=`"true`"/>" +

            # 3.11.7.2.9 (BL) Ensure 'Choose how BitLocker-protected operating system drives can be recovered: Save BitLocker recovery information to AD DS for operating system drives' is set to 'Enabled: True' 
            "<data id=`"OSActiveDirectoryBackup_Name`" value=`"true`"/>"
    },
    @{
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "3.11.7.2.10 to 3.11.7.2.15"
        "description" = "Implemented"

        # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#systemdrivesrequirestartupauthentication
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/SystemDrivesRequireStartupAuthentication"

        # 3.11.7.2.10 (BL) Ensure 'Require additional authentication at startup' is set to 'Enabled'
        "value" = "<enabled/>" +

            # 3.11.7.2.11 (BL) Ensure 'Require additional authentication at startup: Allow BitLocker without a compatible TPM' is set to 'Enabled: False'
            "<data id=`"ConfigureNonTPMStartupKeyUsage_Name`" value=`"false`"/>" +

            # 3.11.7.2.12 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup key and PIN:' is set to 'Enabled: Do not allow startup key and PIN with TPM'
            "<data id=`"ConfigureTPMPINKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 3.11.7.2.13 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup key:' is set to 'Enabled: Do not allow startup key with TPM'
            "<data id=`"ConfigureTPMStartupKeyUsageDropDown_Name`" value=`"0`"/>" +

            # 3.11.7.2.14 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup PIN:' is set to 'Enabled: Require startup PIN with TPM'
            # Opposed: No startup pin. We accept the risk of dumping the memory contents. DMA mitigations have been enabled.
            "<data id=`"ConfigurePINUsageDropDown_Name`" value=`"0`"/>" +

            # 3.11.7.2.15 (BL) Ensure 'Require additional authentication at startup: Configure TPM startup:' is set to 'Enabled: Do not allow TPM'
            # Opposed: Will allow encryption using TPM only.
            "<data id=`"ConfigureTPMUsageDropDown_Name`" value=`"1`"/>"
    },
    ############################
    # Removable Drives
    ############################
    @{
         # 3.11.7.3.1 (BL) Ensure 'Deny write access to removable drives not protected by BitLocker' is set to 'Enabled'
         # Opposed: We will allow writing to removable drives that aren't encrypted.
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "3.11.7.3.1 (BL) Ensure 'Deny write access to removable drives not protected by BitLocker' is set to 'Enabled'"
        "description" = "Opposed. Will allow write access to removable drives without encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/RemovableDrivesRequireEncryption"
        "value" = "<disabled/>"
    },
    ############################
    # Non-CIS Configurations
    ############################
    @{
         # Set the encryption method
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#encryptionmethodbydrivetype
        "@odata.type" = "#microsoft.graph.omaSettingString"
        "displayName" = "Set the encryption method for all drive types to Xts-Aes 128"
        "description" = "Set secure encryption methods and trigger the encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/EncryptionMethodByDriveType"
        "value" = "<enabled/>" +
            # OS Drive
            "<data id=`"EncryptionMethodWithXtsOsDropDown_Name`" value=`"6`"/>" +

            # Fixed Drive
            "<data id=`"EncryptionMethodWithXtsFdvDropDown_Name`" value=`"6`"/>" +

            # Removable Drive
            "<data id=`"EncryptionMethodWithXtsRdvDropDown_Name`" value=`"6`"/>"
    },
    @{
         # Allow/Require standard/non-admin user to encrypt after entra join. This makes encryption required and triggers the device to encrypt.
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#allowstandarduserencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Allow standard user encryption"
        "description" = "Allow users with non-admin to complete the Bitlocker encryption."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/AllowStandardUserEncryption"
        "value" = 1
    },
    @{
         # Allow/Require standard/non-admin user to encrypt after entra join. This makes encryption required and triggers the device to encrypt.
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#requiredeviceencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Require Bitlocker Encryption"
        "description" = "Require encryption to be enabled."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/RequireDeviceEncryption"
        "value" = 1
    },
    @{
         # Silently encrypt drives without prompting
         # https://learn.microsoft.com/en-us/windows/client-management/mdm/bitlocker-csp#allowwarningforotherdiskencryption
        "@odata.type" = "#microsoft.graph.omaSettingInteger"
        "displayName" = "Silently encrypt drives without warning."
        "description" = "Silently encryption without warning."
        "omaUri" = "./Device/Vendor/MSFT/BitLocker/AllowWarningForOtherDiskEncryption"
        "value" = 0
    }
  )
}

c
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