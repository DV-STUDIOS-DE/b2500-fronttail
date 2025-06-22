#!/bin/bash

SSE_URL="http://192.168.178.122/events"
LOGFILE="/tmp/b2500debug.log"

log_line() {
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$timestamp] $1" >> "$LOGFILE"
}

while true; do
  echo "Verbinde zum SSE-Stream..." >&2
  curl -s --no-buffer "$SSE_URL" | stdbuf -oL awk '
    function trim(str) {
      gsub(/^[ \t\r\n]+|[ \t\r\n]+$/, "", str)
      return str
    }

    function cleanAndPrint() {
      if (data != "") {
        gsub(/^\[.\]\[[^]]+\]:[ \t]*/, "", data)
        print data
        fflush()
      }
    }

    /^data:/ {
      d = trim(substr($0, 7))
      if (d ~ /"id":/ || d ~ /"state":/ || d == "state") next
      if (data == "") { data = d } else { data = data " | " d }
      next
    }

    /^event:/ { cleanAndPrint(); data = ""; next }
    /^id:/ { next }

    /^$/ { cleanAndPrint(); data = "" }

    END { cleanAndPrint() }
  ' | while IFS= read -r line; do
    log_line "$line"
    echo "$line"
  done

  echo "Verbindung getrennt. Versuche neu in 5 Sekunden..." >&2
  sleep 5
done
