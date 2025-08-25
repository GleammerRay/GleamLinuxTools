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

## Grayscale

May require a logout or toggling the effect off and on again in system settings after installation.

```sh
sudo ./install.sh kwin-grayscale
```

https://github.com/murat-cileli/kwin-grayscale-effect

## Yet Another Magic Lamp

https://github.com/zzag/kwin-effects-yet-another-magic-lamp

### Yet Another Magic Lamp for Plasma 5.27 with blur fix

https://github.com/GleammerRay/kwin-effects-yet-another-magic-lamp/tree/blur-fix

# Miscellaneous

## Removing root space reserve

Determine your root disk and run (replace `/dev/sda1` with your disk device path):
```sh
sudo tune2fs -m 0 /dev/sda1
```

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

## Google Authenticator

Google Authenticator can be installed as a Pluggable Authentication Module (PAM) to provide an alternative or second-factor authentication method for superuser and login functionality.

To do so, install `libpam-google-authenticator` and run the `google-authenticator` command to set it up.  
Once the process is complete, the `.google_authenticator` file will be generated in your home folder, with a set of TOTP credentials.  
To use these credentials for `sudo` and desktop login, you'll need to create a re-usable PAM configuration line. In my case, it looks something like this:
```
auth required pam_google_authenticator.so nullok
```
This entry enables Google Authenticator and uses the `nullok` option to allow login without OTP if it isn't set up yet.  
If you wish to use Google Authenticator for passwordless login instead of multi-factor authentication, replace `required` with `sufficient`.

Once created, this line can be inserted into various PAM configuration files under `/etc/pam.d`.  
For superuser authentication use the `sudo` file, for GDM use `gdm-password`, and for KDE use `sddm` and, if one does not already exist, create and modify the `kde` file by copying the `login` configuration to enable the module for the KDE screen locker.

While this is enough for multi-factor authentication, it isn't very safe for passwordless login on a single-user setup. To improve security in such cases, change the `.google_authenticator` file owner to `root` and add the `user=root`, `secret=/home/yourusername/.google_authenticator` and `allow_readonly` options to your PAM line.  
This will work for sudo and desktop manager authentication right away, but the KDE screen locker also needs permissions to set user ID in order to process the file:
```sh
sudo setcap cap_setuid,cap_setgid+ep /usr/lib/x86_64-linux-gnu/libexec/kscreenlocker_greet
```

That's it! Both OTP and passwordless login with Google Authenticator require very little setup but security considerations necessitate a few extra steps.  
The secret key generated and stored inside the `.google_authenticator` file may also be stored and used for TOTP code generation in Passy via the "Two-Factor Authentication" feature inside a password entry.
