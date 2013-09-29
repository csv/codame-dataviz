#/bin/bash


# $1 = frame rate
# $2 = input dir
# $3 = input path pattern
# $4 = output file
# usage - sh mkvid.sh 6.66 frames frame-%04d.jpg crash.mov
slash="/"
png="*png"
input_files=$2$slash$png
input_file_pattern=$2$slash$3 
mogrify -format jpg $input_files
rm $input_files
ffmpeg -y -f image2 -r $1 -i $input_file_pattern -r $1 $4