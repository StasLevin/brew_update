#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

M=$(date +"%b")
D=$(date +"%d")
MD="$M $D"

LOGFILE="$(pwd)/brew_update.log"

if [ -f "$LOGFILE" ]; then
  grep -v "update already logged" "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
fi

if grep -q "$MD" "$LOGFILE"; then
  echo "Brew update already logged for today: $MD" >> "$LOGFILE"
  exit 0
fi

/opt/homebrew/bin/brew update >/tmp/brew_update.log 2>&1
/opt/homebrew/bin/brew upgrade --greedy >>/tmp/brew_update.log 2>&1
/opt/homebrew/bin/brew cleanup >>/tmp/brew_update.log 2>&1
/opt/homebrew/bin/brew doctor >>/tmp/brew_update.log 2>&1

DATE=$(date)

echo "Brew update completed at $DATE"  >> "$LOGFILE"


while [ "$(wc -l < "$LOGFILE")" -gt 7 ]; do
  # Remove the first line and overwrite the file
  tail -n +2 "$LOGFILE" > "$LOGFILE.tmp" && mv "$LOGFILE.tmp" "$LOGFILE"
done

if [ -f $LOGFILE.tmp ]; then
  rm -f $LOGFILE.tmp
fi
