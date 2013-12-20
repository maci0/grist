cat > /etc/systemd/system/zpool.service << EOF
[Unit]
Description=import zpools
Wants=zfs.service

[Service]
ExecStart=/sbin/zpool import -f -a
Type=oneshot

[Install]
WantedBy=basic.target
EOF

systemctl enable zpool.service
