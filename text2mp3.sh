#!/bin/bash
# Modified from https://gist.github.com/kentbye/3843248 with j
# Converts a paper to .mp3 with 150 words per minute 

# Dependencies on Mac
#brew install lynx
#brew install ffmpeg

# Prep steps:
	# Copy weblink to paper to clipboard
	# run script on bash "text2mp3_v1.sh -t Title -i WebLink"
    # see examples below


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


# Example use

'''

## NatCom
#bash text2mp3_v6_directfromweb.sh  "testi" "https://www.nature.com/articles/s41467-021-25073-w"

## NatRevMicro
#bash text2mp3_v6_directfromweb.sh  -j "NatRevMicro" -t "Galan_Samonella_and_Inflammation" -l "https://www.nature.com/articles/s41579-021-00561-4"

# Nature
#bash text2mp3_v6_directfromweb.sh  -j "Nature" -t "Baeumler_et_al_Interactions_between_microbiota_and_pathogen_in_gut" -l "https://www.nature.com/articles/nature18849"

## Mucosal Immunity
#bash text2mp3_v6_directfromweb.sh  "Fattinger_Salmonella_Induced_tissue_destruction" "https://www.nature.com/articles/s41385-021-00381-y#Sec10"


#bash text2mp3_v6_directfromweb.sh  -j "Nature" -t "Baeumler_et_al_Interactions_between_microbiota_and_pathogen_in_gut" -l "https://www.nature.com/articles/nature18849"
#bash text2mp3_v6_directfromweb.sh -l "https://www.nature.com/articles/npjbiofilms20155" -j "MucosalImmo" -t "deVos_2014" 
#bash text2mp3_v6_directfromweb.sh -t "Worrich_et_al_2019_Associational_effects_in_the_microbial_neighborhood" -l https://www.nature.com/articles/s41396-019-0444-6 -j "ISMEJ"
#bash text2mp3_v6_directfromweb.sh -t "WEISS_2021_ISMEJ" -l "https://www.nature.com/articles/s41396-021-01153-z" -j "ISMEJ"
#bash text2mp3_v6_directfromweb.sh  -j "NatRevMicro" -t "Sorbara_2022_Microbiome_based_therapeutics_NatRevMicro" -l "https://www.nature.com/articles/s41579-021-00667-9"
#bash text2mp3_v6_directfromweb.sh  -j "NatCom" -t "Monaco_2022_spatioTemp_and_cheatinf_NatCom" -l "https://www.nature.com/articles/s41467-022-28321-9"
#bash text2mp3_v6_directfromweb.sh  -j "NatCom" -t "Kauffman_2022_StructureInPhage-bacteria_interct_NatCom" -l "https://www.nature.com/articles/s41467-021-27583-z"

#bash text2mp3_v6_directfromweb.sh  -j "NatRevMicro" -t "Tropini_Gut_Geo_NatRevMicro" -l "https://www.nature.com/articles/s41579-023-00969-0"

'''
