# dotfiles

These are my personal setup files.

## Windows

The `Windows` folder contains several files, one could use to start the setup: 
  - `main.ps1` can be executed with either `-mode setup` or `-mode config`, while the later will only do configuration and won't install any programs.
  - `\OS-Installation\Autounattend.xml` automatically runs the Windows installation process when copied to the root of a Windows bootable USB stick. It will afterwards start the installation scripts, if they are in the same directory.
  - `run.bat` starts the full setup process on execution.
