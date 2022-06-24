#!/bin/bash

if ! type rclone > /dev/null 2>&1; then echo "rclone not found, see https://rclone.org/install/"; exit 1; fi
if [ $# != 3 ]; then echo "Usage: $0 <Source> <Destination> <Password>"; exit 1; fi
source=`realpath -m "$1"`
if [ ! -e "$source" ]; then echo "File '$source' was not found"; exit 1; fi

cd "`dirname "$source"`"
archive="`basename "$source"` `date +"%Y-%m-%d_%H-%M-%S"`.7z"
7z -mhe=on -p"$3" -bso0 -bsp0 a "$archive" "`basename "$source"`"
rclone copy "$archive" "$2"
rm "$archive"