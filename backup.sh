#!/bin/bash
post_file () {
	curl -s -o /dev/null \
		-H "Content-Type: multipart/form-data" \
		-F 'payload_json={"username": "Diskord"}' \
		-F "files[]=@$1" \
		$DISKORD_WEBHOOK
}

if ! type 7zr > /dev/null 2>&1; then echo "7zr not found, install 'p7zip'"; exit 1; fi
if [ -z $DISKORD_WEBHOOK ]; then echo "No webhook url has been set, run 'export DISKORD_WEBHOOK=<webhook url>'"; exit 1; fi
if [ -z $1 ]; then echo "Source file is not specified"; exit 1; fi
if [ ! -e $1 ]; then echo "file not found"; exit 1; fi

archive="`basename ${1%.*}` `date +"%Y-%m-%d_%H-%M-%S"`.7z"
7zr -v8191k -bso0 -bsp0 a "$archive" "$1"

find * -type f -name "$archive.*" -print0 | while IFS= read -r -d '' file; do
	post_file "$file"
	rm "$file"
done