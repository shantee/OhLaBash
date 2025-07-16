#!/bin/bash
clear;stty raw -echo;tput civis;tput rmam;printf '\e[8;35;146t' 

BLUE='\033[1;34m'
GREEN='\033[0;32m'
RESET='\033[0m'

RATE=8000 
FMT="s16le"
CH=1
BYTES=3200 
SAMPDIR="raw"


# zic 
a1=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00) 
a2=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 s5)
a3=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00)
a4=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 )
PAT_A=(a1 a2 a3 a4)


b1=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00) 
b2=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 s5)
b3=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00)
b4=(00 00 00 00  00 00 00 00  00 00 00 00  sb 00 00 00)
PAT_B=(b1 b2 b3 b4)

c1=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00) 
c2=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 s5)
c3=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00)
c4=(00 00 00 00  00 00 00 00  00 00 00 00  sc 00 00 sc)
PAT_C=(c1 c2 c3 c4)

d1=(s8 s8 s4 s9  s8 s8 s8 s9  s8 s9 s8 s9  s8 s9 s8 s9)
d2=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 s5)
d3=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00)
d4=(00 00 00 s3  s3 s6 00 00  00 00 00 00  00 00 00 00)
PAT_D=(d1 d2 d3 d4)

e1=(s8 s8 s4 s9  s8 s8 s8 s9  s8 s9 s8 s9  s8 s9 s8 s9)
e2=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 s5)
e3=(00 00 00 00  00 00 00 00  00 00 00 00  00 00 00 00)
e4=(sb sc sb sc  sb sc sb sc  sb sc sb sc  sb sc sb sc)
PAT_E=(e1 e2 e3 e4)


f1=(s5 s5 s5 s5  s5 s5 s5 s5  s5 s5 s5 s5  s5 s5 s5 s5)
f2=(s8 s9 s8 s9  s8 s9 s8 s9  s8 s9 s8 s9  s8 s9 s8 s9)
f3=(s4 s4 s4 s4  s4 s4 s4 s4  s4 s4 s4 s4  s4 s4 s4 s4)
f4=(s5 00 s5 00  s5 00 s5 00  s5 00 s5 00  s5 00 s5 00)
PAT_F=(f1 f2 f3 f4)

SEQUENCE=(
    PAT_A PAT_A PAT_A PAT_B PAT_C PAT_E PAT_E PAT_F PAT_F
)

demo() {
SCREEN_WIDTH=$(tput cols)
SCREEN_HEIGHT=$(tput lines)
genSamples
clear;stty raw -echo;tput civis;tput rmam;printf '\e[8;35;146t' 
introTxt
titre;
sleep 2;

music & 
preZic
rndf                
MUSIC_PID=$!
dance 
meumeu
meumeu

wait "$MUSIC_PID" 

clear
echo -e "bye bye!\n"
reset-term;
}



reset-term() {
  stty sane; tput cnorm; tput smam          
}
## Hello Shadow Party !
txtCenter() {
  txt="$1"
  color="${2:-\e[0m}"  # Couleur optionnelle
  cx=$(( (SCREEN_WIDTH - ${#txt}) / 2 ))
  cy=$(( SCREEN_HEIGHT / 2 ))
  echo -en "\e[$((cy));${cx}H${color}${txt}\e[0m"
}
sp(){
clear;
txtCenter " . 🌭 ౭ℎลd∅w ℘arty 🍻 .    ";
spd-say -p -100 -R -100 -r -100   " shadow partyeeee" & sleep 2.5
clear;
}
## SAMPLES ###
mkdir -p samples
genSamples() {
  mkdir -p raw
  echo -ne "${BLUE}Making samples   ${RESET}"
  s0='/usr/share/sounds/alsa/Noise.wav'
  s1='/usr/share/sounds/alsa/Front_Left.wav'
  s2='/usr/share/sounds/alsa/Front_Right.wav'
  s3='/usr/share/sounds/sound-icons/cockchafer-gentleman-1.wav'
  s4='/usr/share/sounds/sound-icons/chord-7.wav'
  s5='/usr/share/sounds/sound-icons/cymbaly-1.wav'
  s6='/usr/share/sounds/sound-icons/guitar-13.wav'
  s7='/usr/share/sounds/sound-icons/canary-long.wav'
  s8='/usr/share/sounds/sound-icons/pipe.wav'
  s9='/usr/share/sounds/sound-icons/glass-water-1.wav'
  sa='/usr/share/sounds/sound-icons/trumpet-1.wav'
  sb='/usr/share/sounds/sound-icons/percussion-10.wav'

  makeRaw() {
  
    local varname="$1"
    local wavfile="${!varname}"
    local rawname="raw/${varname}.raw"
     if [[ -f "$wavfile" ]]; then
      tail -c +45 "$wavfile" > "$rawname"
      echo -ne "${GREEN}.${RESET}"
    else
      echo -ne "\033[1;31mx${RESET}" 
    fi
  }
  for var in s{0..9}; do
    cp  ${!var} samples/$var".wav"; 
    makeRaw "$var"
    sleep 0.2
  done

dd if=/usr/share/sounds/alsa/Front_Left.wav bs=1 skip=71044 of=raw/sb.raw status=none
echo -ne "${GREEN}.${RESET}"; sleep 0.3;
dd if=/usr/share/sounds/alsa/Front_Right.wav bs=1 skip=84044 of=raw/sc.raw status=none
echo -ne "${GREEN}.${RESET}"; sleep 0.3;
echo -ne "\n";  
}

music() {

    local tmpdir
    tmpdir=$(mktemp -d ./tmp_render.XXXXXX)

    render_track () {
        local name=$1; local -n arr=$name
        local file="$tmpdir/${name}.raw"; >"$file"
        for s in "${arr[@]}"; do
            if [[ $s == 00 ]]; then
                dd if=/dev/zero bs=$BYTES count=1 status=none >>"$file"
            else
                src="$SAMPDIR/$s.raw"
                [[ -f $src ]] || { echo "⚠️ missing $src" >&2; src=/dev/zero; }
                dd if="$src" bs=$BYTES count=1 conv=sync,noerror status=none >>"$file"
            fi
        done
        echo "$file"
    }

    declare -a MASTER
    eval "first_array=(\"\${${SEQUENCE[0]}[@]}\")"
    for ((i=0;i<${#first_array[@]};i++)); do
        MASTER+=("$tmpdir/master_${i}.raw"); >"${MASTER[i]}"
    done

    for patname in "${SEQUENCE[@]}"; do
        eval "tracks=(\"\${${patname}[@]}\")"
        for i in "${!tracks[@]}"; do
            seg=$(render_track "${tracks[i]}")
            cat "$seg" >> "${MASTER[i]}"
        done
    done
    for f in "${MASTER[@]}"; do
        paplay --raw --format=$FMT --rate=$RATE --channels=$CH "$f" &
    done
    wait         
    rm -rf "$tmpdir"
}

titre() {  framebuffer=""
  local RESET="\e[0m"
  local width=146
  local center_y=$(( (SCREEN_HEIGHT - 35) / 2 ))


  local top_start=18
  local top_end=51
  for ((y=0; y<11; y++)); do
    local color=$(( top_start + ( (top_end - top_start) * y / 10 ) ))
    framebuffer+="\e[$((center_y + y + 1));1H\e[38;5;${color}m$(printf '▒█%.0s' $(seq 1 $width))${RESET}"
  done

  framebuffer+="\e[$((center_y +12));1H\e[38;5;201m$(printf '※%.0s' $(seq 1 $width))${RESET}"

  for ((y=13; y<23; y++)); do
    framebuffer+="\e[$((center_y + y));1H"
  done

  framebuffer+="\e[$((center_y +23));1H\e[38;5;201m$(printf '※%.0s' $(seq 1 $width))${RESET}"

  for ((y=0; y<12; y++)); do
    local color=$(( top_end - ( (top_end - top_start) * y / 11 ) ))
    framebuffer+="\e[$((center_y +24 + y));1H\e[38;5;${color}m$(printf '█▒%.0s' $(seq 1 $width))${RESET}"
  done


  local titr=(
    "  ┏┓┓ ╻  ┓    ┳┓   ┓ ╻"
    "  ┃┃┣┓┃  ┃┏┓  ┣┫┏┓┏┣┓┃"
    "  ┗┛┛┗಄  ┗┗┻  ┻┛┗┻┛┛┗಄"
  )
  local vach=(
    "  "
    "     _(__)_    ______"
    "      '-◕ ◕ -' < Meuh ! >"
    "     (o_o)     ──────"
    "‿      "
  )
echo -en "${framebuffer}"
for blink in {1..6}; do
  framebuffer=""

  if (( blink % 2 == 0 )); then
    title_color="\e[38;5;226m"  # jaune
  else
    title_color="\e[38;5;16m"  
  fi

  for i in "${!titr[@]}"; do
    local line="${titr[i]}"
    local x=$(( (SCREEN_WIDTH - ${#line}) / 2 ))
    local y=$((center_y + 14 + i))
    framebuffer+="\e[$y;${x}H${title_color}${line}${RESET}"
  done

  echo -en "${framebuffer}"
  sleep 0.3
done

  for i in "${!vach[@]}"; do
    local line="${vach[i]}"
    local x=$(( (SCREEN_WIDTH - ${#line}) / 2 ))
    local y=$((center_y + 17 + i))
    framebuffer+="\e[$y;${x}H\e[38;5;82m$line${RESET}"
  done

  echo -en "${framebuffer}"
  spd-say -p -1 -R -0 -r -00   "meuheuheuheuheuheuheu" && sleep 0.5;

  sleep 1.5

}
boxCenter() {

clear;stty raw -echo;tput civis;tput rmam;printf '\e[8;35;146t' 
  local text="$1"
  local color="${2:-\e[0m}"  # Couleur par défaut = reset
  local min_width=10
  local text_width=${#text}
  local inner_width=$(( text_width > min_width ? text_width : min_width ))
  local width=$(( inner_width + 4 ))   # +4 pour bordures
  local height=5
  local center_x=$(( (SCREEN_WIDTH - width) / 2 ))
  local center_y=$(( (SCREEN_HEIGHT - height) / 2 ))

  framebuffer=""

  # lignes
  for ((y=0; y<height; y++)); do
    for ((x=0; x<width; x++)); do
      local draw_x=$((center_x + x))
      local draw_y=$((center_y + y))
      if (( y == 0 || y == height-1 )); then
        framebuffer+="\e[$((draw_y+1));$((draw_x+1))H═"
      elif (( x == 0 || x == width-1 )); then
        framebuffer+="\e[$((draw_y+1));$((draw_x+1))H║"
      fi
    done
  done

  # coins
  framebuffer+="\e[$((center_y+1));$((center_x+1))H╔"
  framebuffer+="\e[$((center_y+1));$((center_x+width))H╗"
  framebuffer+="\e[$((center_y+height));$((center_x+1))H╚"
  framebuffer+="\e[$((center_y+height));$((center_x+width))H╝"

  pad=$(( (inner_width - text_width) / 2 ))
  framebuffer+="\e[$((center_y+height/2+1));$((center_x+3+pad))H${color}${text}\e[0m"

  echo -en "${framebuffer}"
}

introTxt() {
boxCenter "I made this 10k demo"; sleep 1.5; clear;
boxCenter "for the terminal"; sleep 1.5; clear;
boxCenter "in pure bash !!" "\e[38;5;226m"; sleep 1.9; clear;
boxCenter "it can run on any GNU/Linux distro"; sleep 2.0; clear;
boxCenter "without any dependencies "; sleep 1.5; clear;
boxCenter "no FFMPEG"; sleep 0.6; clear;
boxCenter "no SOX"; sleep 0.5; clear;
boxCenter "no PYTHON"; sleep 0.4; clear;
boxCenter "no WINDOWS"; sleep 0.3; clear;
boxCenter "no MACOS"; sleep 0.25; clear;
boxCenter "no INSTALL"; sleep 0.2; clear;
boxCenter "no APT-GET"; sleep 0.15; clear;
boxCenter "no NODE"; sleep 0.12; clear;
boxCenter "no JS"; sleep 0.1; clear;
boxCenter "no SHADER"; sleep 0.1; clear;
boxCenter "no PAIN"; sleep 0.09; clear;
boxCenter "no GAIN"; sleep 0.08; clear;
boxCenter "no SUDO"; sleep 0.06; clear;
boxCenter "just BASH" "\e[38;5;51m"; sleep 0.991; clear;
boxCenter "it's called "; sleep 1.0; clear;
}

meumeu() {
spd-say -p -100 -R -100 -r -100   "meumeu" && sleep 1
spd-say -p -10 -R -100 -r -100   "meumeu" && sleep 1 
spd-say -p -1 -R -100 -r -100   "meumeu" && sleep 1 
}
preZic() {
  local RESET="\e[0m"
  local groove_text="Ⓖⓡⓞⓞⓥⓔ 🅖🅡🅞🅞🅥🅔 Ⓖⓡⓞⓞⓥⓔ 🅖🅡🅞🅞🅥🅔"
  clear
  txtCenter "are you ready to ..." "\e[38;5;226m"
  sleep 2
  clear

  local groove="Ⓖⓡⓞⓞⓥⓔ 🅖🅡🅞🅞🅥🅔 "
  local fulltext=""

  while (( ${#fulltext} < SCREEN_WIDTH * 2 )); do
    fulltext+="$groove"
  done


  local -a colors
  local start_color=18   
  local end_color=51     
  for ((y=0; y<SCREEN_HEIGHT; y++)); do
    colors[$y]=$(( start_color + ((end_color - start_color) * y / (SCREEN_HEIGHT-1)) ))
  done

  for shift in {0..80}; do
    framebuffer=""
    for ((y=1; y<=SCREEN_HEIGHT; y++)); do
      local color="${colors[y-1]}"
      local start=$((shift % ${#groove}))
      local line="${fulltext:start}"
      line="${line:0:SCREEN_WIDTH}"
      framebuffer+="\e[${y};1H\e[38;5;${color}m${line}${RESET}"
    done
    echo -en "${framebuffer}"
    sleep 0.1
  done
}


rndFill() {
  local -n emoji_array=$1
  for ((y=0; y<SCREEN_HEIGHT; y++)); do
    line=""
    for ((x=0; x<SCREEN_WIDTH; x++)); do
      emoji=${emoji_array[$((RANDOM % ${#emoji_array[@]}))]}
      line+="$emoji"
    done
    echo -en "\e[$((y+1));1H$line"
  done
}
clear_box_area() {
  local text="$1"
  local width=$(( ${#text} + 4 ))
  local height=5
  local center_x=$(( (SCREEN_WIDTH - width) / 2 ))
  local center_y=$(( (SCREEN_HEIGHT - height) / 2 ))
for ((y=0; y<height; y++)); do
echo -en "\e[$((center_y + y + 1));$((center_x + 1))H"
printf "%*s" "$width" " " 
done
}

rndf() {
clear
m1=(⭕ ❌)
m2=(🔷 🟠 🟡 🔶 🟧 🟦)
m3=(🟧 🟦)
m4=(🟨 🟩 🟪 🟫 ⬛ ⬜ 🔲)
m5=(🔴 🟠 🟡 🟢 🔵 🟣 🟤 ⚪ ⚫)
m6=(🔵 🟣 🟤)
m7=(░ ▒ ▓ █ ▄ )
for ((repeat=0; repeat<30; repeat++)); do
clear_box_area "LET'S GO  !!!"
txtCenter "LET'S GO !!!"
sleep 0.08
rndFill m7
sleep 0.05
done
}
dance() {
frames=(
"\
  ︵
 ◕˾◕
_( )_
 ( )
 (‿)
 / \\"
"\
     ︵
    ◕˽◕
  _( )_
  ( )
 (‿)
 / \\"
"\
  ︵
 ◕˽◕
_( )_
  ( )
   (‿)
   / \\"
)

  local center_y=$(( SCREEN_HEIGHT / 2 - 3 ))
  local frame_lines=6

  for ((i=0; i<30; i++)); do
  framebuffer=""

  for ((y=0; y<frame_lines; y++)); do
    local clear_y=$((center_y + y))
    framebuffer+="\e[${clear_y};1H$(printf ' %.0s' $(seq 1 $SCREEN_WIDTH))"
  done

  local color=$((16 + RANDOM % 240))
  local frame="${frames[i % 3]}"

  local y=$center_y
  while IFS= read -r line; do
    local x=$(( (SCREEN_WIDTH - ${#line}) / 2 ))
    framebuffer+="\e[${y};${x}H\e[38;5;${color}m${line}"
    ((y++))
  done <<< "$frame"

  echo -en "${framebuffer}"
  sleep 0.2
done

}

demo; 

