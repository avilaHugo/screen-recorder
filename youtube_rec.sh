#!/usr/bin/env bash

NOW=$( date +"%Y_%m_%d-%H_%M_%S"  )
OUTPUT_PREFIX="${1?'No OUTPUT_PREFIX was passed !'}-${NOW}"
DIRNAME=$(dirname ${OUTPUT_PREFIX} )
STOP_SIGN="$( mktemp -p ${DIRNAME} -t STOP_SIGN.XXXXXX )"


# This configs work for my setup, check the commands before
# attempting to use it.

# Grab screen (no audio)
< "${STOP_SIGN}" ffmpeg \
    -f x11grab -video_size '1920x1080' -framerate 30 -thread_queue_size 1024 -i "${DISPLAY}" \
    -c:v libx264rgb -crf 0 -color_range 2 \
    -preset ultrafast \
    "${OUTPUT_PREFIX}.screen.mp4" &>/dev/null &

# Record webcan feed with its audio 
< "${STOP_SIGN}" ffmpeg \
    -y \
    -f alsa  -ac 2 -ar 48000  -i 'default' \
    -f v4l2 -input_format mjpeg -framerate 30 -video_size '640x480' -thread_queue_size 1024 -i /dev/video0 \
    -b:a 256k -c:a pcm_s16le \
    -c:v libx264  \
    -preset ultrafast  \
    "${OUTPUT_PREFIX}.webcan.mp4" &>/dev/null &

while :; do
    # Here we are prompting the user for the stop sign (the letter q).
    read -p 'Press [q] To stop recording ... ' Q

    [[  ${Q} != 'q' ]] && {
        echo "You did not press [q], received: ${Q}"
        continue
    }

    # ffmepg can read the 'q' from a file passed on the stdin
    # so here we are writting to the STOP_SIGN file to signal
    # the ffmpeg instances to stop gracefully. This is VERY IMPORTANT !!!
    # Althought newer versions say that you can scape it with Ctrl+C
    # doing so might lead to a broken file.
    echo "${Q}" > "${STOP_SIGN}"

    # Let's wait the instances finish.
    wait

    #+TODO (hugo.avila): Add a trap for this.
    rm -v "${STOP_SIGN}"

    exit 0
done
