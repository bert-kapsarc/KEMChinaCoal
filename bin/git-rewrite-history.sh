#!/bin/bash

### Rewrite history (all commits in all branches) without the files that match the pattern
DELETE_PAT="$1"
git filter-branch --tree-filter "rm -rf $1" --prune-empty --tag-name-filter cat -- --all

### filter-branch saves the original history to refs/original
### because we aim to reclaim space, we need to remove it and then gc the refs
git for-each-ref --format="%(refname)" refs/original/| xargs -n 1 git update-ref -d
git reflog expire --expire=now --all
git gc --prune=now

### before removing any old remotes, you'll want to check out the branches
for b in $(git branch -r | grep -v -e '->'); do
  git checkout $(cut -d/ -f2)
done
### remove whatever old remotes are scary
git remote rm origin

### finally, you'll want to push this repo with modified history someplace new
git remote add origin NEW_REMOTE
git push origin --all
