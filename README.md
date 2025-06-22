# b2500-fronttail für openhab


Erstellt ein Logfile in /tmp für die Debugausgabe des B2500 ESP
Das Debugfile wird dann über das Fronttail auf http://[adresse von openhab]:9002 angezeigt

1. Die Datei events.sh in das Homeverzeichnis\B2500 kopieren
Als service ausführen:
```
sudo nano /etc/systemd/system/frontail-B2500.service
```
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
```

2. frontail auf Port 9002 einrichten
Damit der Inhalt der /tmp/b2500debug.log im Frontatil sichtbar wird, zuerst den Pfad von Fronttail ermitteln, sollte etwa so aussehen
```
openhabian@openhabian:~ $ which frontail
/usr/local/bin/frontail
```
Ist Frontail nicht vefügbar folgendes ausführen
```
sudo apt update
sudo apt install -y nodejs npm
```
Check Node.js Version:
```
node -v
npm -v
```
Falls node veraltet ist, kannst du Node.js von Nodesource installieren (optional):
```
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```
frontail global installieren
```
sudo npm install -g frontail
```
Prüfen, ob frontail verfügbar ist
```
openhabian@openhabian:~ $ frontail --version
4.9.2
```
Alles ok, dann weiter
```
sudo nano /etc/systemd/system/frontail-b2500.service
```
Inhalt
```
[Unit]
Description=Frontail service for b2500debug.log
After=network.target

[Service]
User=openhabian
ExecStart=/usr/bin/frontail --disable-usage-stats --ui-highlight --lines 2000 --number 200 --port 9002 --theme dark /tmp/b2500debug.log
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```
Service aktivieren und starten:
```
sudo systemctl daemon-reload
sudo systemctl start frontail-b2500.service
sudo systemctl enable frontail-b2500.service
```
3. Dateigröße des Logfiles mit logroate begrenzen
```
sudo nano /etc/logrotate.d/b2500debug
```
Inhalt, size auf gewünschte Größe anpassen, jedoch maximal 75% der Größe vom tmp Verzeichnis
```
/tmp/b2500debug.log {
    size 75M
    rotate 5
    compress
    missingok
    notifempty
    copytruncate
    create 644 openhabian openhabian
}
```
Nun wird die Datei /tmp/b2500debug.log nach 75MB gekappt.
Es werden dabei maximal 5 alte Dateien gespeichert (rotate = 5)

So, das wars schon, viel Spass damit!!!
