"Setting up Battlefield 5 config ..."

$config_dir = "C:\Program Files (x86)\Origin Games\Battlefield V"

New-Item -ItemType Directory -Force -Path $config_dir

$cfg = @"
// fps counter
PerfOverlay.DrawFps 1
"@

$cfg | Out-File -Encoding "UTF8" ($config_dir + "\user.cfg")