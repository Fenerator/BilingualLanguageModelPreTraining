#!/bin/bash
#
# Usage: ./get-data-cc-100.sh $lg
#

set -e

lg=$1  # input language

# data path
MAIN_PATH=$PWD
#CC_PATH=$PWD/data/cc-100
CC_PATH=/srv/scratch4/tinner/cc

mkdir -p $CC_PATH

# tools paths
TOOLS_PATH=$PWD/tools
TOKENIZE=$TOOLS_PATH/tokenize.sh
LOWER_REMOVE_ACCENT=$TOOLS_PATH/lowercase_and_remove_accent.py

# Wiki data https://data.statmt.org/cc-100/fr.txt.xz
CC_DUMP_NAME=${lg}.txt.xz
CC_DUMP_LINK=https://data.statmt.org/cc-100/$CC_DUMP_NAME

# install tools
./install-tools.sh

if [[ ! -f $CC_PATH/$lg.txt ]]
then
    # download Wikipedia dump
    echo "Downloading $lg CC-100 dump from $CC_DUMP_LINK ..."
    wget -c $CC_DUMP_LINK -P $CC_PATH
    echo "Downloaded $CC_DUMP_NAME in $CC_PATH/$CC_DUMP_NAME"

    # extract and tokenize CC data
    echo "Extracting $CC_PATH/$CC_DUMP_NAME ..."
    xz -d -v $CC_PATH/$CC_DUMP_NAME
fi


cd $MAIN_PATH
if [ ! -f $CC_PATH/$lg.all ]; then
    echo "*** Cleaning and tokenizing $lg CC-100 dump ... ***"
    sed '1d' $CC_PATH/$lg.txt \
  | sed "/^\s*\$/d" \
  | grep -v "^<doc id=" \
  | grep -v "</doc>\$" \
  | $TOKENIZE $lg \
  | python $LOWER_REMOVE_ACCENT \
  > $CC_PATH/$lg.all
fi
echo "*** Tokenized (+ lowercase + accent-removal) $lg CC-100 dump to $CC_PATH/${lg}.all ***"

# split into train / valid / test
echo "*** Splitting into train / valid / test... ***"
echo $1

split_data() {
    get_seeded_random() {
        seed="$1"; openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
    };
    NLINES=`wc -l $1  | awk -F " " '{print $1}'`;
    NTRAIN=$((NLINES - 10000));
    NVAL=$((NTRAIN + 5000));
    shuf --random-source=<(get_seeded_random 42) $1 | head -$NTRAIN             > $2;
    shuf --random-source=<(get_seeded_random 42) $1 | head -$NVAL | tail -5000  > $3;
    shuf --random-source=<(get_seeded_random 42) $1 | tail -5000                > $4;
}
split_data $CC_PATH/txt/$lg.all $CC_PATH/txt/$lg.train $CC_PATH/txt/$lg.valid $CC_PATH/txt/$lg.test

echo "*** Split into train / valid / test ***"