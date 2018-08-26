#!/usr/bin/env bash
# Convert files in given folder to mp3 if bigger than min_dur
# Depends on: sox, bc and ffmpeg

min_dur=60
folder="./"
files="$folder*"

for f in $files
do
	duration=$(soxi -D $f)
	long_enough=$(bc <<< "$duration > $min_dur")
	if [ $long_enough -eq 1 ]; then
		echo "\n### Procesando: $f ###\n"
        ffmpeg -i "$f" \
		-af loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=-27.61:measured_LRA=18.06:measured_TP=-4.47:measured_thresh=-39.20:offset=0.58:linear=true:print_format=summary -ar 48k \
		-codec:a libmp3lame -qscale:a 2 "$f.mp3"
	fi
done


