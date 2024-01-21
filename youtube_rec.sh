#!/usr/bin/env bash

NOW=$( date +"%Y_%m_%d-%H_%M_%S"  )
OUTPUT_PREFIX="${1?'No OUTPUT_PREFIX was passed !'}-${NOW}"
DIRNAME=$(dirname ${OUTPUT_PREFIX} )
STOP_SIGN="$( mktemp -p ${DIRNAME} -t STOP_SIGN.XXXXXX )"

sleep 3 && < "${STOP_SIGN}" screen_rec.sh "${OUTPUT_PREFIX}.mkv" &>/dev/null &
sleep 3 && < "${STOP_SIGN}" webcan_rec.sh "${OUTPUT_PREFIX}.mp4" &>/dev/null &

while :; do
    read -p 'Press [q] To stop recording ...' Q
    [[ ${Q} == 'q' ]] && {
        echo "${Q}" > "${STOP_SIGN}"
        rm -v "${STOP_SIGN}"
        exit 0
    }
    echo "You did not press [q]: ${Q}"
done
  








