# Arch Troubleshooting

## WARNING: Possibly missing firmware for module: xxx

Indicates missing firmware, see [Possibly_missing_firmware_for_module_XXXX](https://wiki.archlinux.org/title/Mkinitcpio#Possibly_missing_firmware_for_module_XXXX)

```sh
yay -S upd72020x-fw
yay -S ast-firmware
```

## High kworker kacpid/kacpi_notify

Mask the ACPI interrupt, see [High CPU usage due to kworker](https://sudoremember.blogspot.com/2013/05/high-cpu-usage-due-to-kworker.html)

Check which interrupt is overloaded:
```sh
for intr in /sys/firmware/acpi/interrupts/*; do
	printf "%s %s\n" "$(cat ${intr})" "${intr}"
done | sort -n
```

Mask it via kernel param:
```sh
vi /boot/loader/entries/arch.conf
```
e.g.
```
acpi_mask_gpe=0x16
```
