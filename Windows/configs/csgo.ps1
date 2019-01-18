"Setting up CS:GO config ..."

$config_dir_user1 = "C:\Program Files (x86)\Steam\userdata\136275020\730\local\cfg"
$config_dir_user2 = "C:\Program Files (x86)\Steam\userdata\241388330\730\local\cfg"

New-Item -ItemType Directory -Force -Path $config_dir_user1
New-Item -ItemType Directory -Force -Path $config_dir_user2

$autoexec = @"
// Crosshair
cl_crosshair_drawoutline "0"
cl_crosshair_outlinethickness "0.100000"
cl_crosshair_sniper_show_normal_inaccuracy "0"
cl_crosshair_sniper_width "1"
cl_crosshair_t "0"
cl_crosshairalpha "255"
cl_crosshaircolor "5"
cl_crosshaircolor_b "36"
cl_crosshaircolor_g "0"
cl_crosshaircolor_r "255"
cl_crosshairdot "0"
cl_crosshairgap "-2"
cl_crosshairgap_useweaponvalue "0"
cl_crosshairscale "0"
cl_crosshairsize "4"
cl_crosshairstyle "4"
cl_crosshairthickness "0.5"
cl_crosshairusealpha "1"

// Display damage given in game
developer "1"
con_enable "1"
con_filter_text "Damage"
con_filter_text_out "Player:"
con_filter_enable "2"

// Show teammates equipment
cl_teamid_overhead_always "1"
bind tab "+score;+cl_show_team_equipment"

// Mouse settings
sensitivity "3.450000"

host_writeconfig
"@

$training = @"
sv_cheats 1
mp_maxmoney 50000
mp_startmoney 50000
mp_freezetime 1
mp_roundtime_defuse 60
mp_roundtime_hostage 60
mp_buy_anywhere 1
mp_buytime 1000
sv_infinite_ammo 2
mp_warmup_end
bot_kick all
mp_solid_teammates 1
god
sv_grenade_trajectory 1
bind n noclip
"@

$autoexec | Out-File -Encoding "UTF8" ($config_dir_user1 + "\autoexec.cfg")
$autoexec | Out-File -Encoding "UTF8" ($config_dir_user2 + "\autoexec.cfg")

$training | Out-File -Encoding "UTF8" ($config_dir_user1 + "\training.cfg")
$training | Out-File -Encoding "UTF8" ($config_dir_user2 + "\training.cfg")