# -*- coding: utf-8 -*-
#video memory size should be at least 32meg for windows 7 to do full screen on my desktop
# I'm not sure how to set that with veewee::session yet

 #:iso_file => "Windows 7 7600 AIO.ISO",
    
Veewee::Session.declare({
    :os_type_id => 'Windows7_64',
    :iso_file => "en_windows_7_ultimate_with_sp1_x64_dvd_u_677332.iso",
    :iso_src => "", # Manual download
    :iso_md5 => "",
    :iso_download_timeout => "1000",

    :cpu_count => '1',
    :memory_size=> '512', 
    :disk_size => '20280', :disk_format => 'VDI', :hostiocache => 'off',
    
    :floppy_files => [
      "Autounattend.xml",
      "install-winrm.bat",
      "oracle-cert.cer",
      "install-cygwin-sshd.bat"
    ],


    :boot_wait => "60", #1 minute.. should be long enough
    # this is waiting for the screen where we could put in our product key
    # this is the command sequence to bybass it and to not try to register once online
    :boot_cmd_sequence => [ 
                           '<Down><Down><Down><Tab><Spacebar>',#Select Windows Ultimate Version
                           '<Spacebar><Tab><Spacebar>',        #Accept license
                           '<Tab><Tab><Tab><Tab><Spacebar>',   #Select partition
                           '<Wait>'*100, #Installing Windows...
                           '<Wait>'*100,
                           '<Wait>'*100,
                           '<Wait>'*100,
                           '<Tab><Tab><Tab><Tab><Spacebar>',#Bypass product license
                           '<Up><Spacebar>',#Recommended update settings
                           '<Up><Spacebar>',#Work network
                           '<Wait>'*10, #Finalising...
                           'vagrant<Enter>'#Login screen
                          ],

    :ssh_login_timeout => "10000",
    # Actively attempt to winrm (no ssh on base windows) in for 10000 seconds
    :ssh_user => "vagrant", :ssh_password => "vagrant", :ssh_key => "", 
    :ssh_host_port => "59857", :ssh_guest_port => "22",
    # And run postinstall.sh for up to 10000 seconds
    :postinstall_timeout => "10000",
    :postinstall_files => ["postinstall.sh"],
    # No sudo on windows
    :sudo_cmd => "sh '%f'",
    # Shutdown is different as well
    :shutdown_cmd => "shutdown.exe /s /t 0 /c \"Vagrant Shutdown\" /f /d p:4:1",
  })
