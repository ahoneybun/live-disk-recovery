if [[ $drivevar = nvme && $osvar = ubuntu && $encryptvar = yes ]]
    then
        sudo cryptsetup luksOpen $rootvar cryptdata
        sudo lvscan
        sudo vgchange -ay
        sudo mount /dev/mapper/vgubuntu-root /mnt
        sudo mount $efivar /mnt/boot/efi
        for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
        sudo cp /etc/resolv.conf /mnt/etc/
        sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = ubuntu && $encryptvar = yes ]]
        then
            sudo cryptsetup luksOpen /dev/$rootvar cryptdata
            sudo lvscan
            sudo vgchange -ay
            sudo mount /dev/mapper/vgubuntu-root /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = nvme && $osvar = ubuntu && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
    elif [[ $drivevar = sata && $osvar = ubuntu && $encryptvar = no ]]
        then
            sudo mount $rootvar /mnt
            sudo mount $efivar /mnt/boot/efi
            for i in /dev /dev/pts /proc /sys /run; do sudo mount -B $i /mnt$i; done
            sudo cp /etc/resolv.conf /mnt/etc/
            sudo chroot /mnt
fi