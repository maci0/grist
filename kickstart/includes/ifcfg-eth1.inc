cat > /etc/sysconfig/network-scripts/ifcfg-eth1 << EOF
DEVICE="eth1"
NM_CONTROLLED="yes"
ONBOOT="yes"
BOOTPROTO="autoip"
EOF
