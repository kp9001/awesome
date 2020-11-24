# Awesome WM

My personal configuration of the awesome window manager. The original can be found [here](https://github.com/awesomeWM/awesome). Comments added to rc.lua should roughly explain changes to the default configuration. 

## Keybinds

### System

- `alt+s` -- toggle list of keybinds
- `alt+w` -- launch menu
- `alt+space` -- launch run prompt
- `alt+ctrl+space` -- launch application menu
- `alt+b` -- toggle menu bar
- `alt+ctrl+r` -- reload awesome
- `alt+ctrl+delete` -- quit awesome
- `alt+ctrl+shift+delete` -- power off computer

### Launch

Disclaimer: may require changing default terminal in `rc.lua` and most likely will require editing launch commands in `scripts/launcher.sh`.

- `alt+ctrl+enter` -- spawn a terminal
- `alt+ctrl+w` -- launch firefox
- `alt+ctrl+shift+w` -- launch tor
- `alt+ctrl+a` -- launch keepass
- `alt+ctrl+s` -- launch signal
- `alt+ctrl+d` -- launch discord
- `alt+ctrl+e` -- launch element

### Layout

- `alt+ctrl+shift+h/j/k/l/i` -- switch to layout with master on left/bottom/top/right/top-left
- `alt+ctrl+shift+f` -- toggle floating on focused client
- `alt+ctrl+j/k` -- switch focus to next client down/up the stack
- `alt+shift+j/k` -- move clients down/up the stack
- `alt+ctrl+h/l` -- switch focus to screen (monitor) on the left/right
- `alt+shift+h/l` -- move client to screen on the left/right
- `alt+shift+enter` -- move client to master
- `alt+shift+.` -- increase number of masters by 1
- `alt+shift+,` -- decrease number of masters by 1
- `alt+h/l` -- resize clients horizontally
- `alt+f` -- toggle fullscreen on focused client
- `alt+m` -- toggle maximize on focused client 
- `alt+shift+m` -- toggle horizontal maximize on focused client 
- `alt+ctrl+m` -- toggle vertical maximize on focused client 
- `alt+shift+down` -- minimize client
- `alt+shift+up` -- un-minimize client
- `alt+number` -- switch focus to tag (workspace) number
- `alt+shift+number` -- move client to tag number
- `alt+ctrl+number` -- toggle view tag number on current tag

### Volume

Volume up/down keys perform their normal function. This can be changed to any keys in `rc.lua`. Search for "volume controls".

## Installation

Disclaimer: This was set up on Debian 10, so it is conceivable that it will not work on all distros in this exact form. 

Install from repositories: 

```
sudo apt install awesome
```

Clone this repository into your `.config`

```
cd ~/.config
git clone https://github.com/kp9001/awesome.git
cd awesome
```

In order to take full advantage of the custom configuration (for instance, screenshots), you will need to make sure a few dependencies are installed:

```
sudo apt install feh maim xclip xdotool
```

If you wish to set a custom wallpaper, find the path of an image file you wish to use. Enter the scripts directory and run the wallpaper script with the absolute path to the desired image as an argument

```
cd scripts
sudo ./wallpaper.sh /path/to/wallpaper
```

Things you might want to modify before loading: 

- The `xrandr` command in the autorun list at the bottom of `rc.lua` can be completely removed for most people. It was a hacky fix to a display issue. Alternatively, you can modify it to manipulate your displays at will. 
- The keybinds for `move_to_screen` are based on my monitors being numbered opposite of what is reasonable. The default binding is commented out beneath my modified bindings. 

When you are ready to load awesome, log off, switch your desktop environment to awesome, and log back in. If all went well, it should load awesome with this configuration without errors, and with your wallpaper. If you wish to make any changes, open up `rc.lua` in your favorite editor and have fun. Press `alt+ctrl+r` to reload awesome (unless you modified this already). 

If you wish to check out other themes, all the themes which ship with awesome in the debian repository are copied into the themes directory. You may try them out by editing the line just after "variable definitions" in `rc.lua` which currently reads 

```
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "xresources")
```

You want to replace `xresources` with other theme names. 

You may also wish to modify the application launcher. Read the script called `launcher` in the scripts directory. Adding new applications to this require adding cases to the case list (the names are irrelevant) and adding corresponding lines to the bottom with whatever command calls the application. (To that effect, you can run any command this way.) You then must go into the keybinds section of `rc.lua` and assign a keybind to `launcher.sh` with some argument. Use the syntax of the ones currently in the config as a template. 

