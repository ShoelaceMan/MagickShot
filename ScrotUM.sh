#!/bin/bash
#
# 2014 ShoelaceGuy <beast123113 at gmail dot com>
# ScrotUM (SCReen shOT Upload Manager)
#
# Licensed under WTFPL 2.0
# >> http://www.wtfpl.net/txt/copying/
#

DZEN2="$(pidof dzen2)"
SLEEP=1
CONFDIR=~/.ScrotUM

source "$CONFDIR/config"

WHOAMI=$(whoami)
RESX=$(xdpyinfo  | grep 'dimensions:' | tr ' ' '\n' | grep -m1 x | tr 'x' '\n' | grep -m1 '')
RESY=$(xdpyinfo  | grep 'dimensions:' | tr ' ' '\n' | grep -m1 x | tr 'x' '\n' | grep -m2 '' | tail -n1)
THUMBPOSY=$(expr 0 + $THUMBPADY)
THUMBPOSX=$(expr $RESX - $THUMBWIDTH - $THUMBPADX)
NOTIFPOSX=$(expr $RESX - $THUMBWIDTH)
NOTIFPOSY=$THUMBHEIGHT
SAVEAS="/home/$WHOAMI/$SAVEPATH/Screenshot_$FILENAME.png"

# Command
scrot -c "$SAVEAS"

# Thumbnail
convert $SAVEAS -resize $THUMBHEIGHTx$THUMBWIDTH /tmp/ScrotUMThumb.xpm
echo "^i(/tmp/ScrotUMThumb.xpm)" | dzen2 -p -bg $BG -fg $YELLOW -y $THUMBPOSY -x $THUMBPOSX -fn $FONT -w $THUMBWIDTH -h $THUMBHEIGHT -ta l -e "onstart=uncollapse;button2=exit" &


echo " ^fg($WHITE)Uploading...
^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)" | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -l 1 -w $THUMBWIDTH -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &


# Uploader
if [[ $UPLOADER = "imgur" ]]; then
    for i in "$SAVEAS"; do
        curl -# -F "image"=@"$i" -F "key"="4907fcd89e761c6b07eeb8292d5a9b2a" imgur.com/api/upload.xml|\
        grep -Eo '<[a-z_]+>http[^<]+'|sed 's/^<.\|_./\U&/g;s/_/ /;s/<\(.*\)>/\x1B[0;34m\1:\x1B[0m /'
    done > /tmp/ScrotUM
    grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip -sel c
    grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | xclip
    cat /tmp/ScrotUM
fi

if [[ $UPLOADER = "ftp" ]]; then
    wput $SAVEAS ftp://$FTPUSERNAME:$FTPPASSWD@$FTPIP:$FTPPORT/$FTPDIRECTORY > /tmp/ScrotUM
fi

if [[ $UPLOADER = "sftp" ]]; then
    sshpass -p '$SFTPPASSWORD' scp -P $SFTPPORT $SAVEFILE $SFTPUSERNAME@$SFTPIP:$SFTPDIRECTORY > /tmp/ScrotUM
fi


# Notifier
while [ $UPLOADER = "imgur" ]; do

# Message    
    echo "^fg($WHITE) $(grep -o 'Original Image:' /tmp/ScrotUM) ^fg($OFFWHITE)^pa(150)$(grep -o -m1 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) Large Thumbnail: ^fg($OFFWHITE)^pa(150)$(grep -o -m2 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) 
^fg($WHITE) Small Thumbnail: ^fg($OFFWHITE)^pa(150)$(grep -o -m3 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) Imgur Page: ^fg($OFFWHITE)^pa(150)$(grep -o -m4 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^fg($WHITE) Delete Page: ^fg($OFFWHITE)^pa(150)$(grep -o -m5 "http://.*imgur.*" /tmp/ScrotUM | tail -n1) ^pa(117)
^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)" 

    done | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -l 5 -w $THUMBWIDTH -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

while [ $UPLOADER = "ftp" ]; do
    # Message
    
    echo "^fg($WHITE) "Uploaded To:" ^fg($OFFWHITE)^pa(150)$( grep ftp:// /tmp/ScrotUM | tr ' ' '\n' | grep ftp://) 
^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)"

    done | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -l 1 -w $THUMBWIDTH -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

while [ $UPLOADER = "sftp" ]; do
    # Message
    
    echo "^ib(2)^fg($BLUE)"Screenshot saved as "$FILENAME"!"^pa(2)"

    done | dzen2 -p -bg $BG -fg $YELLOW -y $NOTIFPOSY -x $NOTIFPOSX -fn $FONT -w $THUMBWIDTH -ta l -e 'onstart=uncollapse;button3=exit' -p 7 &

# Kill
if [[ "$DZEN2" -gt 0 ]];
then
    sleep $KILLDELAY && rm -rf /tmp/ScrotU* && exit
else
    sleep $KILLDELAY && killall dzen2 & exit
fi
