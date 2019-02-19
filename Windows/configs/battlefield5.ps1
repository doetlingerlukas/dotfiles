"Setting up Battlefield 5 config ..."

$config_dir = "C:\Program Files (x86)\Origin Games\Battlefield V"

New-Item -ItemType Directory -Force -Path $config_dir

$cfg = @"
// fps counter
PerfOverlay.DrawFps 1

// disable blur
WorldRender.MotionBlurEnable 0
WorldRender.MotionBlurForceOn 0
WorldRender.MotionBlurFixedShutterTime 0
WorldRender.MotionBlurMax 0
WorldRender.MotionBlurQuality 0
WorldRender.MotionBlurMaxSampleCount 0
"@

$cfg | Out-File -Encoding "UTF8" ($config_dir + "\user.cfg")