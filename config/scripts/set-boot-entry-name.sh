#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

base_name="Sediment $OS_VERSION"

# Generate a name for the image to be used when selecting
# boot entry.
#
# Examples:
#  Where: OS_VERSION=39
#
#  For a PR:
#    Includes a reference to the PR number and which commit.
#
#    Output: "Sediment 39 - (pr-46) [e6f4944]"
#
#    Where:
#      # In this case this will be the merge commit against
#      # the PR target branch, in our case live.
#      GITHUB_SHA=e32bb949343e049002afbd2652ee77a76e6620d5
#
#      # The commit sha of the HEAD of the PR branch.
#      GITHUB_PR_HEAD_SHA=e6f494493eae351edb56b0c0aeb539cc063acbb6
#
#      # The merge branch name.
#      GITHUB_REF_NAME=46/merge
#
#  For a branch:
#    Includes a reference to the branch, the date it was built
#    and the commit that was built. The date is interesting here
#    since we have a cron job that builds the live branch every
#    day, and the commit would in that case be the same.
#
#    Output: "Sediment 39 - (live-20240101) [e32bb94]"
#
#    Where:
#      # In this case this will be the commit that triggered
#      # the build; i.e. the HEAD on the branch.
#      GITHUB_SHA=e32bb949343e049002afbd2652ee77a76e6620d5
#
#      # This will be empty
#      GITHUB_PR_HEAD_SHA=
#
#      # The name of the branch.
#      GITHUB_REF_NAME=live
#
#
pretty_name () {
    local ref
    local sha

    # If the variable is not empty, i.e. a PR triggered the
    # build.
    if [[ -n "$GITHUB_PR_HEAD_SHA" ]]; then
        # Take everything before the first '/' character
        ref="pr-${GITHUB_REF_NAME%/*}"
        # Take the first 7 characters
        sha="${GITHUB_PR_HEAD_SHA:0:7}"
    else
        # Generate a date with format YYYYMMDD
        ref="$GITHUB_REF_NAME-$(date +%Y%m%d)"
        # Take the first 7 characters
        sha="${GITHUB_SHA:0:7}"
    fi

    echo "$base_name - ($ref) [$sha]"
}

# Change the PRETTY_NAME value in '/usr/lib/os-release' to the generated
# name. This will be used as the boot entry name.
change_name () {
    sed -i "s/^PRETTY_NAME=.*$/PRETTY_NAME=\"$(pretty_name)\"/" /usr/lib/os-release
}

change_name