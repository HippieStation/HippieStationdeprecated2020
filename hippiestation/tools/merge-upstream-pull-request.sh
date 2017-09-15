#!/usr/bin/env bash
source ~/.discordauth

# ~/.discordauth contains:
# CHANNELID=x
# TOKEN=x
# CHANNELID being the Discord Channel ID
# TOKEN being the bot token

set -u # don't expand unbound variable
set -f # disable pathname expansion
set -C # noclobber

readonly BASE_BRANCH_NAME="upstream-merge-"
readonly BASE_PULL_URL="https://api.github.com/repos/tgstation/tgstation/pulls"

# Ensure the current directory is a git directory
if [ ! -d .git ]; then
    echo "Error: must run this script from the root of a git repository"
    exit 1
fi

# Ensure all given parameters exist
if [ $# -eq 0 ]; then
    echo "Error: No arguments have been given, the first argument needs to be a pull ID, the second argument needs to be the commit message"
    exit 1
fi

# Ensure curl exists and is available in the current context
type curl >/dev/null 2>&1 || { echo >&2 "Error: This script requires curl, please ensure curl is installed and exists in the current PATH"; exit 1; }

# Ensure jq exists and is available in the current context
type jq >/dev/null 2>&1 || { echo >&2 "Error: This script requires jq, please ensure jq is installed and exists in the current PATH"; exit 1; }

containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Make sure we have our upstream remote
if ! git remote | grep tgstation > /dev/null; then
   git remote add tgstation https://github.com/tgstation/tgstation.git
fi

curl -v \
-H "Authorization: Bot $TOKEN" \
-H "User-Agent: myBotThing (http://some.url, v0.1)" \
-H "Content-Type: application/json" \
-X POST \
-d "{\"content\":\"Mirroring [$1] from /tg/ to Hippie\"}" \
https://discordapp.com/api/channels/$CHANNELID/messages

# We need to make sure we are always on a clean master when creating the new branch.
# So we forcefully reset, clean and then checkout the master branch
git fetch --all
git checkout master
git reset --hard origin/master
git clean -f

git fetch upstream pull/$1/head:$BASE_BRANCH_NAME-$1

git checkout $BASE_BRANCH_NAME-$1

echo "Adding files to branch:"
git add -A .

echo "Commiting changes"
git commit --allow-empty -m "$2"

# Push them onto the branch
echo "Pushing changes"
git push -u origin "$BASE_BRANCH_NAME$1"
