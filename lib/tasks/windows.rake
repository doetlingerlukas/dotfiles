# frozen_string_literal: true

require 'command'
require 'laptop'

task :windows => [:'windows:energy']

namespace :windows do
  desc "Change power settings."
  task :energy do

    puts "Disabling screen timeout and standby mode."

    ps_command("powercfg -change -monitor-timeout-ac 0")
    ps_command("powercfg -change -monitor-timeout-dc 0")
    ps_command("powercfg -change -standby-timeout-ac 0")
    ps_command("powercfg -change -standby-timeout-ac 0")

    if laptop?
      puts "Setting power saver as default plan."

      out, err, status = ps_command("powercfg -l | %{if($_.contains(Power saver) || $_.contains('Energiesparmodus')) {$_.split()[3]}}")
      powersaver_plan = out
      out, err, status = ps_command("$(powercfg -getactivescheme).split()[3]")
      current_plan = out

      if not powersaver_plan.eql? current_plan
        ps_command("powercfg -setactive #{powersaver_plan}")
      end
    end

  end
end