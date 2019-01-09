"Setting up CS:Go config ..."

$config_dir_user1 = "C:\Program Files (x86)\Steam\userdata\136275020\730\local\cfg"
$config_dir_user2 = "C:\Program Files (x86)\Steam\userdata\241388330\730\local\cfg"

$autoexec = @"
  # Crosshair

  # Display damage given in game
  developer "1"
  con_filter_text "Damage"
  con_filter_text_out "Player:"
  con_filter_enable "2"
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

$autoexec | Out-File ($config_dir_user1 + "\autoexec.cfg")
$autoexec | Out-File ($config_dir_user2 + "\autoexec.cfg")

$training | Out-File ($config_dir_user1 + "\training.cfg")
$training | Out-File ($config_dir_user2 + "\training.cfg")