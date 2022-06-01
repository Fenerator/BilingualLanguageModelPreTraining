#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./pretraining_pipeline.sh
#
set -e

DATA_PATH=/srv/scratch4/tinner/test
BPE_VOCAB_SIZE=30000

# Download wiki and cc data in en, fr, tr
./get-data-wiki.sh en $DATA_PATH/wiki
./get-data-wiki.sh fr $DATA_PATH/wiki
./get-data-wiki.sh tr $DATA_PATH/wiki

./get-data-cc-100.sh en $DATA_PATH/cc
./get-data-cc-100.sh fr $DATA_PATH/cc
./get-data-cc-100.sh tr $DATA_PATH/cc

# generate bilingual datasets
./generate-training-partitions.sh wiki en_fr $DATA_PATH
./generate-training-partitions.sh wiki en_tr $DATA_PATH
./generate-training-partitions.sh cc en_fr $DATA_PATH
./generate-training-partitions.sh cc en_tr $DATA_PATH

# BPE
./generate_bpe.sh cc en_fr $BPE_VOCAB_SIZE $DATA_PATH
./generate_bpe.sh cc en_tr $BPE_VOCAB_SIZE $DATA_PATH
./generate_bpe.sh wiki en_fr $BPE_VOCAB_SIZE $DATA_PATH
./generate_bpe.sh wiki en_tr $BPE_VOCAB_SIZE $DATA_PATH

# organize data
./create_XLM_training_data.sh wiki en_fr $DATA_PATH
./create_XLM_training_data.sh wiki en_tr $DATA_PATH
./create_XLM_training_data.sh cc en_fr $DATA_PATH
./create_XLM_training_data.sh cc en_tr $DATA_PATH

# run one experiment:
./mod1.sh ex1_wiki $DATA_PATH/ex1_wiki
