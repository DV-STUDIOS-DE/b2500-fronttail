# b2500-fronttail für openhab


Erstellt ein Logfile in /tmp für die Debugausgabe des B2500 ESP
Das Debugfile wird dann über das Fronttail auf http://[adresse von openhab]:9002 angezeigt

1. Die Datei events.sh als service ausführen:
sudo nano /etc/systemd/system/frontail-B2500.service
```
[Unit]
Description=Events Script Service
After=network.target

[Service]
User=openhabian
WorkingDirectory=/home/openhabian/B2500
ExecStart=/bin/bash /home/openhabian/B2500/events.sh
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```
Service neu laden und starten
```
sudo systemctl daemon-reload
sudo systemctl start events.service
sudo systemctl enable events.service
```
