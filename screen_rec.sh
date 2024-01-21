#!/usr/bin/env bash

OUTPUT_NAME="${1?'No output name was passed !'}"

[[ ! "${OUTPUT_NAME}" == *.mkv  ]] && {
    echo "File name must end with '.mkv' !." >&2
    exit 1
}

ffmpeg \
    -video_size '1920x1080' \
    -framerate 30 \
    -f x11grab \
    -i $DISPLAY \
    -c:v libx264rgb \
    -crf 0 \
    -preset ultrafast \
    -color_range 2 \
    "${OUTPUT_NAME}"

