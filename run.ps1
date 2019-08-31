
systemctl is-active --quiet systemd-resolved.service

if ($LASTEXITCODE -eq 0) {
    Write-Host "The systemd resolver is active. Disabling it just in case."
    Write-Host "To re-enable it, run this:"
    Write-Host "sudo systemctl enable systemd-resolved"
    sudo systemctl stop systemd-resolved
}

$match = type /etc/resolv.conf | Select-String -Pattern "127.0.0.1"

if (!$match) {
    Write-Host "Adding localhost to resolv.conf"
    Set-Content -Path /etc/resolv.conf -Value "nameserver 127.0.0.1"
}

$container = docker inspect -f '{{.State.Running}}' pihole

if ($container -ne "true") {
    Write-Host "Pihole is not running. Starting it now."
    docker-compose up
}