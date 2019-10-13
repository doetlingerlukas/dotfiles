@powershell -noprofile -command "&{ Set-ExecutionPolicy Bypass -Force }"
@powershell -noprofile -command "&{ start-process powershell -ArgumentList '-noprofile -file %~dp0\main.ps1' -verb RunAs }"