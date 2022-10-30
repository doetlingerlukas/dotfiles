function Initialize-Key {
  param (
    [String] $Path
  )

  if (-not (Test-Path $Path)) {
    New-Item -Path $Path
  }
}

function Set-DWord {
  param (
    [String] $Path,
    [String] $Name,
    [int] $Value
  )

  Initialize-Key -Path $Path
  Set-ItemProperty -Path $Path -Name $Name -Type DWord -Value $Value
}

function Remove-Key {
  param (
    [String] $Path
  )

  if (Test-Path $Path) {
    Remove-Item -Path $Path -Recurse
  }
}
