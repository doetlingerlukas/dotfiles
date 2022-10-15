function IsWindows11() {
  $res = Get-ComputerInfo | Select-Object OsName
  return $res.OsName -like "*Windows 11*"
}

function IsProEdition() {
  $res = Get-ComputerInfo | Select-Object OsName
  return $res.OsName -like "*Pro*"
}
