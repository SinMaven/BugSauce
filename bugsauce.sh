#!/bin/sh

name=$(printf '%s' "$*" | sed 's/ /\%20/g')
curl -s -o url.html https://thepiratebay.party/search/$name/1/99/200
magnet=$(cat url.html | grep -E 'magnet\:\?' | sed 's/href\=/ /g' | awk '{print $2}' | sed 's/"/ /g' | head -n 1 | sed 's/ //g')

# Start streaming with peerflix and get the URL for the video stream
peerflix "$magnet" --path ./ -- --subtitles "./" -q -v --mpv &

# Wait for peerflix to start streaming
sleep 10

# Find the subtitle file (assuming it is in the same folder)
subtitle_file=$(find . -type f -name "*.srt" | head -n 1)

# Play the video with mpv and subtitle file if it exists
if [ -n "$subtitle_file" ]; then
    mpv --sub-file="$subtitle_file" http://localhost:8888
else
    mpv http://localhost:8888
fi

