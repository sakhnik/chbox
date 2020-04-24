# Notes on running Arch Linux on GalliumOS

GalliumOS is doing fantastic job to got Linux running on Chromebook hardware.
But it's often based on an outdated distribution. Arch Linux is a modern
rolling release distribution, which however requires stable hardware to run on.
So my solution was to install GalliumOS on my HP Chromebook 13 G1, strip it
down to just be able to run Arch Linux in a systemd-nspawn container.

## Configuring and launching i3

GalliumOS is using Xubuntu and starts XFCE by default. To run i3, launch
`xfce4-session-settings`, remove all the panels, window management, and
create a new autostart entry pointing to [bin/i3-start.sh](bin/i3-start.sh).
I3 should be installed in the host OS.

That script will also bind PulseAudio socket directory to the guest.
