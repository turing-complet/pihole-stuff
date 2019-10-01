[CmdletBinding()]
param()

systemctl is-active --quiet systemd-resolved.service

if ($LASTEXITCODE -eq 0) {
    Write-Verbose "The systemd resolver is active. Disabling it just in case."
    Write-Verbose "To re-enable it, run this:"
    Write-Verbose "sudo systemctl enable systemd-resolved"
    sudo systemctl stop systemd-resolved
}

$match = type /etc/resolv.conf | Select-String -Pattern "127.0.0.1"

if (!$match) {
    Write-Verbose "Adding localhost to resolv.conf"
    Set-Content -Path /etc/resolv.conf -Value "nameserver 127.0.0.1"
}

$container = docker inspect -f '{{.State.Running}}' pihole

if ($container -ne "true") {
    Write-Verbose "Pihole is not running. Starting it now."
    docker-compose up -d
}
