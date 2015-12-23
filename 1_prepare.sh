#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc Processes .MD files from https://github.com/sveinburne/lets-play-science
#       to get .html files then upload them to https://github.com/dirtylab/dirtylab.github.io

# uses grip utility from https://github.com/joeyespo/grip

ORIG_REPO_URL="https://github.com/sveinburne/lets-play-science"
ORIG_DIR="lets-play-science"
TMP_DIR="tmp_site"
TEMPLATES_DIR="jekyll-stuff"


echo "*** Clean/refresh directories"

if [ ! -d "$ORIG_DIR" ]; then
  echo "*** Create $DEST_DIR directory"
  git clone $ORIG_REPO_URL
else
  cd $ORIG_DIR
  git pull
  cd ..
fi

if [ ! -d "$TMP_DIR" ]; then
  mkdir $TMP_DIR
else
  # clear content but avoid rm -rf /*
  if [ -n "$TMP_DIR" ]; then
    rm -rf $TMP_DIR/*
  fi
fi

cp -r $ORIG_DIR/* $TMP_DIR

cd $TMP_DIR

rm -rf .git


echo "*** Convert .MD files content (GitHub Flavored Markdown) to HTML"

FILES=$(find . -type f -name '*.MD')
for f in $FILES
do
  echo "- Processing file $f"
  echo "Conversion"
  grip $f --export $f

  echo "Links fixing"
  sed -i.bak -e 's/\([A-Za-z0-9\-_]\{1,\}\)\.MD/\1.html/g' -e 's/href="#/href="#user-content-/g' -e 's/\.html#/.html#user-content-/g' $f
done

rm -rf *.bak

echo "*** Rename .MD files to .html"
find . -iname "*.MD" -exec rename .MD .html '{}' \;

cd ..


echo "*** Retrieve templates"

cp -r $TEMPLATES_DIR/* $TMP_DIR

