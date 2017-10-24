#!/bin/sh
# Usage: ziptotar.sh <filename1> <filename2> …
# Based on https://techoverflow.net/2012/11/22/convert-zip-to-tar-using-linux-shell/

set -e
if [ "$#" -lt 1 ]; then
    echo "Need at least one filename."
    exit 1
fi

for file in "$@"; do
    tmpdir=$(mktemp -d)
    #Copy the zip to the temporary directory
    cp "${file}" "${tmpdir}/"
    #Unzip
    (cd "${tmpdir}" && unzip -q "${file}")
    #Remove the original zipfile because we don't want that to be tar'd
    rm "$tmpdir/${file}"
    #Tar the files
    outfilename=$(echo "${file}" | rev | cut -d. -f2- | rev).tar.lz
    (cd "${tmpdir}" && tar --lzip -cvf "$outfilename" ./*)
    mv "${tmpdir}/${outfilename}" .
    #Remove the temporary directory
    rm -rf "${tmpdir}"
    #Print what we did
    echo "Converted ${file} to ${outfilename}"
done
