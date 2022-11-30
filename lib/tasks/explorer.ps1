# Adapted from: https://github.com/LeDragoX/Win-Debloat-Tools

Import-Module -DisableNameChecking $PSScriptRoot\..\'registry.psm1'

Task explorer {
  Assert-ElevatedPrivileges

  Write-Host 'Configuring Windows Explorer ...'

  $registry_path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer'

  # Hide 'recent' shortcuts.
  Set-DWord -Path $registry_path -Name 'ShowRecent' -Value 0
  Set-DWord -Path $registry_path -Name 'ShowFrequent' -Value 0

  $registry_path_advanced = "$registry_path\Advanced"

  # Lauch explorer to 'This PC'.
  Set-DWord -Path $registry_path_advanced -Name 'LaunchTo' -Value 1

  # Show hidden folders and file extensions.
  Set-DWord -Path $registry_path_advanced -Name 'Hidden'  -Value 1
  Set-DWord -Path $registry_path_advanced -Name 'HideFileExt' -Value 0

  # Show folder merge conflicts.
  Set-DWord -Path $registry_path_advanced -Name 'HideMergeConflicts' -Value 0

  # Show color for encrypted or compressed folders.
  Set-DWord -Path $registry_path_advanced -Name 'ShowEncryptCompressedColor' -Value 0

  # Disable thumbnail cache.
  Set-DWord -Path $registry_path_advanced -Name 'DisableThumbnailCache' -Value 1
  Set-DWord -Path $registry_path_advanced -Name 'DisableThumbsDBOnNetworkFolders' -Value 1

  # Remove 3D objects.
  Remove-Key -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'
  Remove-Key -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}'

  # Show advanced data transfer rates.
  Set-DWord -Path "$registry_path\OperationStatusManager" -Name 'EnthusiastMode' -Value 1

  Write-Host 'Successfully configured Windows Explorer!'
}
