#!/usr/bin/env bash
if [[ -z "$MIXER" ]] ; then
    MIXER="default"
    if command -v pulseaudio >/dev/null 2>&1 && pulseaudio --check ; then
        # pulseaudio is running, but not all installations use "pulse"
        if amixer -D pulse info >/dev/null 2>&1 ; then
            MIXER="pulse"
        fi
    fi
    [ -n "$(lsmod | grep jack)" ] && MIXER="jackplug"
    MIXER="${2:-$MIXER}"
fi
if [[ -z "$SCONTROL" ]] ; then
    SCONTROL="${BLOCK_INSTANCE:-$(amixer -D $MIXER scontrols |
                      sed -n "s/Simple mixer control '\([^']*\)',0/\1/p" |
                      head -n1
                    )}"
fi

# The first parameter sets the step to change the volume by (and units to display)
# This may be in in % or dB (eg. 5% or 3dB)
if [[ -z "$STEP" ]] ; then
    STEP="${1:-5%}"
fi

NATURAL_MAPPING=${NATURAL_MAPPING:-0}
if [[ "$NATURAL_MAPPING" != "0" ]] ; then
    AMIXER_PARAMS="-M"
fi

#------------------------------------------------------------------------

capability() { # Return "Capture" if the device is a capture device
  amixer $AMIXER_PARAMS -D $MIXER get $SCONTROL |
    sed -n "s/  Capabilities:.*cvolume.*/Capture/p"
}

volume() {
  amixer $AMIXER_PARAMS -D $MIXER get $SCONTROL $(capability)
}

format() {
  
  perl_filter='if (/.*\[(\d+%)\] (\[(-?\d+.\d+dB)\] )?\[(on|off)\]/)'
  perl_filter+='{CORE::say $4 eq "off" ? "MUTE" : "'
  # If dB was selected, print that instead
  perl_filter+=$([[ $STEP = *dB ]] && echo '$3' || echo '$1')
  perl_filter+='"; exit}'
  output=$(perl -ne "$perl_filter")
  echo "$LABEL$output"
}

#------------------------------------------------------------------------

case $BLOCK_BUTTON in
  3) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) toggle ;;  # right click, mute/unmute
  4) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) ${STEP}+ unmute ;; # scroll up, increase
  5) amixer $AMIXER_PARAMS -q -D $MIXER sset $SCONTROL $(capability) ${STEP}- unmute ;; # scroll down, decrease
esac

volume | format
