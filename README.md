**DESCRIPTION**

MagickShot is an ImageMagick wrapper that takes a screenshot, saves it to a specified folder, shows a thumbnail, uploads it to a range of optional uploaders, and finally, copies the link to your clipboard. I have it bound to the printscr button on my machine, it makes sharing desktops very snappy!

**FEATURES**
- Auto upload to imgur!
- Imgur link listing action!
- Dzen2 tooltips!
- Thumbnail popup!
- Open source!

**DEPENDENCIES**
- xclip
- curl
- imagemagick
- xdpyinfo
- dzen (xpm support needed for thumbnail popup)
- xdotool (For window capturing)

**INSTALLATION**

Simply clone the repo, make a config file, and run the script! The config file location is '~/.MagickShot/config', and it should run out-of-box with default settings with the example config!

**SCREENSHOT**

http://i.imgur.com/bxqgngS.png
There! In the top right, you see the generated thumbnail, the list of imgur generated links, and the name of the file that scrot took!
