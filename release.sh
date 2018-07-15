#!/bin/sh
# ==================================================
#    Author: dmike
#    Date         : 7 July 2018
#    Description:
#              Release script for this project. Pack all the source in a schell archive
#              using the utility 'shar;' And create a rel git tag
# ===================================================
. tools/released_version.txt
current_branch=$(git rev-parse --abbrev-ref  HEAD)
main(){
    printf "===============================================\n"
    printf "  Released script \n"
    printf "  Version: ${MAJOR}.${MINOR}.${PATCH}\n"
    printf "  Branch: ${current_branch}\n"
    printf "  Creating shar archive.....\n"
    if [ "$current_branch" != "master" ]; then
        printf 'Error: relese only from master branch\n'
        exit 1;
    fi
    shar \
    --input-file-list=tools/released_files.txt \
    --archive-name="mbts-${MAJOR}.${MINOR}.${PATCH}" \
    --submitter=dmike16@somewhere \
    --net-headers \
    -o "mbts-${MAJOR}.${MINOR}.${PATCH}" || exit $?
    git tag -a v${MAJOR}.${MINOR}.${PATCH}  -m "Release version ${MAJOR}.${MINOR}.${PATCH} " || exit $?
    git push origin v${MAJOR}.${MINOR}.${PATCH} || exit $?
    printf "===============================================\n"
}

main "$@"