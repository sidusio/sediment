#!/usr/bin/env bash
#
# Adapted/stolen from:
# https://github.com/blue-build/modules/blob/main/modules/fonts
#

set -euo pipefail

FONTS=($@)
DEST="/usr/share/fonts/google-fonts"

echo "Installation of google-fonts started"
rm -rf "${DEST}"

for FONT in "${FONTS[@]}"; do
    if [ -n "$FONT" ]; then
        mkdir -p "${DEST}/${FONT}"

        readarray -t "FILE_REFS" < <(
            if JSON=$(
                curl -s "https://fonts.google.com/download/list?family=${FONT// /%20}" | # spaces are replaced with %20 for the URL
                tail -n +2 # remove first line, which as of March 2024 contains ")]}'" and breaks JSON parsing
            ); then
                if FILE_REFS=$(echo "$JSON" | jq -c '.manifest.fileRefs[]' 2>/dev/null); then
                    echo "$FILE_REFS"
                fi
            fi
        )

        if [ ${#FILE_REFS[@]} -eq 0 ]; then
            echo "Could not find download information for ${FONT}"
        else
            for FILE_REF in "${FILE_REFS[@]}"; do
                if FILENAME=$(echo "${FILE_REF}" | jq -er '.filename' 2>/dev/null); then
                    if URL=$(echo "${FILE_REF}" | jq -er '.url' 2>/dev/null); then
                        echo "Downloading ${FILENAME} from ${URL}"
                        curl "${URL}" -o "${DEST}/${FONT}/${FILENAME##*/}" # everything before the last / is removed to get the filename
                    else
                        echo "Failed to extract URLs for: ${FONT}" >&2
                    fi
                else
                    echo "Failed to extract filenames for: ${FONT}" >&2
                fi
            done
        fi
    fi
done

fc-cache -f "${DEST}"
