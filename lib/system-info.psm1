function IsWindows11() {
  $res = Get-ComputerInfo | Select-Object OsName
  return $res.OsName -like "*Windows 11*"
}

function IsProEdition() {
  $res = Get-ComputerInfo | Select-Object OsName
  return $res.OsName -like "*Pro*"
}

# Assert that task is run with evelated privileges.
# Uses Assert function provided by psake.
function Assert-ElevatedPrivileges() {
  Assert([Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544') 'evelated privileges are required'
}
