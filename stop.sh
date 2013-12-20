#!/bin/sh
sudo echo "stopping"
sudo kill `pgrep -f "qemu-system-x86_64 -machine accel=kvm -boot order=d -m 1024 -cdrom livecd-"`
sudo salt-key -D -y
rm *vd*.img -f
