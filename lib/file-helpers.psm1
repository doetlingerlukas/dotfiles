function EnsurePath {
  param (
    [String] $path
  )

  if (-not (Test-Path $path)) {
    New-Item -Path $path -ItemType Directory
  }
}