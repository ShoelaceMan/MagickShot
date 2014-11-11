#!/bin/bash

#### Variables

# Constants
DZEN2="$(pidof dzen2)"
SLEEP=1

# Font
FONT="-artwiz-cure-medium-r-normal-*-14-*-*-*-*-*-*-*"

# Colors
BG="#151515"
FG="#303030"

OFFWHITE="#E7E7E7"

WHITE="#FFFFFF"

RED="#E84F4F"

GREEN="#B8D68C"

YELLOW="#E1AA5D"

BLUE="#7DC1CF"

MAGENTA="#9B64FB"

CYAN="#0088CC"

# Geometry
HEIGHT=20
WIDTH=20
X=1115
Y=272

#### Script
# Filename
_now=$(date +"%m_%d_%Y_%T")
_file="Documents/Pictures/Screenshots/Arch/Screenshot_$_now.png"

while :; do

echo " ^fg($WHITE)Uploading...
 ^ib(2)^fg($BLUE)"Screenshot saved as "$_now"!"^pa(2)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $Y -x $X -fn $FONT -l 1 -w 485 -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

# Command
scrot -c "$_file"
/home/trent/Documents/Scripts/Applets/imgurup.sh $_file > /tmp/ScrotUM
grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip -sel c
grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip

convert $_file -resize 500x272 test.xpm

# Message
while :; do

echo "^fg($WHITE) $(grep -o 'Original Image:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) $(grep -o 'Large Thumbnail:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m2 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) $(grep -o 'Small Thumbnail:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m3 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) $(grep -o 'Imgur Page:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m4 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) $(grep -o 'Delete Page:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m5 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
 ^ib(2)^fg($BLUE)"Screenshot saved as "$_now"!"^pa(2)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $Y -x $X -fn $FONT -l 5 -w 485 -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

cat /tmp/ScrotUM

# Thumbnail
Y=0

while :; do

echo "^i(/home/trent/test.xpm)"

done | dzen2 -p -bg $BG -fg $YELLOW -y $Y -x $X -fn $FONT -w 500 -h 272 -ta l -e "onstart=uncollapse;button2=exit" -p 7 &

# Kill
if [[ "$DZEN2" -gt 0 ]];
then
    sleep 6 && killall ScrotUM.sh & exit
else
    sleep 6 && killall dzen2 & exit
fi

