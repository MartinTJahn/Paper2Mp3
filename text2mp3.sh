#!/bin/bash

# Modified from https://gist.github.com/kentbye/3843248 with j

# Dependencies on Mac
#brew install lynx
#brew install ffmpeg

# Prep steps:
	# Copy weblink to paper to clipboard
	# run script on bash "text2mp3_v1.sh -t Title -i WebLink"
    	# see usage examples below

#usage="text2mp3 [-h] [-j -l -t] -- program to transform papers into mp3
#where:
#    -h  show this help text
#    -j  set journal format [NatCom,NatRevMicro,Nature,MucosalImmo] 
#    -l  set link to paper 
#    -t  mp3 title"

while getopts t:l:j: option
do
case "${option}"
in
t) TITLE=${OPTARG};;
l) LINK=${OPTARG};;
j) JOURNAL=${OPTARG};;
esac
done

echo $TITLE
echo $LINK


# Format papers

if [ "$JOURNAL" == "NatCom" ]; then
    `lynx -dump -accept_all_cookies -hiddenlinks=ignore -nonumbers -nolist $LINK |
    LC_CTYPE=C sed -n -e '/Abstract/,$p' |
    awk '{if (match($0,"Methods")) exit; print}'  |
    awk -v RS='' '!/Full size image/'   |
    sed 's/\^[^P]*\./\./g' | sed 's/\^[^P]*\./ /g'   > $TITLE.txt`;
elif [ "$JOURNAL" == "NatRevMicro" ]; then
   `lynx -dump -accept_all_cookies -hiddenlinks=ignore --display_charset=utf-8 -nonumbers -nolist $LINK | 
    LC_CTYPE=C sed -n -e '/Abstract/,$p' | 
    awk -v RS='' '!/Full size image/' | 
    grep -v "You have full access to this article via your institution." | 
    grep -v "Download PDF" | sed 's/\^[^P]*\./\./g' | sed 's/\^[^P]*\,/,/g'  |
    awk '{if (match($0,"References")) exit; print}' > $TITLE.txt`;
elif [ "$JOURNAL" == "Nature" ]; then
    `lynx -dump -accept_all_cookies -hiddenlinks=ignore --display_charset=utf-8 -nonumbers -nolist $LINK | 
    LC_CTYPE=C sed -n -e '/Abstract/,$p' | 
    awk -v RS='' '!/Full size image/' | 
    grep -v "You have full access to this article via your institution." | 
    grep -v "Download PDF" | sed 's/\^[^P]*\./\./g' | sed 's/\^[^P]*\,/,/g'  |
    awk '{if (match($0,"References")) exit; print}' > $TITLE.txt`;
elif [ "$JOURNAL" == "MucosalImmo" ]; then
    `lynx -dump -accept_all_cookies -hiddenlinks=ignore --display_charset=utf-8 -nonumbers -nolist $LINK | 
    LC_CTYPE=C sed -n -e '/Abstract/,$p' | 
    awk -v RS='' '!/Full size image/' | 
    grep -v "You have full access to this article via your institution." | 
    grep -v "Download PDF" | sed 's/\^[^P]*\./\./g' | sed 's/\^[^P]*\,/,/g'  |
    awk '{if (match($0,"Methods")) exit; print}' > $TITLE.txt`;
elif [ "$JOURNAL" == "ISMEJ" ]; then
    `lynx -dump -accept_all_cookies -hiddenlinks=ignore --display_charset=utf-8 -nonumbers -nolist $LINK | 
    LC_CTYPE=C sed -n -e '/Abstract/,$p' | 
    awk -v RS='' '!/Full size image/' | 
    grep -v "You have full access to this article via your institution." | 
    grep -v "Download PDF" | sed 's/\^[^P]*\./\./g' | sed 's/\^[^P]*\,/,/g'  |
    awk '{if (match($0,"References")) exit; print}' > $TITLE.txt`;
else
   echo "Unknown parameter"
fi

echo "converting $LINK to .aiff";
#`say -f tmp.txt -r 150 -o $FILE.aiff --progress`; # system default
`say -v "Serena" -f $TITLE.txt -r 150 -o tmp.aiff --progress`; # Kate

echo "conververting to .mp3";
`ffmpeg -i tmp.aiff $TITLE.mp3`;

rm tmp.aiff

