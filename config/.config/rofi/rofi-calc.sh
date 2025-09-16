#!/usr/bin/env bash

RESULT_FILE="$HOME/.config/qalculate/qalc.result.history"
if [ ! -f "$RESULT_FILE" ]; then
  touch $RESULT_FILE
fi

LAST_ROFI=""
QALC_RET=""
while :; do
  qalc_hist=$(tac $RESULT_FILE | head -1000)
  ROFI_RET=$(rofi -dmenu -p calc <<<"$qalc_hist")

  rtrn=$?

  if test "$rtrn" = "0"; then
    if [[ "$ROFI_RET" =~ .*=.* ]]; then
      RESULT=$(echo "$ROFI_RET" | awk {'print $NF'})
      wl-copy "$RESULT"
      exit 0
    else
      QALC_RET=$(qalc "$ROFI_RET")
      LAST_ROFI=$ROFI_RET
      echo $QALC_RET >>$RESULT_FILE
    fi
  else
    if [ ! -z "$LAST_ROFI" ]; then
      RESULT=$(qalc -t "$LAST_ROFI")
      wl-copy "$RESULT"
    fi
    exit 0
  fi
done
