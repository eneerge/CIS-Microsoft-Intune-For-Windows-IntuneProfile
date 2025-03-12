Import-Module Microsoft.Graph.Beta.DeviceManagement
Connect-MgGraph
$params = @{
	"@odata.type" = "#microsoft.graph.windows10EndpointProtectionConfiguration"
	roleScopeTagIds = @(
		"0"
	)
	supportsScopeTags = $true
	deviceManagementApplicabilityRuleOsEdition = $null
	deviceManagementApplicabilityRuleOsVersion = $null
	deviceManagementApplicabilityRuleDeviceMode = $null
	createdDateTime = [System.DateTime]::Parse("2024-01-24T00:50:40.852939Z")
	description = "These policies that push a blank value can not be applied properly using OMAURI, so they are applied using an Enpoint Protection Config"
	displayName = "CIS Baseline Microsoft Intune for Windows 11 v3.0.1 (Blank Policies)"
	version = 2
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

New-MgBetaDeviceManagementDeviceConfiguration -BodyParameter $params
