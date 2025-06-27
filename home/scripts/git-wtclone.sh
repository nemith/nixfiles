#!/bin/bash
# git-wtclone.sh - Clone a git repository with bare repo and worktree setup

set -e

# Check if URL is provided
if [ $# -eq 0 ]; then
    echo >&2 "Usage: git-wtclone <url> [<dir>]"
    exit 1
fi

URL="$1"
DIR="$2"

# Check if URL is in org/repo format and expand to GitHub SSH URL
if [[ "$URL" =~ ^[a-zA-Z0-9_.-]+/[a-zA-Z0-9_.-]+$ ]]; then
    URL="git@github.com:${URL}.git"
    echo >&2 "Expanded to: $URL"
fi

if [ -z "$DIR" ]; then
    DIR=$(basename "$URL" .git)
    if [ -z "$DIR" ] || [ "$DIR" = "/" ]; then
        echo >&2 "Error: Could not determine directory name from URL"
        exit 1
    fi
fi

# Check if directory already exists
if [ -d "$DIR" ]; then
    echo >&2 "Error: Directory '$DIR' already exists"
    exit 1
fi

echo >&2 "Cloning $URL into $DIR..."

# Create the directory
mkdir -p "$DIR"
cd "$DIR"

git clone --bare "$URL" .bare
echo "gitdir: .bare" > .git
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch

# Determine the default branch
DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')

if [ -z "$DEFAULT_BRANCH" ]; then
  echo >&2 "Error: Could not determine the default branch"
  exit 1
fi

git worktree add "$DEFAULT_BRANCH" "$DEFAULT_BRANCH"

echo >&2 "Done! Repository cloned with worktree setup."
echo >&2 "Main worktree is in: $DIR/$DEFAULT_BRANCH"
echo >&2 "To add more worktrees: git worktree add <branch-name> <branch-name>" >&2
