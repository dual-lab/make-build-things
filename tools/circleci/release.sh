#!/usr/bin/env bash

set -x -u -o pipefail

source "tools/circleci/decrypt_token.sh"
source "tools/version.sh"

readonly REPO_ENDPOINT="https://api.github.com/repos/dual-lab/make-build-thing"
readonly AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
##
# name   : release.sh
# author : dmike
# scope  : release a new version of the lib
#        creating a new rel on github and uploading the artifact
##
function main() {
    
    assert_master_branch
    #exit_on_error $? "Release only from master branch"

    local tag="v${MAJOR}.${MINOR}.${PATCH}"

    assert_no_tag_Version $tag
    exit_on_error $? "Release with tag ${tag}, already exists"

    local bundle_name="mkbts"
    local artifactid="${bundle_name}-${tag}" 
    generate_bundle ${artifactid}
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
        return 1
    fi
}

function assert_no_tag_Version(){
    local v_tag=$1
    local tag_url="${REPO_ENDPOINT}/releases/tags/${v_tag}"
    local status=$(curl --silent -H "${AUTH_HEADER}" --head ${tag_url} | awk '/Status:/ {print $2}')

    ((${status} == 404)) 
    return $?
}

function exit_on_error(){
    if [[ $1 -ne 0 ]]; then
        printf "+ Error: $2\n"
        exit 1
    fi
}

main