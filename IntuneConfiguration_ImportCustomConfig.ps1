Write-Host "------------------------------------------------------"
Write-Host "Checking for Microsoft Graph module..."
$modAvailable = Get-Module -Name "Microsoft.Graph" -ListAvailable

if ($null -eq $modAvailable) {
    Write-Host "Not Found."
    Write-Host "Microsoft Graph Powershell Module is not installed. Would you like to install it? (y/n): " -ForegroundColor Yellow
    $prompt = Read-Host

    if ($prompt.ToUpper() -eq "Y" -or $prompt.ToUpper() -eq "YES") {
        Write-Host "Installing for current user..."
        Install-Module Microsoft.Graph -Scope CurrentUser -Force
    }

    else {
        Write-Host "Script cannot continue, because Microsoft.Graph PowerShell Module is Not Installed." -ForegroundColor Red
        exit 1;
    }
}

# Read Input JSON File
Write-Host "Enter the full path to the JSON configuration file: " -ForegroundColor Yellow
$jsonPath = Read-Host
$jsonPath = $jsonPath.Trim()
$jsonPath = $jsonPath.replace('"','')
if($jsonPath.Length -eq 0 -or !(Test-Path "$jsonPath")){
  Write-Host "Path for JSON file doesn't exist..." -ForegroundColor Red
  Write-Host "Script can't continue..." -ForegroundColor Red
  Write-Host
  break
}
$jsonData = gc $jsonPath
$jsonDataClean = $jsonData | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty id,createdDateTime,lastModifiedDateTime,version,supportsScopeTags
$DisplayName = $jsonDataClean.displayName
write-host "Device Configuration Policy " -NoNewLine -ForegroundColor Yellow
write-host $DisplayName -NoNewline -ForegroundColor Green
write-host " Found..." -ForegroundColor Yellow

# Login with access to write device configurations
Write-Host "Logging in..."
$login = Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All" -ErrorAction SilentlyContinue

if ($null -eq $login) {
    Write-Host "Unable to login." -ForegroundColor Red
    $Error[$Error.Count-1]
    exit 1
}

# Create the New Custom Oma Configuration
Write-Host "Creating New Intune configuration profile..."
$NewConfig = @{
  DisplayName = $DisplayName
  AdditionalProperties = @{
    '@odata.type'              = '#microsoft.graph.windows10CustomConfiguration'
    'omaSettings' = @()
  }
}
foreach ($setting in $jsonDataClean.omaSettings) {
    $config = @{
        "@odata.type" =  $setting.'@odata.type'
        "displayName" = $setting.displayName
        "description" =  $setting.description
        "omaUri"      =  $setting.omaUri
        "value"       =  $setting.value
    }
    $newConfig.AdditionalProperties.omaSettings += $config
}

$intuneConfig = New-MgDeviceManagementDeviceConfiguration @NewConfig