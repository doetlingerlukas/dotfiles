function Initialize-Key {
  param (
    [String] $Path
  )

  if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force
  }
}

function Set-RegValue {
  param (
    [String] $Path,
    [String] $Name,
    $Value
  )

  Initialize-Key -Path $Path

  $Type = $Value.GetType().Name -eq 'String' ? 'String' : 'DWord'
  Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value
}

function Remove-Key {
  param (
    [String] $Path
  )

  if (Test-Path $Path) {
    Remove-Item -Path $Path -Recurse
  }
}
