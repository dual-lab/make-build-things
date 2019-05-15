#!/usr/bin/env bash

set -e -x -u -o pipefail

source "tools/version.sh"

##
# name   : release.sh
# author : dmike
# scope  : release a new version of the lib
#        creating a new rel on github and uploading the artifact
##
function main() {
    
    assert_master_branch

    local version="${MAJOR}.${MINOR}.${PATCH}"
    local tag="v${MAJOR}.${MINOR}.${PATCH}"

    local bundle_name="mkbts"
    local artifactid="${bundle_name}-${tag}"

    generate_bundle ${artifactid}
    python3 ./tools/publish.py ${tag} ${version} ${artifactid}
}

function generate_bundle(){
    tar -zcvf "$1.tar.gz" \
    KBUILD Makefile LICENSE CHANGELOG.md README.md \
    scripts/

    return $?
}

function assert_master_branch(){
    local current_branch="$(git rev-parse --abbrev-ref  HEAD)"
    local expected_branch="master"
    
    if [[ "$current_branch" == "$expected_branch" ]]; then
        return 0
    else
        printf "++ Release only on branch master\n"
        return 1
    fi
}

main