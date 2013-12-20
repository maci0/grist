network --bootproto=dhcp --device=eth0 --onboot=on
network --onboot no --device eth1 --noipv4 --noipv6

keyboard us
timezone Europe/Berlin --utc
lang en_US
auth  --useshadow  --passalgo=sha512
rootpw --iscrypted $6$dsfkjhdsfkljshdf$jGe3US.YUIJbNm6eYzkrGuYMu/A44GgOdHcKqmHFItbsXp2cN4/3XaDDDcVZoUxp3jypUDgokJbzNUjXx7fhp1
selinux --permissive
firewall --disabled
part / --fstype="ext4" --size=2000


repo --name=fedora --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=fedora-19&arch=x86_64
repo --name=updates --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=updates-released-f19&arch=x86_64 
repo --name=zfs --baseurl=http://archive.zfsonlinux.org/fedora/19/x86_64

%packages
@core
kernel
shim
grub2
grub2-tools
grub2-efi
dmidecode

## NETWORK
firewalld
avahi-tools
nss-mdns
## END NETWORK

## GLUSTER
glusterfs
glusterfs-server
nfs-utils
## END GLUSTER

## ZFS
kernel-devel
yum-plugin-priorities
zfs
## END ZFS

## SALT
salt-minion
## END SALT

## LIBVIRT
@virtualization
-virt-manager
-virt-viewer
## END LIBVIRT
%end

%post
%include includes/ifcfg-eth1.inc

echo "10.0.2.2 salt" >> /etc/hosts
sed -i 's/^hosts:.*/hosts: files myhostname mdns [NOTFOUND=return] dns/' /etc/nsswitch.conf


rpm -Uvh http://archive.zfsonlinux.org/fedora/zfs-release-1-2$(rpm -E %dist).noarch.rpm
yum -y reinstall spl-dkms zfs-dkms
yum clean all


###### custom systemd unit files
%include includes/sethostname.inc
%include includes/zpool.inc



##### services
systemctl enable avahi-daemon.service
systemctl enable mynetwork.service
systemctl enable libvirtd.service
systemctl enable salt-minion.service
systemctl enable glusterd.service rpcbind.service
systemctl enable dkms_autoinstaller.service
%end
