# uninstall all useless default apps
"Uninstalling useless default apps ..."

ForEach ($appId in
  "Microsoft.BingFinance",                      # Bing Finance
  "Microsoft.BingNews",                         # Bing News
  "Microsoft.BingSports",                       # Bing Sports
  "Microsoft.BingWeather",                      # Bing Weather
  "king.com.BubbleWitch3Saga",                  # Bubble Witch 3 Saga
  "king.com.CandyCrushSaga",                    # Candy Crush Saga
  "king.com.CandyCrushSodaSaga",                # Candy Crush Soda Saga
  "*.DisneyMagicKingdoms",                      # Disney Magic Kingdoms
  "*.DragonManiaLegends",                       # Dragon Mania Legends
  "*.Facebook",                                 # Facebook
  "*.HiddenCityMysteryofShadows",               # Hidden City: Mystery of Shadows
  "*.MarchofEmpires",                           # March of Empires
  "GAMELOFTSA.Asphalt8Airborne",                # Asphalt 8 Airborne
  "Microsoft.MinecraftUWP",                     # Minecraft Windows 10 Edition
  "Microsoft.MicrosoftOfficeHub",               # Office and “Get Office365” Notifications
  "flaregamesGmbH.RoyalRevolt2",                # Royal Revolt 2
  "Microsoft.SkypeApp",                         # Skype
  "Microsoft.MicrosoftSolitaireCollection",     # Solitaire 
  "*.SlingTV",                                  # SlingTV
  "Microsoft.Office.Sway",                      # Sway
  "*.Twitter",                                  # Twitter
  "*.Xing",                                     # Xing
  "*.Viber",                                    # Viber
  "Microsoft.ZuneMusic",                        # Zune Music
  "Microsoft.ZuneVideo",                        # Zune Video
  "Microsoft.WindowsPhone"                      # Windows Phone Companion
) {
  Get-AppxPackage "$appId" -AllUsers | Remove-AppxPackage
  Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "$appId" | Remove-AppxProvisionedPackage -Online
}

"Finished uninstalling default apps!"

# ui settings

"Configuring startlayout ..."
Set-ExecutionPolicy Bypass -Scope Process -Force; Import-StartLayout -LayoutPath "D:\startlayout.xml" -MountPath "C:\"

"Hiding Task View button..."
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type DWord -Value 0

"Hiding People icon..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0



# functions to tweak settings 

Function DisableTelemetry {
	Write-Output "Disabling Telemetry..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Application Experience\ProgramDataUpdater" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Autochk\Proxy" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" | Out-Null
}

Function DisableAppSuggestions {
	Write-Output "Disabling Application suggestions..."
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type DWord -Value 0
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value 1
}

Function DisableActivityHistory {
	Write-Output "Disabling Activity History..."
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type DWord -Value 0
}

Function DisableLocationTracking {
	Write-Output "Disabling Location Tracking..."
	If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location")) {
		New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Type String -Value "Deny"
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -Type DWord -Value 0
}

Function DisableFeedback {
	Write-Output "Disabling Feedback..."
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value 0
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type DWord -Value 1
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClient" -ErrorAction SilentlyContinue | Out-Null
	Disable-ScheduledTask -TaskName "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" -ErrorAction SilentlyContinue | Out-Null
}

Function DisableTailoredExperiences {
	Write-Output "Disabling Tailored Experiences..."
	If (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent")) {
		New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Type DWord -Value 1
}

Function DisableAdvertisingID {
	Write-Output "Disabling Advertising ID..."
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value 1
}

Function DisableCortana {
	Write-Output "Disabling Cortana..."
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value 0
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value 1
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value 1
	If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
		New-Item -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value 0
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type DWord -Value 0
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

# custom tweaks including privacy settings 

$tweaks = 
  "DisableTelemetry",                           # disable telemetry (data transmission to microsoft)
  "DisableAppSuggestions",                      # disable app suggestion and automatic installation
  "DisableActivityHistory",                     # disable activity tracking by windows
  "DisableLocationTracking",                    # disable location tracking
  "DisableFeedback",                            # disable automatic feedback
  "DisableTailoredExperiences",                 # disable tailored experience based on diagnostics
  "DisableAdvertisingID",                       # disable custom advertising
  "DisableCortana",                             # disable cortana
  "DisableErrorReporting",                      # disable error reporting to microsoft
  "DisableDiagTrack",                           # disable diagnostics tracking
  "UnpinStartMenuTiles"                         # unpin start menue tiles

ForEach ($tweak in $tweaks) {
  Invoke-Expression $tweak
}

# install chocolatey package manager 
"Installing chocolatey package manager ..."

if ($false -eq $(Test-Path -Path "$env:ProgramData\Chocolatey")) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

"Finished installing chocolatey package manager!"

# install programms using chocolatey
"Installing packages ..."

$Packages = "adobereader", "jdk8", "jdk10", "winrar", "firefox", "notepadplusplus", "git", "intellijidea-ultimate", "nodejs", "yarn"

ForEach ($Package in $Packages) {
    choco install $Package -y
}

"Finished installing packages!"

# wait 30 seconds and restart pc

Start-Sleep 30
Restart-Computer