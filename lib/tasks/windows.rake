# frozen_string_literal: true

require 'os'
require 'command'
require 'laptop'

task :windows => [:'windows:energy']

namespace :windows do
  desc 'Change power settings.'
  task :energy do
    next unless OS.windows?

    puts 'Disabling screen timeout and standby mode.'

    command 'powercfg', '-change', '-monitor-timeout-ac', '0'
    command 'powercfg', '-change', '-monitor-timeout-dc', '0'
    command 'powercfg', '-change', '-standby-timeout-ac', '0'
    command 'powercfg', '-change', '-standby-timeout-ac', '0'

    if laptop?
      puts 'Setting power saver as default plan.'

      out, _, status = ps_command("powercfg -l | %{if($_.contains(Power saver) || $_.contains('Energiesparmodus')) {$_.split()[3]}}")
      powersaver_plan = out
      out, _, status = ps_command("$(powercfg -getactivescheme).split()[3]")
      current_plan = out

      if not powersaver_plan.eql? current_plan
        command 'powercfg', '-setactive', powersaver_plan
      end
    end

  end
end