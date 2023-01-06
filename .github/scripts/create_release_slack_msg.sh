#!/usr/bin/env sh

# Set file where slack message contents will be pasted into
SLACK_MSG_CONTENTS=slack_msg.txt
# File that contains message text to append at end of slack message
APPEND_MSG_FILE=.github/release_msg_note.txt

# Paste Title & Release URL into $SLACK_MSG_CONTENTS file
echo "*New ${PACKAGE_NAME} package v${VERSION} released!*" > $SLACK_MSG_CONTENTS
echo "=======================================" > $SLACK_MSG_CONTENTS
echo "${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/releases/tag/${VERSION}" > $SLACK_MSG_CONTENTS

# Grab Release Notes from latest release
RELEASE_API_URL="${GITHUB_API_URL}/repos/${GITHUB_REPOSITORY}/releases/tags/${VERSION}"
NOTES=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" "${RELEASE_API_URL}" | jq '.body')

# Remove everything besides list of changes 
NOTES=$(echo "$NOTES" | sed '/^[*] /!d' | sed 's/* //g')
# Replace PR URLs with PR #
NOTES=$(echo "$NOTES" | sed "s+${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/+#+g")

# Append $NOTES & .github/release_msg_note.txt into $SLACK_MSG_CONTENTS file
echo "$NOTES"  >> $SLACK_MSG_CONTENTS
cat $APPEND_MSG_FILE >> $SLACK_MSG_CONTENTS

# Set multi-line SLACK_MESSAGE enviroment = text in $SLACK_MSG_CONTENTS file
echo 'SLACK_MESSAGE<<EOF' >> $GITHUB_ENV
echo "$(cat $SLACK_MSG_CONTENTS)" >> $GITHUB_ENV
echo 'EOF' >> $GITHUB_ENV
