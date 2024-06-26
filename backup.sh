#!/bin/bash
post_file () {
	curl -s -o /dev/null \
		-H "Content-Type: multipart/form-data" \
		-F "payload_json={\"username\":\"Diskord\"}" \
		-F "files[]=@$1" \
		$DISKORD_WEBHOOK
}

if ! type 7z > /dev/null 2>&1; then echo "7z not found, install 'p7zip-full'"; exit 1; fi
if [ -z $DISKORD_WEBHOOK ]; then echo "No webhook url has been set, run 'export DISKORD_WEBHOOK=<webhook url>'"; exit 1; fi
if [ -z "$1" ]; then echo "Target file is not specified"; exit 1; fi
file=`realpath -m "$1"`
if [ ! -e "$file" ]; then echo "File '$file' was not found"; exit 1; fi

cd "`dirname "$file"`"
archive="`basename "$file"` `date +"%Y-%m-%d_%H-%M-%S"`"
if [ -z "$2" ]; then
	7z -v8191k -bso0 -bsp0 a "$archive" "`basename "$file"`"
else
	7z -mhe=on -p"$2" -v8191k -bso0 -bsp0 a "$archive" "`basename "$file"`"
fi

find * -type f -name "$archive.*" -print0 | while IFS= read -r -d '' part; do
	post_file "$part"
	rm "$part"
done