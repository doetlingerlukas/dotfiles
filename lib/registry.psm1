function Initialize-Key {
  param (
    [String] $Path
  )

  if (-not (Test-Path $Path)) {
    New-Item -Path $Path -Force | Out-Null
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

function Remove-RegValue {
  param (
    [String] $Path,
    [String] $Name
  )

  try {
    Get-ItemProperty -Path $Path | Select-Object -ExpandProperty $Name -ErrorAction Stop | Out-Null
  } catch {
    return
  }

  Remove-ItemProperty -Path $Path -Name $Name
}
