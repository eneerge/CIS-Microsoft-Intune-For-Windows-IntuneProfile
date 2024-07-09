Import-Module Microsoft.Graph.Beta.DeviceManagement

$params = @{
	"@odata.type" = "#microsoft.graph.windows10EndpointProtectionConfiguration"
	roleScopeTagIds = @(
		"0"
	)
	supportsScopeTags = $true
	deviceManagementApplicabilityRuleOsEdition = $null
	deviceManagementApplicabilityRuleOsVersion = $null
	deviceManagementApplicabilityRuleDeviceMode = $null
	#createdDateTime = [System.DateTime]::Parse("2024-01-24T00:50:40.852939Z")
	description = "Applies Bitlocker/Encryption policy"
	displayName = "aCIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Bitlocker)"
	version = 1
  
  bitLockerAllowStandardUserEncryption = $true                  # Encrypt devices
  bitLockerEnableStorageCardEncryptionOnMobile = $false         # Encrypt storage card (mobile only)
  bitLockerDisableWarningForOtherDiskEncryption = $true         # Warning for other disk encryption
  bitLockerEncryptDevice = $true                                # Allow standard users to enable encryption during Microsoft Entra join
  bitLockerRecoveryPasswordRotation = "enabledForAzureAd"       # Client-driven recovery password rotation
  bitLockerSystemDrivePolicy = @{
    encryptionMethod = "xtsAes128"                              # Encryption for operating system drives
    startupAuthenticationRequired = $true                       # OS Additional authentication at startup
    startupAuthenticationBlockWithoutTpmChip = $true            # BitLocker with non-compatible TPM chip
    startupAuthenticationTpmUsage = "allowed"                   # Compatible TPM startup
    startupAuthenticationTpmPinUsage = "blocked"                # Compatible TPM startup PIN
    startupAuthenticationTpmKeyUsage = "blocked"                # Compatible TPM startup key
    startupAuthenticationTpmPinAndKeyUsage = "blocked"          # Compatible TPM startup key and PIN
    prebootRecoveryEnableMessageAndUrl = $false                 # Pre-boot recovery message and URL
    recoveryOptions = @{
      blockDataRecoveryAgent = $false                           # Data recovery agent
      recoveryPasswordUsage = "allowed"                         # User creation of recovery password
      recoveryKeyUsage = "allowed"                              # User creation of recovery key
      hideRecoveryOptions = $false                              # Recovery options in the BitLocker setup wizard 
      enableRecoveryInformationSaveToStore = $true              # Save BitLocker recovery information to Microsoft Entra ID
      recoveryInformationToStore = "passwordAndKey"             # BitLocker recovery Information stored to Microsoft Entra ID
      enableBitLockerAfterRecoveryInformationToStore = $true    # Store recovery information in Microsoft Entra ID before enabling BitLocker
    }
  }
  bitLockerFixedDrivePolicy = @{
    encryptionMethod = "xtsAes128"                              # Encryption for fixed data-drives
    requireEncryptionForWriteAccess = $false                    # Write access to fixed data-drive not protected by BitLocker
  }
  bitLockerRemovableDrivePolicy = @{
    encryptionMethod = "aesCbc128"                              # Encryption for removable data-drives
    requireEncryptionForWriteAccess = $false                    # Write access to removable data-drive not protected by BitLocker
    blockCrossOrganizationWriteAccess = $false                  # Write access to devices configured in another organization
  }
}

New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $params