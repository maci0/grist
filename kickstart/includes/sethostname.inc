cat > /etc/systemd/system/sethostname.service << EOF
[Unit]
Description=set hostname

[Service]
ExecStart=/bin/sh -c "/bin/hostnamectl set-hostname $(/sbin/dmidecode -s system-uuid).local"
Type=oneshot

[Install]
WantedBy=basic.target
EOF

systemctl enable sethostname.service

