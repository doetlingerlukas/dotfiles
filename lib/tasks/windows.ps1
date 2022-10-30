# Adapted from: https://github.com/LeDragoX/Win-Debloat-Tools

Import-Module -DisableNameChecking $PSScriptRoot\..\'registry.psm1'

Task windows -Depends ui {
   # Assert that task is run with evelated privileges
   Assert([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') 'evelated privileges are required'

  Write-Host 'Configuring Windows ...'

  # Disable Cortana.
  $path_cortana = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
  $path_cortana_user = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search'
  Set-DWord -Path $path_cortana -Name 'AllowCortana' -Value 0
  Set-DWord -Path $path_cortana -Name 'AllowCloudSearch' -Value 0
  Set-DWord -Path $path_cortana -Name 'ConnectedSearchUseWeb' -Value 0
  Set-DWord -Path $path_cortana -Name 'DisableWebSearch' -Value 1
  Set-DWord -Path $path_cortana_user -Name 'BingSearchEnabled' -Value 0
  Set-DWord -Path $path_cortana_user -Name 'CortanaConsent' -Value 0

  # Disable app suggestions.
  @(
    'ContentDeliveryAllowed'
    'FeatureManagementEnabled'
    'OemPreInstalledAppsEnabled'
    'PreInstalledAppsEnabled'
    'PreInstalledAppsEverEnabled'
    'RemediationRequired'
    'RotatingLockScreenEnabled'
    'RotatingLockScreenOverlayEnabled'
    'SilentInstalledAppsEnabled'
    'SoftLandingEnabled'
    'SubscribedContent-310093Enabled'
    'SubscribedContent-314559Enabled'
    'SubscribedContent-314563Enabled'
    'SubscribedContent-338387Enabled'
    'SubscribedContent-338388Enabled'
    'SubscribedContent-338389Enabled'
    'SubscribedContent-338393Enabled'
    'SubscribedContent-353698Enabled'
    'SubscribedContentEnabled'
    'SystemPaneSuggestionsEnabled'
  ) | foreach {
    Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager' -Name $_ -Value 0
  }

  # Disable online speech privacy.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy' -Name 'HasAccepted' -Value 0

  # Disable input personalization.
  Set-DWord -Path 'HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization' -Name 'AllowInputPersonalization' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore' -Name 'HarvestContacts' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitInkCollection' -Value 1
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\InputPersonalization' -Name 'RestrictImplicitTextCollection' -Value 1
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Personalization\Settings' -Name 'AcceptedPrivacyPolicy' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Input\TIPC' -Name 'Enabled' -Value 0
  Set-DWord -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput' -Name 'AllowLinguisticDataCollection' -Value 0


  Write-Host 'Disabling location tracking ...'

  Write-Host 'Disabling app permissions ...'
  # location
  Set-DWord -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny'
  Set-DWord -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location' -Name 'Value' -Value 'Deny'
  Set-DWord -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}' -Name 'SensorPermissionState' -Value 0
  Set-DWord -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration' -Name 'EnableStatus' -Value 0
  # app diagnostics
  Set-DWord -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny'
  Set-DWord -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics' -Name 'Value' -Value 'Deny'
  # account info
  Set-DWord -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny'
  Set-DWord -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation' -Name 'Value' -Value 'Deny'

  # Disable tailored experience.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy' -Name 'TailoredExperiencesWithDiagnosticDataEnabled' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableTailoredExperiencesWithDiagnosticData' -Value 1

  # Disable third party suggestions in spotlight.
  Set-DWord -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableThirdPartySuggestions' -Value 1
  Set-DWord -Path 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent' -Name 'DisableWindowsConsumerFeatures' -Value 1

  # Disable activity history.
  $path_activity_history = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
  Set-DWord -Path $path_activity_history -Name 'EnableActivityFeed' -Value 0
  Set-DWord -Path $path_activity_history -Name 'PublishUserActivities' -Value 0
  Set-DWord -Path $path_activity_history -Name 'UploadUserActivities' -Value 0

  # Disable clipboard history.
  Set-DWord -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'AllowClipboardHistory' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Clipboard' -Name 'EnableClipboardHistory' -Value 0

  # Disable advertising ID.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo' -Name 'Enabled' -Value 0
  Set-DWord -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1

  # Disable Xbox Game Bar DVR.
  Set-DWord -Path 'HKLM:\SOFTWARE\Microsoft\PolicyManager\default\ApplicationManagement\AllowGameDVR' -Name 'value' -Value 0
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0
  Set-DWord -Path 'HKCU:\System\GameConfigStore' -Name 'GameDVR_Enabled' -Value 0
  Set-DWord -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0

  Write-Host 'Windows configurations successful!'
}

Task ui {
  Write-Host 'Configuring Windows UI ...'

  # Show only search icon in taskbar.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Value 0

  # Disable news and interests.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds' -Name 'ShellFeedsTaskbarOpenOnHover' -Value 0
  Set-DWord -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds' -Name 'EnableFeeds' -Value 0

  # Hide people icon.
  $explorer_path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
  Set-DWord -Path "$explorer_path\People" -Name 'PeopleBand' -Value 0

  # Hide meet now icon.
  Set-DWord -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'HideSCAMeetNow'-Value 1

  # Hide widgets icon.
  Set-DWord -Path $explorer_path -Name 'TaskbarDa' -Value 0

  # Hide chat icon.
  Set-DWord -Path $explorer_path -Name 'TaskbarMn' -Value 0

  # Disable Edge multi tabs showing on ALT + TAB.
  Set-DWord -Path $explorer_path -Name 'MultiTaskingAltTabFilter' -Value 3

  # Enable taskbar transparency.
  Set-DWord -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize' -Name 'EnableTransparency' -Value 1

  Write-Host 'Windows UI configured successfully.'
}
