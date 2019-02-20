"Setting up Battlefield 5 config ..."

$config_dir = "C:\Program Files (x86)\Origin Games\Battlefield V"

New-Item -ItemType Directory -Force -Path $config_dir

$cfg = @"
// fps counter
PerfOverlay.DrawFps 1

// vsync
RenderDevice.VSyncEnable 0
Render.VSyncFlashTestEnable 0

// disable blur
WorldRender.MotionBlurEnable 0
WorldRender.MotionBlurForceOn 0
WorldRender.MotionBlurFixedShutterTime 0
WorldRender.MotionBlurMax 0
WorldRender.MotionBlurQuality 0
WorldRender.MotionBlurMaxSampleCount 0

// light
WorldRender.SpotLightShadowmapEnable 0
WorldRender.SpotLightShadowmapResolution 32
WorldRender.TransparencyShadowmapsEnable 0
WorldRender.LightTileCsPathEnable 0
WorldRender.FilmicEffectsEnable 0
WorldRender.EmitterSunTransmittanceMapEnable 0
WorldRender.EmitterSunTransmittanceMapResolution 0
WorldRender.PlanarReflectionEnable 0

// post processing
PostProcess.ForceDofEnable 0
PostProcess.SpriteDofEnable 0
PostProcess.SpriteDofHalfResolutionEnable 0
PostProcess.DynamicAOEnable 0
PostProcess.ScreenSpaceRaytraceEnable 0
PostProcess.ScreenSpaceRaytraceDeferredResolveEnable 0
PostProcess.ScreenSpaceRaytraceSeparateCoverageEnable 0
PostProcess.ScreenSpaceRaytraceFullresEnable 0
"@

$cfg | Out-File -Encoding "UTF8" ($config_dir + "\user.cfg")