#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./mod1.sh tr wiki tr_test1
#
set -e

ds=$1  # dataset folder name e.g. wiki
lgs=$2 # input languages
mlm=$3 # mlm steps

# Download wiki and cc data in en, fr, tr
./get-data-wiki.sh en /srv/scratch4/tinner/test/wiki
./get-data-wiki.sh fr /srv/scratch4/tinner/test/wiki
./get-data-wiki.sh tr /srv/scratch4/tinner/test/wiki

./get-data-cc-100.sh en /srv/scratch4/tinner/test/cc
./get-data-cc-100.sh fr /srv/scratch4/tinner/test/cc
./get-data-cc-100.sh tr /srv/scratch4/tinner/test/cc

# generate bilingual datasets
./generate-training-partitions.sh wiki en_fr /srv/scratch4/tinner/test
./generate-training-partitions.sh wiki en_tr /srv/scratch4/tinner/test
./generate-training-partitions.sh cc en_fr /srv/scratch4/tinner/test
./generate-training-partitions.sh cc en_tr /srv/scratch4/tinner/test

# BPE
./generate_bpe.sh cc en_fr 30000 /srv/scratch4/tinner/test
./generate_bpe.sh cc en_tr 30000 /srv/scratch4/tinner/test
./generate_bpe.sh wiki en_fr 30000 /srv/scratch4/tinner/test
./generate_bpe.sh wiki en_tr 30000 /srv/scratch4/tinner/test

# organize data
./create_XLM_training_data.sh wiki en_fr /srv/scratch4/tinner/test
./create_XLM_training_data.sh wiki en_tr /srv/scratch4/tinner/test
./create_XLM_training_data.sh cc en_fr /srv/scratch4/tinner/test
./create_XLM_training_data.sh cc en_tr /srv/scratch4/tinner/test

# run one experiment:
./mod1.sh ex1_wiki /srv/scratch4/tinner/test/ex1_wiki
