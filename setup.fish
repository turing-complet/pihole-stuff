#!/usr/bin/env fish

sudo ln -s (realpath run.fish) /usr/bin/run.fish 
sudo chmod 664 pihole.service
sudo ln -s (realpath pihole.service) /etc/systemd/system/pihole.service
sudo systemctl reload
sudo systemctl enable pihole.service