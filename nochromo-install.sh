## install zram (should already exist a kernel module)
#patch < galliumos.patch # already patched
sudo cp ./zram/*-zram-swapping /usr/bin/
sudo chown root:root /usr/bin/*-zram-swapping
sudo chmod 755 /usr/bin/*-zram-swapping

sudo cp ./zram/systemdscripts/zram-config.service /usr/lib/systemd/system/
sudo chown root:root /usr/lib/systemd/system/zram-config.service
sudo chmod 644 /usr/lib/systemd/system/zram-config.service

sudo systemctl enable zram-config
sudo systemctl start zram-config


## keymap & X default keyboard layout
# make sure you choose 'Chromebook' as your default keyboard layout when installing
cp ./peppermint.xmodmap ~/.Xmodmap
chmod 644 ~/.Xmodmap
echo "xmodmap ~/.Xmodmap" >> ~/.xinitrc
xmodmap ./peppermint.xmodmap

sudo nano /etc/default/keyboard
#  Make sure your XKBMODEL variable is set to chromebook
#	#XKBMODEL="pc105"
#	XKBMODEL="chromebook"
# (i think i forgot to set this to chromebook during my installation = maybe why it was 'pc105' originally)


## update kernel boot parameters
sudo nano /etc/default/grub
#  Make sure the following variable is set as such:
GRUB_CMDLINE_LINUX_DEFAULT="quiet cryptdevice=UUID=8dbd6a79-2f20-44b1-a57f-6436ed017e4e:luks-8dbd6a79-2f20-44b1-a57f-6436ed017e4e root=/dev/mapper/luks-8dbd6a79-2f20-44b1-a57f-6436ed017e4e splash acpi_osi=Linux acpi_backlight=vendor tpm_tis.interrupts=0"
# update grub menu
sudo update-grub

## install GalliumOS tweaks: sysctl (kernel settings), etc
# sysctl
sudo ./braswell-settings/_etc_sysctl.d/20-galliumos.conf
sudo chmod 644 /etc/sysctl.d/20-galliumos.conf

# move initscripts
sudo cp ./braswell-settings/_usr_bin/* /usr/bin/

# Disable asynchronous device suspend # https://github.com/GalliumOS/galliumos-distro/issues/192
sudo cp ./braswell-settings/systemdscripts/galliumos-braswell.service /usr/lib/systemd/system/
sudo chmod 644 /usr/lib/systemd/system/galliumos-braswell.service
sudo systemctl enable galliumos-braswell
sudo systemctl start galliumos-braswell

# Disable monitor polling (i guess?)
sudo cp ./braswell-settings/systemdscripts/galliumos-base.service /usr/lib/systemd/system/
sudo chmod 644 /usr/lib/systemd/system/galliumos-base.service
sudo systemctl enable galliumos-base
sudo systemctl start galliumos-base

# touchpad and backlight(s) tweaks
sudo cp ./braswell-settings/systemdscripts/galliumos-laptop.service /usr/lib/systemd/system/
sudo chmod 644 /usr/lib/systemd/system/galliumos-laptop.service
sudo systemctl enable galliumos-laptop
sudo systemctl start galliumos-laptop

# X11 intel driver / backlight config
# note, this may not be required... my cbook video was running fine without this config (and brightness could be manually changed)
sudo cp ./braswell-settings/_usr_share_X11_xorg.conf.d/20-intel.conf /usr/share/X11/xorg.conf.d/
sudo chmod 644 /usr/share/X11/xorg.conf.d/20-intel.conf

## if brightness keys still dont work for you...
## setup keyboard shortcuts
# use XFCE keyboard settings > application shortcuts to set up shortcuts for /usr/bin/change-brightness <XXX|-XXX>
