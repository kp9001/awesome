# Awesome WM

My personal configuration of the awesome window manager. Comments added to rc.lua should roughly explain changes to the default configuration. 

## Basic installation

Disclaimer: This was set up on Debian 10, so it is conceivable that it will not work on all distros in this exact form. 

Install from repositories: `sudo apt install awesome`

Clone this repository into `~/.config`

```
cd ~/.config
git clone https://github.com/kp9001/awesome.git
```

Look at the contents of the requirements script. These are all packages which must be installed to take full advantage of the custom configuration (such as screenshots, for example).

If you wish to set a custom wallpaper, find the path of an image file you wish to use. Enter the scripts directory and run the wallpaper script with the absolute path to the desired image as an argument

```
cd ~/.config/awesome/scripts
sudo ./wallpaper.sh /path/to/wallpaper
```

Before you load it, you might want to modify or completely remove the `xrandr` command in the autorun list. This was a hacky fix for a weird display situation. 

Log off, switch your desktop environment to awesome, and log back in. If all went well, it should load awesome with this configuration without errors, and with your wallpaper. If you wish to make any changes, open up `rc.lua` in your favorite editor and have fun. Press `alt+ctrl+r` to reload awesome (unless you modified this already). 

If you wish to check out other themes, all the themes which ship with awesome in the debian repository are copied into the themes directory. You may try them out by editing the line just after "variable definitions" in `rc.lua` which currently reads 

```
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "xresources")
```

You want to replace `xresources` with other theme names. 

You may also wish to modify the application launcher. Read the script called `launcher` in the scripts directory. Adding new applications to this require adding cases to the case list (the names are irrelevant) and adding corresponding lines to the bottom with whatever command calls the application. (To that effect, you can run any command this way.) You then must go into the keybinds section of `rc.lua` and assign a keybind to `launcher.sh` with some argument. Use the syntax of the ones currently in the config as a template. 

