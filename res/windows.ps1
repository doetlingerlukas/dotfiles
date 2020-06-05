"Configuring windows ..."

# import windows settings
Import-Module -Name ($PSScriptRoot + "\settings.psm1")

"Uninstalling useless default apps ..."

ForEach ($appId in
  "Microsoft.BingFinance",                      # Bing Finance
  "Microsoft.BingNews",                         # Bing News
  "Microsoft.BingSports",                       # Bing Sports
  "Microsoft.BingWeather",                      # Bing Weather
  "Microsoft.GetHelp",                          # Microsoft Get Help
  "Microsoft.Getstarted",                       # Microsoft Get Startet
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
  "Microsoft.WindowsPhone",                     # Windows Phone Companion
  "Microsoft.WindowsFeedbackHub"                # Windows Feedback Hub
) {
  Get-AppxPackage "$appId" -AllUsers | Remove-AppxPackage
  Get-AppXProvisionedPackage -Online | Where-Object DisplayNam -like "$appId" | Remove-AppxProvisionedPackage -Online
}

ForEach ($tweak in
  "UnpinStartMenuTiles",                        # unpin start menue tiles

  "DisableNTFSCompression"                     # disable the builtin NTFS compression
) {
  try {
    Invoke-Expression $tweak
  } catch {
    Write-Host "Failed executing tweak $($tweak) ."
  }
}