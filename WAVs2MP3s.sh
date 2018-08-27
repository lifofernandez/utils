#!/usr/bin/env bash
# Convert given WAVs to MP3 and nomalize if bigger than min_dur 
# Depends on: sox, bc and ffmpeg

min_dur=60

for f in $@
do
	if [  ${f: -4} == ".wav" ]; then
		duration=$(soxi -D $f)
		long_enough=$(bc <<< "$duration > $min_dur")
		if [ $long_enough -eq 1 ]; then
			printf "\n##### PROCESANDO: $f #####\n"
			ffmpeg -i "$f" \
			-af loudnorm \
			-ar 48k \
			-codec:a libmp3lame \
			-qscale:a 2 "$f.mp3"
		fi
	fi
done


#norm_st1="I=-16:TP=-1.5:LRA=11:measured_I=-27.61:measured_LRA=18.06:"
#norm_st2="measured_TP=-4.47:measured_thresh=-39.20:offset=0.58:"
#norm_st3="linear=true:print_format=summary"
#norm_st="$norm_st1$nomr_st2$norm_st3"
# ESTUDIAR: http://k.ylo.ph/2016/04/04/loudnorm.html
#-af loudnorm="$norm_st" \
