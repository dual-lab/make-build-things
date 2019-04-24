#!/usr/bin/env bash

set -x -u -e -o pipefail

source "tools/circleci/decrypt_token.sh"
source "tools/version.sh"
##
# name   : release.sh
# author : dmike
# scope  : release a new version of the lib
#        creating a new rel on github and uploading the artifact
##
function main() {
    local current_branch=$(git rev-parse --abbrev-ref  HEAD)

    printf "##\n"
    printf "#  Released script \n"
    printf "#  Version: ${MAJOR}.${MINOR}.${PATCH}\n"
    printf "#  Branch: ${current_branch}\n"
    printf "#  Creating shar archive.....\n"

    if [ "$current_branch" != "master" ]; then
        printf 'Error: relese only from master branch\n'
        exit 1;
    fi

    local artifactid = "${bundle_name}-${MAJOR}.${MINOR}.${PATCH}" 
    generate_bundle ${artifactid}

    printf "##\n"
}

function generate_bundle(){
    shar \
    --input-file-list=tools/released_files.txt \
    --archive-name=$1 \
    --submitter=dmike16@somewhere \
    --net-headers \
    -o $1
    return $?
}

main