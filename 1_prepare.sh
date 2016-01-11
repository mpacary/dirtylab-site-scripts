#!/bin/bash

# @author Frosty-Z
# @date 2015-12-22
# @desc Processes .MD files from https://github.com/sveinburne/lets-play-science
#       to get .html files then upload them to https://github.com/dirtylab/dirtylab.github.io

# requires PHP 5+ to be installed on the system

ORIG_REPO_URL="https://github.com/sveinburne/lets-play-science"
ORIG_DIR="lets-play-science"
TMP_DIR="tmp_site"
TEMPLATES_DIR="jekyll-stuff"
JEKYLL_INCLUDES_DIR="_includes"
JEKYLL_BUILD_DIR="_site"


echo "*** Clean/refresh directories"

if [ ! -d "$ORIG_DIR" ]; then
  echo "*** Create $DEST_DIR directory from $ORIG_REPO_URL"
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


echo '*** Remove <a name="hi"></a> anchor at top of README.MD to avoid a CSS issue'

sed -i.bak -e 's/<a name="hi"><\/a>//g' README.MD


echo "*** Copy .MD files to $JEKYLL_INCLUDES_DIR recursively + fix links and emoji"

mkdir $JEKYLL_INCLUDES_DIR

# required to handle spaces in filenames
OLDIFS=$IFS
IFS=$'\n'

for f in `find . -type f -regextype sed -regex ".*/.*\.\(MD\|md\)"`
do
  # Links fixing
  sed -i.bak -e 's/\([A-Za-z0-9.\-_]\{1,\}\)\.MD/\1.html/g' $f

  # Emoji conversion
  php ../php_emojize/emojize.php $f

  # copy with directory structure preservation
  mkdir -p `dirname "$JEKYLL_INCLUDES_DIR/$f"`
  cp "$f" "$JEKYLL_INCLUDES_DIR/$f"
done

# clean .bak files created by sed.
# note that rm -rf *.bak only remove files from current directory, not subdirs
# see http://unix.stackexchange.com/questions/116389
find . -type f -name '*.bak' -delete

echo "*** Create one .html file per .MD file, with appropriate 'Front Matter' content"

STR_NAV=$'\n\nfiles:\n'

for f in `find . -type f -regextype sed -regex ".*/.*\.\(MD\|md\)" -not -path "./$JEKYLL_INCLUDES_DIR/*" -not -path "./$JEKYLL_BUILD_DIR/*"`
do
  if [[ "$f" == *MD ]]; then
    NEW_FILENAME="${f%.MD}.html"
  else
    NEW_FILENAME="${f%.md}.html"
  fi
  
  mv "$f" "$NEW_FILENAME"

  CONTENT=$'---\n'
  CONTENT+=$'layout: convert_md_to_html\n'
  CONTENT+="markdown_file: ${f:2}" # strip './' at the beginning of the filename, otherwise Jekyll crashes !
  CONTENT+=$'\n---\n'
  echo "$CONTENT" > "$NEW_FILENAME"

  STR_NAV+="- ${NEW_FILENAME:2:-5}" # remove './'' at the beginning + .html extension
  STR_NAV+=$'\n'
done

IFS=$OLDIFS



echo "*** Retrieve templates"

cp -r ../$TEMPLATES_DIR/* .

if [ "$1" = "--prod" ]; then
  mv _config.yml.prod _config.yml
else
  mv _config.yml.local _config.yml
fi

echo "*** Add navigation array to _config.yml"

echo "$STR_NAV" >> _config.yml


cd ..
