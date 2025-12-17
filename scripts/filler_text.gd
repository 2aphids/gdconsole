extends RichTextLabel


const COLOURS: Dictionary = {
	"red": "#fb4934",
	"green": "#b8bb26",
	"yellow": "#fabd2f",
	"blue": "#83a598",
	"pink": "#d3869b",
	"cyan": "#8ec07c",
	"white": "#ebdbb2",
	"grey": "#a89984",
	"gray": "#a89984",
	"darkred": "#cc241d",
}

var filler_text = """==========================================
  AMI BIOS v2.21.1278
===========================================
CPU: AMD Ryzen 7 5700X
Memory Testing…… [color=green]OK[/color]
USB Devices: 4 Drives, 1 Keyboard, 1 Mouse
SATA Controller… Initializing…
[color=yellow]WARNING: Port 2 device signature invalid[/color]

Press DEL to enter setup…
Press F11 for boot menu…

Booting UEFI...

===========================================
   UEFI Firmware Interface
===========================================
Loading boot entries…
Found: Arch Linux (systemd-boot)
Found: Arch Linux (Fallback initramfs)
Found: EFI Shell
[color=yellow]Failed to verify boot entry: Invalid signatures[/color]
Attempting unsecure boot…
[color=green]Unsecure boot enabled[/color]

Launching Arch Linux…

-------------------------------------------
           ARCH LINUX INITRD
-------------------------------------------
:: running early hook [udev]
:: running early hook [keyboard]
:: running hook [keymap]
Loaded US keymap.

[color=green]:: Mounting /proc[/color]
[color=green]:: Mounting /sys[/color]
[color=green]:: Mounting /dev[/color]

Loading modules…
[color=cyan]modprobe: loading ext4[/color]
[color=cyan]modprobe: loading vfat[/color]
[color=cyan]modprobe: loading amdgpu[/color]
[color=red]amdgpu: firmware load failed[/color]
[color=yellow]amdgpu: retrying with fallback microcode[/color]
[color=green]amdgpu: initialized (degraded mode)[/color]

Unlocking root volume:
Enter passphrase: *********

[color=green]cryptsetup: volume unlocked[/color]

Mounting root filesystem…
[color=red]ERROR: ext4: journal checksum invalid[/color]
[color=yellow]Attempting repair…[/color]
[color=red]Repair failed: rootfs marked unclean[/color]

Dropping to recovery shell in initramfs.
sh: /

-------------------------------------------
    USER REPAIRS ROOTFS
-------------------------------------------
fsck.ext4 /dev/nvme0n1p2
[color=yellow]fsck: inode 22094 has invalid mode[/color]
[color=yellow]fsck: orphaned inode list found[/color]
[color=green]Filesystem repaired[/color]

Reboot required.
Rebooting…

-------------------------------------------
       SYSTEMD START (BOOT #2)
-------------------------------------------

systemd: Detected architecture x86-64
systemd: Using default hostname 'archbox'

[color=cyan]Creating slice system-systemd\\x2dfsck.slice[/color]
[color=cyan]Creating slice system-getty.slice[/color]
[color=cyan]Creating slice user.slice[/color]

Starting Remount Root and Kernel File Systems…
[color=green]Finished Remount Root and Kernel File Systems[/color]

Starting Coldplug All Udev Devices…
[color=yellow]udevd: 4 devices slow to respond[/color]
[color=red]udevd: timeout waiting for device /sys/block/nvme0n1[/color]
[color=yellow]Continuing without device[/color]

Starting Network Manager…
[color=red]nm: wlan0: firmware missing[/color]
[color=yellow]nm: eth0: no link detected[/color]
[color=green]nm: eth0: carrier acquired (forced mode)[/color]

Starting Hostname Service…
[color=red]hostnamectl: read-only filesystem detected[/color]
[color=yellow]Retrying kernel remount rw…[/color]
[color=red]Remount failed[/color]

Starting Login Service…
[color=yellow]systemd-logind: seat0 already exists[/color]
[color=green]systemd-logind: recovered seat0[/color]

Reached target Multi-User System.

-------------------------------------------
    GRAPHICAL TARGET ATTEMPT
-------------------------------------------
Starting LightDM Display Manager…
[color=cyan]lightdm: starting X server…[/color]
[color=red]amdgpu: GPU lockup detected[/color]
[color=red]Xorg: fatal server error: no screens found[/color]

lightdm: display server terminated unexpectedly
[color=yellow]Retrying in 3… 2… 1…[/color]

[color=red]Retry failed: entering text-only mode[/color]

-------------------------------------------
         DEVICE INITIALIZATION
-------------------------------------------
[color=yellow]udevd: waiting for device initialization…[/color]
[color=yellow]udevd: waiting for device initialization…[/color]
[color=yellow]udevd: waiting for device initialization…[/color]
[color=cyan]udevd: device initialized[/color]

[color=yellow]ACPI: EC: polling mode enabled[/color]
[color=yellow]ACPI: EC: polling mode enabled[/color]
[color=yellow]ACPI: EC: polling mode enabled[/color]
[color=cyan]ACPI: EC: returning to interrupt mode[/color]

[color=red]btrfs: checksum error at logical 0x4a221100[/color]
[color=yellow]btrfs: attempting repair…[/color]
[color=red]btrfs: repair failed[/color]

-------------------------------------------
         KERNEL PANIC SEQUENCE
-------------------------------------------
[color=red]Kernel panic: VFS: Unable to mount root fs on unknown-block(0,0)[/color]
[color=yellow]Attempting automatic reboot in 5 seconds…[/color]

[color=yellow]5…[/color]
[color=yellow]4…[/color]
[color=red]3— filesystem driver missing[/color]
[color=yellow]2…[/color]
[color=red]1— system halted[/color]

Rebooting…
[color=red]Kernel panic: stack-protector: kernel stack is corrupted in: arch_broken_boot()[/color]
[color=yellow]Rebooting automatically…[/color]

UEFI: Boot failed, trying next option…
systemd-boot: loading vmlinuz-linux…
[color=red]initrd: invalid magic number[/color]

Falling back to previous kernel…
[color=yellow]Attempting boot…[/color]

[color=red]Kernel panic: Attempted to kill init![/color]

Rebooting…
"""

var i = 0
var next_time = 1
var t: PackedStringArray


func _ready() -> void:
	for key in COLOURS:
		filler_text = filler_text.replacen(key, COLOURS[key])

	t = filler_text.split("\n")


func _process(_delta: float) -> void:
	if (Time.get_ticks_msec() > next_time):
		next_time = Time.get_ticks_msec() + (randf()*1000)
		self.text += "\n%s" % t[i]
		i += 1
		if (i > t.size()-1):
			i = t.size()-1
