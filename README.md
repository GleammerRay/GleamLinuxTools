# Gleammer's Linux Tools

This repository hosts various tutorials and tools which Gleammer needs to set up and use Linux systems.

# File Actions

## KDE service menus

KDE service menu files are located at `/usr/share/kservices5/ServiceMenus/`

# KDE stuff

## Installing lastest stable KDE on Ubuntu-based distributions

```sh
sudo add-apt-repository ppa:kubuntu-ppa/backports ; sudo apt-get full-upgrade
```

## Map Meta key to KRunner (search menu) instead of Plasma Drawer

```sh
./install.sh meta krunner
```

## Map meta key back to Plasma Drawer

```sh
./install.sh meta plasma-drawer
```

## Window Buttons applet

May require a full system restart after installation.

```sh
sudo ./install.sh applet-window-buttons
```

https://github.com/psifidotos/applet-window-buttons

## Yet Another Magic Lamp

https://github.com/zzag/kwin-effects-yet-another-magic-lamp

### Yet Another Magic Lamp for Plasma 5.27 with blur fix

https://github.com/GleammerRay/kwin-effects-yet-another-magic-lamp/tree/blur-fix

# Miscellaneous

## Browser themes

Soft Moon Glow - https://chromewebstore.google.com/detail/soft-moon-glow/akaihbkmkohganaaghamiofkhkgicing

## Changing mouse polling rate

To set mouse polling rate, run:
```sh
sudo ./install.sh mousepoll x
```

`x` values are as follows:
```
0 = Unlimited
1 = 1000Hz
2 = 500Hz (recommended for most modern mice)
4 = 250Hz
8 = 125Hz
10 = 100Hz
```

## GPU passthrough

GPU passthrough is fun! Use https://github.com/ilayna/Single-GPU-passthrough-amd-nvidia.

1. For intel, add the following to `GRUB_CMDLINE_LINUX_DEFAULT` at `/etc/default/grub`:
```
acpi_rev_override=1 iommu=pt intel_iommu=on
```

2. Then, run:
```sh
sudo update-grub
```

If the GPU is not handed off to host after VM shuts down, try the solution from https://github.com/ilayna/Single-GPU-passthrough-amd-nvidia/issues/2#issuecomment-1732294999.
