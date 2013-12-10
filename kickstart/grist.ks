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
avahi-autoipd
nss-mdns
#we dont want this shit
-NetworkManager
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
#echo "nameserver 10.0.2.2" > /etc/resolv.conf
echo "10.0.2.2 salt" >> /etc/hosts
sed -i 's/^hosts:.*/hosts: files myhostname mdns [NOTFOUND=return] dns/' /etc/nsswitch.conf

rpm -Uvh http://archive.zfsonlinux.org/fedora/zfs-release-1-2$(rpm -E %dist).noarch.rpm
yum -y reinstall spl-dkms zfs-dkms
yum clean all


###### custom systemd unit files

curl https://raw.github.com/maci0/grist/master/addons/etc/systemd/system/mynetwork.service > /etc/systemd/system/mynetwork.service
curl https://raw.github.com/maci0/grist/master/addons/etc/systemd/system/zpool.service > /etc/systemd/system/zpool.service
curl https://raw.github.com/maci0/grist/master/addons/etc/systemd/system/sethostname.service > /etc/systemd/system/sethostname.service


##### services
systemctl enable avahi-daemon.service
systemctl enable sethostname.service
systemctl enable zpool.service
systemctl enable mynetwork.service
systemctl enable libvirtd.service
systemctl enable salt-minion.service
systemctl enable glusterd.service rpcbind.service
systemctl enable dkms_autoinstaller.service
%end
