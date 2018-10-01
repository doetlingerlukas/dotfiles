# import modules

Import-Module -Name ($PSScriptRoot + "\settings.psm1")

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
Import-StartLayout -LayoutPath "D:\startlayout.xml" -MountPath "C:\"

"Hiding People icon..."
If (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People")) {
	New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" | Out-Null
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" -Name "PeopleBand" -Type DWord -Value 0


# custom tweaks including privacy settings 

ForEach ($tweak in 
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
) {
  Invoke-Expression $tweak
}

# install chocolatey and other programs

& .\programs.ps1

# wait 30 seconds and restart pc

Start-Sleep 30
Restart-Computer