#!/usr/bin/env bash

## 参考
getArchiveFilename() {
    REF_DIR='/usr/local'
    printf '%s' "${REF_DIR}/${1}.jpi"
}

getArchiveFilename $1



for i in `ls /`;do
    echo ${i}_$(date +%F)
done
