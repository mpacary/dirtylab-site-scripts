#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc push changes made by 1_process.sh to 'dirtylab.github.io' repo

TMP_DIR="tmp_site"

DEST_REPO="https://github.com/dirtylab/dirtylab.github.io"
DEST_DIR="dirtylab.github.io"

if [ ! -d "$DEST_DIR" ]; then
  echo "*** Create $DEST_DIR directory"
  git clone $DEST_REPO
fi

cd $DEST_DIR

git pull

cp -rf ../$TMP_DIR/* .

# may be genarated by a local Jekyll
rm -rf _site

git add .

# you may need to do
# git config --global --edit
# before running this:
git commit -m "commit depuis script"

git push -u origin master