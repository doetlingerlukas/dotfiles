Import-Module -DisableNameChecking $PSScriptRoot\..\"file-helpers.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\"system-info.psm1"

Task csgo {
  Assert-ElevatedPrivileges

  Write-Host 'Setting up CS:GO config ...'

  $config_dir_user1 = 'C:/Program Files (x86)/Steam/userdata/136275020/730/local/cfg'
  $config_dir_user2 = 'C:/Program Files (x86)/Steam/userdata/241388330/730/local/cfg'

  EnsurePath $config_dir_user1
  EnsurePath $config_dir_user2

  $autoexec_config | Out-File -FilePath "$config_dir_user1\autoexec.cfg"
  $training_config | Out-File -FilePath "$config_dir_user1\training.cfg"

  Copy-Item "$config_dir_user1\autoexec.cfg" -Destination "$config_dir_user2\autoexec.cfg"
  Copy-Item "$config_dir_user1\training.cfg" -Destination "$config_dir_user2\training.cfg"

  Write-Host 'CS:GO config setup successfully!'
}

$autoexec_config = @"
// General
gameinstructor_enable 0
cl_autowepswitch 0
ui_mainmenu_bkgnd_movie1 "blacksite"
cl_mute_enemy_team 0

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
cl_show_observer_crosshair 2

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

// Sound settings
snd_tensecondwarning_volume 0.18

// Matchmaking
cl_color 0
mm_dedicated_search_maxping 45

// Bindings
alias +jumpthrow "+jump;-attack;-attack2"
alias -jumpthrow "-jump"
bind j +jumpthrow
alias +forwardjumpthrow "+forward;+jumpthrow"
alias -forwardjumpthrow "-forward;-jumpthrow"
bind h +forwardjumpthro
alias +djump "+jump; +duck"
alias -djump "-jump; -duck"
bind ALT +djump

host_writeconfig
"@

$training_config = @"
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
