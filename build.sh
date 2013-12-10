#!/bin/sh
sudo rm -f *.iso
sudo livecd-creator --verbose --config=kickstart/grist.ks --cache=cache
