#!/usr/bin/env bash

# Pepa OS - airootfs customization script
# Runs inside the chroot during ISO build

set -euo pipefail

echo "[✓] Customizing Pepa OS root filesystem..."

# --- Locale ---
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf

# --- Timezone ---
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# --- Hostname ---
echo "pepaos" > /etc/hostname

# --- Hosts ---
cat > /etc/hosts << 'EOF'
127.0.0.1   localhost
::1         localhost
127.0.1.1   pepaos.localdomain pepaos
EOF

# --- mkinitcpio ---
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

# --- Enable essential services ---
systemctl enable NetworkManager.service
systemctl enable lightdm.service
systemctl enable bluetooth.service
systemctl enable acpid.service
systemctl enable tlp.service
systemctl enable cups.service
systemctl enable fstrim.timer
systemctl enable paccache.timer

# --- Create live user ---
useradd -m -G wheel,audio,video,storage,optical,network,lp,sys,power -s /bin/bash pepa
echo "pepa:pepa" | chpasswd
echo "root:pepaos" | chpasswd

# --- sudo for wheel ---
echo "%wheel ALL=(ALL) ALL" > /etc/sudoers.d/10-pepaos
chmod 440 /etc/sudoers.d/10-pepaos

# --- Copy skel to user ---
cp -r /etc/skel/. /home/pepa/
chown -R pepa:pepa /home/pepa/

# --- Generate wallpaper PNG ---
convert -size 1920x1080 \
    \( -size 1920x1080 gradient:'#0a0e14'-'#1a2a3a' \) \
    \( -size 1920x1080 radial-gradient:'#00d4aa'-'#0f1923' -channel A -evaluate set 10% \) \
    -composite \
    -font JetBrains-Mono-Bold -pointsize 72 -gravity center \
    -fill '#00d4aa' -annotate +0-40 'PEPA OS' \
    -font JetBrains-Mono-Regular -pointsize 20 \
    -fill '#6c7086' -annotate +0+30 'Arch Linux  ·  i3  ·  Minimal  ·  Elegant' \
    /usr/share/backgrounds/pepaos-wallpaper.png 2>/dev/null || \
convert -size 1920x1080 gradient:'#0a0e14'-'#1a2a3a' \
    -font Helvetica-Bold -pointsize 72 -gravity center \
    -fill '#00d4aa' -annotate +0-40 'PEPA OS' \
    -font Helvetica -pointsize 20 \
    -fill '#6c7086' -annotate +0+30 'Arch Linux  ·  i3  ·  Minimal  ·  Elegant' \
    /usr/share/backgrounds/pepaos-wallpaper.png

# --- GTK theming (system-wide) ---
mkdir -p /etc/skel/.config/gtk-3.0

# --- Remove leftover artifacts ---
rm -f /var/cache/pacman/pkg/*

echo "[✓] Pepa OS customization complete!"
