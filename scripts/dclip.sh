#! /bin/bash

# dclip-1.4 || Delta & Nibble 20/12/09

file=$HOME/.dclip_cache
size=10

if [ "$1" == "copy" ]; then
    sel_clip=$(xclip -o)
    sel_file=$(echo -n "$sel_clip"|tr '\n' '\034')
fi
touch $file 
if [ "$1" == "paste" ]; then 
    shift 
    sel_file=$(cat $file | dmenu ${1+"$@"}) 
    sel_clip=$(echo -n "$sel_file"|tr '\034' '\n')
fi
[ -z "$sel_clip" ] && exit 1

cut=$(cat $file | grep -vFxe "$sel_file" | head -n $(($size-1)))
echo "$sel_file" > $file
[ ! -z "$cut" ] && echo -n "$cut" >> $file

echo -n "$sel_clip" | xclip -selection primary -i
echo -n "$sel_clip" | xclip -selection clipboard -i
 
exit 0