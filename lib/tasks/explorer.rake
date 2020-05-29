# frozen_string_literal: true

require 'os'
require 'win32/registry' if OS.windows?

desc 'configure windows explorer'
task :explorer do
  next unless OS.windows?

  puts 'Configuring Windows Explorer ...'

  Win32::Registry::HKEY_CURRENT_USER.create('Software\Microsoft\Windows\CurrentVersion\Explorer') do |reg|
    # Hide 'recent' shortcuts.
    reg['ShowRecent', Win32::Registry::REG_DWORD] = 0
    reg['ShowFrequent', Win32::Registry::REG_DWORD] = 0

    reg.create('Advanced') do |advanced|
      # Lauch explorer to 'This PC'.
      advanced['LaunchTo', Win32::Registry::REG_DWORD] = 1
      
      # Show hidden folders and file extensions.
      advanced['Hidden', Win32::Registry::REG_DWORD] = 1
      advanced['HideFileExt', Win32::Registry::REG_DWORD] = 0
      
      # Show folder merge conflicts.
      advanced['HideMergeConflicts', Win32::Registry::REG_DWORD] = 0
      
      # Show color for encrypted or compressed folders.
      advanced['ShowEncryptCompressedColor', Win32::Registry::REG_DWORD] = 0
    end
  end

  # Hide '3D Objects'.
  begin
    Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag') do |reg|
      reg['ThisPCPolicy', Win32::Registry::REG_SZ] = 'Hide'
    end
    Win32::Registry::HKEY_LOCAL_MACHINE.create('Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag') do |reg|
      reg['ThisPCPolicy', Win32::Registry::REG_SZ] = 'Hide'
    end
  rescue Win32::Registry::Error
    puts '3D Objects could not be hidden!'
  end

  # Remove 'Include in Library' from context menu.
  begin
    Win32::Registry::HKEY_CLASSES_ROOT.open('Folder\ShellEx\ContextMenuHandlers', desired = Win32::Registry::KEY_ALL_ACCESS) do |reg|
      reg.delete_key('Library Location', true)
    end
  rescue Win32::Registry::Error
    puts 'Library Location could not be deleted from context menu!'
  end

end