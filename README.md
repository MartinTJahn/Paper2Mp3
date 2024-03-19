# Paper2Mp3
> A script that converts a paper to a .mp3 file




_Preparations - Install dependencies_

```
brew install lynx
brew install ffmpeg
```
_Preparations - Download script_
```
wget https://raw.githubusercontent.com/MartinTJahn/Paper2Mp3/main/text2mp3.sh
```

_Usage_
```
bash text2mp3_v1.sh -j "Nature" -t "MP3Title" -i "WebLink"

where:
    -j  set journal format [NatCom,NatRevMicro,Nature,MucosalImmo] 
    -l  set link to paper 
    -t  mp3 title
```

1. Copy weblink to paper and add it instead of "WebLink" 
2. Select Journal [for formatting purposes]
3. Give it a mp3 a title
4. Run the script


_Usage Examples:_

```
bash text2mp3.sh  -j "Nature" -t "Baeumler_et_al_Interactions_between_microbiota_and_pathogen_in_gut" -l "https://www.nature.com/articles/nature18849"

bash text2mp3.sh -l "https://www.nature.com/articles/npjbiofilms20155" -j "MucosalImmo" -t "deVos_2014" 

bash text2mp3.sh -t "Worrich_et_al_2019_Associational_effects_in_the_microbial_neighborhood" -l https://www.nature.com/articles/s41396-019-0444-6 -j "ISMEJ"

bash text2mp3.sh -t "WEISS_2021_ISMEJ" -l "https://www.nature.com/articles/s41396-021-01153-z" -j "ISMEJ"

bash text2mp3.sh  -j "NatRevMicro" -t "Sorbara_2022_Microbiome_based_therapeutics_NatRevMicro" -l "https://www.nature.com/articles/s41579-021-00667-9"

bash text2mp3.sh  -j "NatCom" -t "Monaco_2022_SpatioTemp_and_Cheating" -l "https://www.nature.com/articles/s41467-022-28321-9"

bash text2mp3.sh  -j "NatCom" -t "Kauffman_2022_StructureInPhage-bacteria_interct_NatCom" -l "https://www.nature.com/articles/s41467-021-27583-z"
```

runs on MacOS 
