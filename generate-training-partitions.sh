#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./generate-training-partitions.sh lang dataset
#

set -e

lg=$1 # input language
ds=$2 # dataset folder name

#PATH=/srv/scratch4/tinner/$ds/txt
TXT_PATH=/mnt/BLLMPT_XLM/BPE/cc_txt/XLM/dummytest #TEST

TRAIN_LEN_FR=$(wc -l $TXT_PATH/train.fr | awk -F " " '{print $TXT_PATH/train.fr}')
TRAIN_LEN_TR=$(wc -l $TXT_PATH/train.tr | awk -F " " '{print $TXT_PATH/train.tr}')
TRAIN_LEN_EN=$(wc -l $TXT_PATH/train.en | awk -F " " '{print $TXT_PATH/train.en}')

echo "n_STRAIN_LEN_FR: $TRAIN_LEN_FR"
echo "n_STRAIN_LEN_TR: $TRAIN_LEN_TR"
echo "n_STRAIN_LEN_EN: $TRAIN_LEN_EN"

#create subsets of the training set:
get_seeded_random() {
  seed="$1"
  openssl enc -aes-256-ctr -pass pass:"$seed" -nosalt </dev/zero 2>/dev/null
}

# get English partitions equal to the French and Turkish training sets such that we have equal amounts of data for the languages EN-TR and EN-FR
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/en.train | head -$TRAIN_LEN_FR >$TXT_PATH/en.train_n_fr
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/en.train | head -$TRAIN_LEN_TR >$TXT_PATH/en.train_n_tr

# get size of small partition (same for FR and TR)
n_SMALL= $(($TRAIN_LEN_EN * 0.0053))
echo "n_SMALL: $n_SMALL"

shuf --random-source=<(get_seeded_random 42) $TXT_PATH/fr.train | head -$n_SMALL >$TXT_PATH/fr.train_small
shuf --random-source=<(get_seeded_random 42) $TXT_PATH/tr.train | head -$n_SMALL >$TXT_PATH/tr.train_small
