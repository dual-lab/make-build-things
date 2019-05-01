#!/usr/bin/env bash

set -e -x -u -o pipefail

source "tools/circleci/decrypt_token.sh"
source "tools/version.sh"

readonly REPO_ENDPOINT="https://api.github.com/repos/dual-lab/make-build-things"
readonly AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
readonly JSON_TYPE="Content-Type:Application/json"
readonly ZIP_TYPE="Content-Type:Application/zip"
##
# name   : release.sh
# author : dmike
# scope  : release a new version of the lib
#        creating a new rel on github and uploading the artifact
##
function main() {
    
    #assert_master_branch

    local version="${MAJOR}.${MINOR}.${PATCH}"
    local tag="v${MAJOR}.${MINOR}.${PATCH}"

    assert_no_tag_version ${tag}

    local bundle_name="mkbts"
    local artifactid="${bundle_name}-${tag}"

    generate_bundle ${artifactid}
    generate_release ${tag} ${version} ${artifactid}
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

function assert_no_tag_version(){
    local v_tag=$1
    local tag_url="${REPO_ENDPOINT}/releases/tags/${v_tag}"
    local status=$(curl --silent -H "${AUTH_HEADER}" --head ${tag_url} | awk '/Status:/ {print $2}')

    if [[ ${status} -eq 404 ]]; then
        return 0
    else
        printf "++ Release with tag ${tag}, already exists\n"
        return 1
    fi 
}

function generate_release(){
    local rel_url="${REPO_ENDPOINT}/releases"
    local awk_extract_field='BEGIN{FS="\":"} /upload_url/ {print substr($NF,1,length($NF)-1)}'
    local bundle="$3.tar.gz"
    local awk_extract_changelog="BEGIN{RS=\"---\n\n\";FS=\"\n\"} {if(index(\$1,\"## [$2]\") > 0){for(i=2; i<=NF; i++){ printf \"%s\\\\n\",\$i }}}"
    local changelog_extract=$(cat CHANGELOG.md | awk "${awk_extract_changelog}")

    local rel_payload="{\"tag_name\":\"$1\", \"name\":\"$3\",\"draft\":false,\"body\": \""${changelog_extract}"\" }"
    local upload_url=$(curl --silent -H "${AUTH_HEADER}" -H "${JSON_TYPE}" -X POST -d "${rel_payload}" ${rel_url} | awk "${awk_extract_field}")
    
    if [[ -z ${upload_url} ]]; then
        printf "Upload url empty. File non upload correctly\n"
        return 1
    else
        upload_url=${upload_url/\{?name,label\}/?name=${bundle}}
        upload_url=${upload_url//\"/}
        
        upload_artifact ${upload_url} ${bundle}
    fi
}

function upload_artifact(){
    local url=$1
    local artifactid=$2

    local upload_status=$(curl -i --silent -H "${AUTH_HEADER}" -H "${ZIP_TYPE}" -X POST --data-binary @${artifactid} ${url} | awk '/201 Created/ {print $2}')

    if [[ ${upload_status} -eq 201 ]]; then
        return 0
    else 
        return 1
    fi
}

main