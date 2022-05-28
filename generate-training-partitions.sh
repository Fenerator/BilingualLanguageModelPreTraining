#!/bin/zsh
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./generate-training-partitions.sh <dataset>
#

set -e

ds=$2 # dataset folder name

TXT_PATH=/srv/scratch4/tinner/$ds/txt

TRAIN_LEN_FR=$(wc -l $TXT_PATH/fr.train | awk -F " " '{print $1}')
TRAIN_LEN_TR=$(wc -l $TXT_PATH/tr.train | awk -F " " '{print $1}')
TRAIN_LEN_EN=$(wc -l $TXT_PATH/en.train | awk -F " " '{print $1}')

echo "n_STRAIN_LEN_FR: $TRAIN_LEN_FR"
echo "n_STRAIN_LEN_TR: $TRAIN_LEN_TR"
echo "n_STRAIN_LEN_EN: $TRAIN_LEN_EN"

#create subsets of the training set:
get_seeded_random() {
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
}

# get English partitions equal to the French and Turkish training sets such that we have equal amounts of data for the languages EN-TR and EN-FR
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/en.train | head -$TRAIN_LEN_FR >$TXT_PATH/en.train_small_n_fr
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/en.train | head -$TRAIN_LEN_TR >$TXT_PATH/en.train_small_n_tr

# get size of small partition (same for FR and TR) 0.53% of EN training set
n_SMALL=$(python -c 'from sys import argv; res=float(argv[1])*float(0.0053); print(round(res))' "$TRAIN_LEN_EN")

echo "n_SMALL: $n_SMALL"

shuf --random-source=<(get_seeded_random 42) $TXT_PATH/fr.train | head -$n_SMALL >$TXT_PATH/fr.train_small
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/tr.train | head -$n_SMALL >$TXT_PATH/tr.train_small
