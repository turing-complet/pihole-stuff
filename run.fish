#!/usr/bin/env fish

systemctl is-active --quiet systemd-resolved.service
if test $status -eq 0
    echo "The systemd resolver is active. Disabling it just in case."
    echo "To re-enable it, run this:"
    echo "sudo systemctl enable systemd-resolved"
    sudo systemctl stop systemd-resolved
end

set resolvconf (cat /etc/resolv.conf)

if not grep -q "127.0.0.1" /etc/resolv.conf
    echo "Adding localhost to resolv.conf"
    sudo echo "nameserver 127.0.0.1" > /etc/resolv.conf
end

set container (docker inspect -f '{{.State.Running}}' pihole)

if [ $container != "true" ]
    echo "Pihole is not running. Starting it now."
    docker-compose up -d
end
