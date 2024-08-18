#!/usr/bin/env bash
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# default config
FIELDS=BARS,SSID #,SECURITY,BARS
POSITION=0; XOFF=0; YOFF=0;

# get current uuid
CURRUUID=$(nmcli -f UUID,TYPE con show --active | grep wifi | awk '{print $1}')

# get wifi state
function wifistate () {
  echo "$(nmcli -fields WIFI g)"
}

# get active wifi connections
function wifiactive () {
  echo "$(nmcli con show --active | grep wifi)"
}

function if_wifistate () {
  # return a expression based on wifi state
  [[ "$(wifistate)" =~ 'enabled' ]] && rt=$1 || rt=$2
  echo $rt
}


function toggle_wifi () {
  toggle=$(if_wifistate "Disable Network" "Enable Network")
  echo $toggle
}

function current_connection () {
  currssid=$(iwgetid -r)
  [[ "$currssid" != '' ]] && currcon="Disconnect from $currssid" || currcon=""
  echo $currcon
}

function nmcli_list () {
  # get list of available connections without the active connection (if it's connected)
  echo "$(nmcli --fields IN-USE,"$FIELDS" device wifi list | sed '/*/d' | sed '/IN-USE/d')"
}

function count_lines () {
  echo "$1" | wc -l
}

function linenum () {
  wa=$(wifiactive)
  list_lines_num=$(count_lines "$1")
  [[ "$wa" != '' ]] && ops=4 || ops=3

  lines=$(if_wifistate "$(($list_lines_num+$ops))" 1)
  echo $lines
}

function rwidth () {
    minus=$(echo -n "IN-USE  " | wc -m)
    rwidth=$(if_wifistate "$(($(echo "$1" | head -n 1 | awk '{print length($0); }')-$minus))" \
      "$(echo "$2" | awk '{print length($0); }')" )
    echo $rwidth
}

function menu () {
  wa=$(wifiactive); ws=$(wifistate);

  if [[ "$ws" =~ 'enabled' ]]; then
    if [[ "$wa" != '' ]]; then
        echo "$1\n\n$2\n$3\nManual Connection"
    else
        echo "$1\n\n$3\nManual Connection"
    fi
  else
    echo "$3"
  fi
}

function rofi_cmd () {
  # don't repeat lines with uniq -u
  echo -e "$1" | uniq -u | rofi -dmenu -p "Wi-Fi SSID" -lines "$LINENUM" \
    -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -width "$RWIDTH"
}

function rofi_menu () {
    TOGGLE=$(toggle_wifi)
    CURRCONNECT=$(current_connection)
    [[ "$TOGGLE" =~ 'Enable' ]] && LIST="" || LIST=$(nmcli_list)

    MENU=$(menu "$LIST" "$CURRCONNECT" "$TOGGLE")

    LINENUM=$(linenum "$LIST")
    RWIDTH=$(rwidth "$LIST" "$TOGGLE")

    rofi_cmd "$MENU"
}

function get_ssid () {
    # get fields in order
    #eval FIELDSARR=( $(cat ./nmcli.config | awk 'BEGIN { FS=","; OFS="\n" } /^FIELDS/ \
    #  { $1 = substr($1, 8); print $0; }') )

    eval FIELDSARR=$FIELDS

    # get position of SSID field
    for i in "${!FIELDSARR[@]}"; do
      if [[ "${FIELDSARR[$i]}" = "SSID" ]]; then
          SSID_POS="${i}";
      fi
    done

    # let for arithmetical vars
    let AWKSSIDPOS=$SSID_POS+1

    # get SSID from AWKSSIDPOS
    CHSSID=$(echo "$1" | awk -v"AWKSSIDPOS=$AWKSSIDPOS" '{print $AWKSSIDPOS;}')
    echo "$CHSSID"
}

function cleanup_networks () {
  nmcli --fields UUID,TIMESTAMP-REAL,DEVICE con show | grep -e '--' |  awk '{print $1}' \
    | while read line; do nmcli con delete uuid $line; done
}

function main () {
    OPS=$(rofi_menu)
    CHSSID=$(get_ssid "$OPS")

    if [[ "$OPS" =~ 'Disable' ]]; then
      nmcli radio wifi off

    elif [[ "$OPS" =~ 'Enable' ]]; then
      nmcli radio wifi on

    elif [[ "$OPS" =~ 'Disconnect' ]]; then
      nmcli con down uuid $CURRUUID
      cleanup_networks

    elif [[ "$OPS" =~ 'Manual' ]]; then
      # Manual entry of the SSID
      MSSID=$(echo -en "" | rofi -dmenu -p "SSID" -mesg "Enter the SSID of the network" \
        -lines 0)

      # manual entry of the PASSWORD
      MPASS=$(echo -en "" | rofi -dmenu -password -p "PASSWORD" -mesg \
        "Enter the PASSWORD of the network" -lines 0)

      # If the user entered a manual password, then use the password nmcli command
      if [ "$MPASS" = "" ]; then
        nmcli dev wifi con "$MSSID"
      elif [ "$MSSID" != '' ] && [ "$MPASS" != '' ]; then
        nmcli dev wifi con "$MSSID" password "$MPASS"
      fi

    else
        if [[ "$OPS" =~ "WPA2" ]] || [[ "$OPS" =~ "WEP" ]]; then
          WIFIPASS=$(echo -en "" | rofi -dmenu -password -p "PASSWORD" \
            -mesg "Enter the PASSWORD of the network" -lines 0)
        fi

        if [[ "$CHSSID" != '' ]] && [[ "$WIFIPASS" != '' ]]; then
          nmcli dev wifi con "$CHSSID" password "$WIFIPASS"
        fi
    fi
}

# clean up obsoleted connections
# nmcli --fields UUID,TIMESTAMP-REAL,DEVICE con show | grep never |  awk '{print $1}' | while read line; do nmcli con delete uuid $line; done

main
