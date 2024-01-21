#!/usr/bin/env bash

OUTPUT_NAME="${1?'No output name was passed !'}"

[[ ! "${OUTPUT_NAME}" == *.mp4  ]] && {
    echo "File name must end with '.mp4' !." >&2
    exit 1
}

ffmpeg \
    -f pulse \
    -ac 1 \
    -thread_queue_size 512 \
    -i default \
    -f v4l2 \
    -input_format mjpeg \
    -thread_queue_size 512 \
    -i /dev/video0 \
    -c:v libx264 \
    -preset ultrafast \
    "${OUTPUT_NAME}"
