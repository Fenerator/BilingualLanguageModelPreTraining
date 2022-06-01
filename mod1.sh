#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

# EN FR LM
# Usage: ./mod1.sh <experiment name> <experiment data>
#
set -e
#ds=$1       # dataset folder name e.g. wiki
#lgs=$2      # input languages
#mlm=$3      # mlm steps
exp_name=$1 # e.g. ex1_wiki

INPATH=$2
#INPATH=/srv/scratch4/tinner/test/ex1_wiki

OUTPATH=$INPATH/xlm_out

mkdir -p $OUTPATH

export CUDA_VISIBLE_DEVICES=4,5,6

python train.py \
    --amp 1 \
    --exp_name $exp_name \
    --dump_path $OUTPATH \
    --data_path $INPATH/ \
    --lgs 'en-fr' \
    --clm_steps '' \
    --mlm_steps 'en,fr' \
    --emb_dim 2048 \
    --n_layers 12 \
    --n_heads 16 \
    --dropout 0.1 \
    --attention_dropout 0.1 \
    --gelu_activation true \
    --batch_size 8 \
    --bptt 256 \
    --optimizer adam,lr=0.0001 \
    --epoch_size 100000 \
    --max_epoch 100000 \
    --validation_metrics _valid_mlm_ppl \
    --stopping_criterion _valid_mlm_ppl,25 \
    --fp16 true
