#!/bin/bash

DZEN2="$(pidof dzen2)"
SLEEP=1
CONFDIR=~/.ScrotUM

source "$CONFDIR/config"

WHOAMI=$(whoami)
RESX=$(xdpyinfo  | grep 'dimensions:' | tr ' ' '\n' | grep -m1 x | tr 'x' '\n' | grep -m1 '')
RESY=$(xdpyinfo  | grep 'dimensions:' | tr ' ' '\n' | grep -m1 x | tr 'x' '\n' | grep -m2 '' | tail -n1)
THUMBPOSY=$(expr 0 + $THUMBPADY)
THUMBPOSX=$(expr $RESX - $THUMBPADX)
NOTIFPOSX=$(expr $RESX - 485)
NOTIFPOSY=$THUMBHEIGHT
SAVEAS="/home/$WHOAMI/$SAVEPATH/Screenshot_$FILENAME.png"

# Command
scrot -c "$SAVEAS"
grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip -sel c
grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip

while :; do

echo " ^fg($WHITE)Uploading...
 ^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -l 1 -w 485 -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

# Uploader
for i in "$SAVEAS"; do
    curl -# -F "image"=@"$i" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" imgur.com/api/upload.xml|\
    grep -Eo '<[a-z_]+>http[^<]+'|sed 's/^<.\|_./\U&/g;s/_/ /;s/<\(.*\)>/\x1B[0;34m\1:\x1B[0m /'
done > /tmp/ScrotUM

convert $SAVEAS -resize $THUMBHEIGHTx$THUMBWIDTH /tmp/ScrotUMThumb.xpm

# Message
while :; do

echo "^fg($WHITE) $(grep -o 'Original Image:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) $(grep -o 'Large Thumbnail:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m2 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) $(grep -o 'Small Thumbnail:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m3 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) $(grep -o 'Imgur Page:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m4 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) $(grep -o 'Delete Page:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m5 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
 ^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -l 5 -w 485 -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

cat /tmp/ScrotUM

# Thumbnail

while :; do

echo "^i(/tmp/ScrotUMThumb.xpm)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $THUMBPOSY -x $THUMBPOSX -fn $FONT -w 500 -h 272 -ta l -e "onstart=uncollapse;button2=exit" -p 7 &

# Kill
if [[ "$DZEN2" -gt 0 ]];
then
    sleep 6 && killall ScrotUM.sh & exit
else
    sleep 6 && killall dzen2 & exit
fi

