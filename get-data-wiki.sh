#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./get-data-wiki.sh $lg
#

set -e

lg=$1 # input language

# data path
MAIN_PATH=$PWD
#WIKI_PATH=/srv/scratch4/tinner/wiki
WIKI_PATH=/srv/scratch4/tinner/test/wiki
# tools paths
TOOLS_PATH=$PWD/tools
TOKENIZE=$TOOLS_PATH/tokenize.sh
LOWER_REMOVE_ACCENT=$TOOLS_PATH/lowercase_and_remove_accent.py

# Wiki data
WIKI_DUMP_NAME=${lg}wiki-latest-pages-articles.xml.bz2
WIKI_DUMP_LINK=https://dumps.wikimedia.org/${lg}wiki/latest/$WIKI_DUMP_NAME

# install tools
./install-tools.sh

# create Wiki paths
mkdir -p $WIKI_PATH/bz2

TXT_PATH=$WIKI_PATH/txt
mkdir -p $TXT_PATH

# download Wikipedia dump
echo "Downloading $lg Wikipedia dump from $WIKI_DUMP_LINK ..."
#####wget -c $WIKI_DUMP_LINK -P $WIKI_PATH/bz2/
echo "Downloaded $WIKI_DUMP_NAME in $WIKI_PATH/bz2/$WIKI_DUMP_NAME"

# extract and tokenize Wiki data
cd $MAIN_PATH

if [ ! -f $TXT_PATH/$lg.all ]; then
  echo "*** Cleaning and tokenizing $lg Wikipedia dump ... ***"
  python -m wikiextractor.WikiExtractor $WIKI_PATH/bz2/$WIKI_DUMP_NAME --processes 8 -q -o - |
    sed "/^\s*\$/d" |
    grep -v "^<doc id=" |
    grep -v "</doc>\$" |
    $TOKENIZE $lg |
    python $LOWER_REMOVE_ACCENT \
      >$TXT_PATH/$lg.all
  echo "*** Tokenized (+ lowercase + accent-removal) $lg Wikipedia dump to $TXT_PATH/$lg.all ***"
fi

# split into train / valid / test
echo "*** Splitting $lg into $TXT_PATH/$lg.train,valid,test ***"

split_data() {
  get_seeded_random() {
    seed="$1"
    openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
  }
  NLINES=$(wc -l $1 | awk -F " " '{print $1}')
  echo NLINES: $NLINES
  #####NTRAIN=$((NLINES - 10000))
  NTRAIN=$((NLINES - 10))
  NVAL=$((NTRAIN + 5))
  shuf --random-source=<(get_seeded_random 42) $1 | head -$NTRAIN >$2
  shuf --random-source=<(get_seeded_random 42) $1 | head -$NVAL | tail -5 >$3
  shuf --random-source=<(get_seeded_random 42) $1 | tail -5 >$4
}
split_data $TXT_PATH/$lg.all $TXT_PATH/$lg.train $TXT_PATH/$lg.valid $TXT_PATH/$lg.test
