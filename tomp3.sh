#!/bin/bash
#############
# transfrom audio/video file into mp3 format

# usage:
#     tomp3.sh <file_to_be_transformed>

#############

sourcefile=$1

basename=$(basename "$sourcefile")

filename="${basename%.*}"

echo $filename


mencoder -of rawaudio -oac mp3lame -ovc copy \
    -o $filename.mp3 $sourcefile
