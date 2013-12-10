#!/bin/sh
sudo echo "starting"
UUID=`uuidgen`
qemu-img create -f qcow2 ${UUID}_vda.img 10G
qemu-img create -f qcow2 ${UUID}_vdb.img 10G

qemu-kvm -boot order=d -m 1024 -cdrom livecd-uber*.iso \
-drive file=${UUID}_vda.img,if=virtio -drive file=${UUID}_vdb.img,if=virtio \
-device virtio-net-pci,netdev=eth0,mac=`printf '52:54:00:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))` -netdev type=user,id=eth0  \
-device virtio-net-pci,netdev=eth1,mac=`printf '52:54:00:%02X:%02X:%02X\n' $((RANDOM%256)) $((RANDOM%256)) $((RANDOM%256))` -netdev type=socket,id=eth1,mcast=230.0.0.1:1234  \
--uuid ${UUID} &
sleep 30
sudo salt-key -A  -y
