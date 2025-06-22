# b2500-fronttail für openhab


Erstellt ein Logfile in /tmp für die Debugausgabe des B2500 ESP
Das Debugfile wird dann über das Fronttail auf http://[adresse von openhab]:9002 angezeigt

1. Die Datei events.sh in das Homeverzeichnis\B2500 kopieren
   
```
sudo nano /etc/systemd/system/frontail-B2500.service
```
Als service ausführen:
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
sudo systemctl enable frontail-B2500.service
```
Check mit:
```
openhabian@openhabian:~ $ ls /tmp/b2500debug.log
/tmp/b2500debug.log

2. Fronttail auf Port 9002 einrichten
  Damit der Inhalt der 
