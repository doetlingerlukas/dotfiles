Function DisableNTFSCompression () {
  fsutil behavior set disablecompression 1
}

# functions to tweak settings 
# curtesy of Disassembler0: https://github.com/Disassembler0/Win10-Initial-Setup-Script

Function DisableAppSuggestions {
	Write-Output "Disabling Application suggestions..."
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-314559Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement")) {
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowSuggestedAppsInWindowsInkWorkspace" -Type DWord -Value 0
	# Empty placeholder tile collection in registry cache and restart Start Menu process to reload the cache
	If ([System.Environment]::OSVersion.Version.Build -ge 17134) {
		$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.placeholdertilecollection\Current"
		Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $key.Data[0..15]
		Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction SilentlyContinue
	}}

Function DisableActivityHistory {
	Write-Output "Disabling Activity History..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
}

Function DisableLocationTracking {
	Write-Output "Disabling location services..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocation" -Type DWord -Value 1
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" -Name "DisableLocationScripting" -Type DWord -Value 1
}

Function DisableFeedback {
	Write-Output "Disabling Feedback..."
	If (!(Test-Path "HKCU:\Software\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
}

Function DisableTailoredExperiences {
	Write-Output "Disabling Tailored Experiences..."
	If (!(Test-Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
}

Function DisableAdvertisingID {
	Write-Output "Disabling Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
}

Function DisableErrorReporting {
	Write-Output "Disabling Error reporting..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Windows Error Reporting\QueueReporting" | Out-Null
}

Function DisableDiagTrack {
	Write-Output "Stopping and disabling Diagnostics Tracking Service..."
	Stop-Service "DiagTrack" -WarningAction SilentlyContinue
	Set-Service "DiagTrack" -StartupType Disabled
}

Function UnpinStartMenuTiles {
	Write-Host "Unpinning all Start Menu tiles..."
	$key = Get-ChildItem 'HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\' -recurse | Where-Object {$_ -like  '*$start.tilegrid$windows.data.curatedtilecollection.tilecollection\Current*'}
	Set-ItemProperty -Path $key.pspath -Name Data -Value ([byte[]](0x02,0x00,0x00,0x00,0xcb,0x14,0x19,0x2d,0xa7,0xd0,0xd3,0x01,0x00,0x00,0x00,0x00,0x43,0x42,0x01,0x00,0x0a,0x0a,0x00,0xd0,0x14,0x0c,0xca,0x32,0x00,0xcc,0x8d,0x12,0x06,0x26,0x7b,0x00,0x34,0x00,0x34,0x00,0x41,0x00,0x36,0x00,0x43,0x00,0x37,0x00,0x33,0x00,0x44,0x00,0x2d,0x00,0x39,0x00,0x39,0x00,0x30,0x00,0x30,0x00,0x2d,0x00,0x34,0x00,0x43,0x00,0x30,0x00,0x31,0x00,0x2d,0x00,0x42,0x00,0x42,0x00,0x30,0x00,0x35,0x00,0x2d,0x00,0x33,0x00,0x32,0x00,0x41,0x00,0x36,0x00,0x33,0x00,0x42,0x00,0x33,0x00,0x31,0x00,0x45,0x00,0x46,0x00,0x43,0x00,0x36,0x00,0x7d,0x00,0x26,0x7b,0x00,0x36,0x00,0x34,0x00,0x38,0x00,0x38,0x00,0x42,0x00,0x43,0x00,0x39,0x00,0x35,0x00,0x2d,0x00,0x34,0x00,0x36,0x00,0x36,0x00,0x33,0x00,0x2d,0x00,0x34,0x00,0x35,0x00,0x39,0x00,0x33,0x00,0x2d,0x00,0x42,0x00,0x44,0x00,0x32,0x00,0x33,0x00,0x2d,0x00,0x43,0x00,0x34,0x00,0x45,0x00,0x34,0x00,0x39,0x00,0x38,0x00,0x41,0x00,0x34,0x00,0x41,0x00,0x30,0x00,0x32,0x00,0x32,0x00,0x7d,0x00,0x26,0x7b,0x00,0x37,0x00,0x30,0x00,0x43,0x00,0x39,0x00,0x31,0x00,0x42,0x00,0x34,0x00,0x32,0x00,0x2d,0x00,0x39,0x00,0x38,0x00,0x37,0x00,0x46,0x00,0x2d,0x00,0x34,0x00,0x41,0x00,0x30,0x00,0x34,0x00,0x2d,0x00,0x39,0x00,0x41,0x00,0x33,0x00,0x37,0x00,0x2d,0x00,0x33,0x00,0x35,0x00,0x45,0x00,0x31,0x00,0x44,0x00,0x45,0x00,0x42,0x00,0x36,0x00,0x46,0x00,0x33,0x00,0x34,0x00,0x43,0x00,0x7d,0x00,0x26,0x7b,0x00,0x41,0x00,0x45,0x00,0x34,0x00,0x36,0x00,0x46,0x00,0x31,0x00,0x33,0x00,0x43,0x00,0x2d,0x00,0x36,0x00,0x42,0x00,0x33,0x00,0x31,0x00,0x2d,0x00,0x34,0x00,0x42,0x00,0x37,0x00,0x38,0x00,0x2d,0x00,0x39,0x00,0x33,0x00,0x46,0x00,0x44,0x00,0x2d,0x00,0x43,0x00,0x39,0x00,0x46,0x00,0x38,0x00,0x30,0x00,0x37,0x00,0x32,0x00,0x45,0x00,0x36,0x00,0x39,0x00,0x32,0x00,0x36,0x00,0x7d,0x00,0x26,0x7b,0x00,0x42,0x00,0x38,0x00,0x35,0x00,0x33,0x00,0x39,0x00,0x33,0x00,0x46,0x00,0x42,0x00,0x2d,0x00,0x30,0x00,0x45,0x00,0x35,0x00,0x44,0x00,0x2d,0x00,0x34,0x00,0x32,0x00,0x41,0x00,0x42,0x00,0x2d,0x00,0x41,0x00,0x38,0x00,0x46,0x00,0x31,0x00,0x2d,0x00,0x36,0x00,0x30,0x00,0x41,0x00,0x44,0x00,0x36,0x00,0x30,0x00,0x31,0x00,0x33,0x00,0x42,0x00,0x33,0x00,0x35,0x00,0x35,0x00,0x7d,0x00,0x26,0x7b,0x00,0x43,0x00,0x38,0x00,0x36,0x00,0x32,0x00,0x33,0x00,0x31,0x00,0x36,0x00,0x33,0x00,0x2d,0x00,0x32,0x00,0x35,0x00,0x45,0x00,0x39,0x00,0x2d,0x00,0x34,0x00,0x43,0x00,0x33,0x00,0x44,0x00,0x2d,0x00,0x39,0x00,0x44,0x00,0x34,0x00,0x42,0x00,0x2d,0x00,0x37,0x00,0x36,0x00,0x39,0x00,0x31,0x00,0x31,0x00,0x35,0x00,0x41,0x00,0x44,0x00,0x30,0x00,0x44,0x00,0x32,0x00,0x44,0x00,0x7d,0x00,0xe2,0x2c,0x01,0x01,0x00,0x00)) -Force | Out-Null
}


# Disable Wi-Fi Sense
Function DisableWiFiSense {
	Write-Output "Disabling Wi-Fi Sense..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "WiFISenseAllowed" -Type DWord -Value 0
}