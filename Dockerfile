FROM archlinux:latest

RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
        archiso \
        mkinitcpio \
        squashfs-tools \
        dosfstools \
        mtools \
        libisoburn \
        grub \
        syslinux \
        && \
    pacman -Scc --noconfirm

WORKDIR /build
COPY archlive ./archlive

RUN chmod +x archlive/airootfs/root/customize_airootfs.sh \
            archlive/airootfs/usr/local/bin/pepaos-welcome \
            archlive/airootfs/usr/local/bin/pepaos-installer

CMD ["mkarchiso", "-v", "-w", "/build/work", "-o", "/output", "archlive"]
