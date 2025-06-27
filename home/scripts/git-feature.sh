#!/bin/bash
# git-feature.sh - Git worktree feature branch creator


# Find the directory containing .bare (the worktree root)
WORKTREE_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
while [ "$WORKTREE_ROOT" != "/" ] && [ ! -d "$WORKTREE_ROOT/.bare" ]; do
    WORKTREE_ROOT=$(dirname "$WORKTREE_ROOT")
done

# Check if we found .bare directory
if [ ! -d "$WORKTREE_ROOT/.bare" ]; then
    echo "Error: Could not find .bare directory. Are you in a worktree-based checkout?"
    exit 1
fi

# Check if branch name was provided
if [ -z "$1" ]; then
    echo "Usage: git feature <branch-name>"
    echo "Creates: feature/<branch-name> worktree in directory <branch-name>"
    exit 1
fi

# Change to the worktree root directory
cd "$WORKTREE_ROOT"

# Create the feature worktree
echo "Creating feature worktree: ${GIT_FEATURE_BRANCH_PREFIX}$1 in directory $1"
git worktree add -b "${GIT_FEATURE_BRANCH_PREFIX}$1" "$1" && cd "$1"
