#!/bin/bash
WALLPAPER=${1?Error: no wallpaper given}

echo "#!/bin/bash" >> fehbg
echo "feh --bg-scale $WALLPAPER" >> fehbg
chmod +x fehbg
mv fehbg /usr/bin/

