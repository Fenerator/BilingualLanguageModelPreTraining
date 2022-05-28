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

lg=$1 # input languages
ds=$2 # dataset folder name e.g. wiki
exp_name=$3

INPATH=/srv/scratch4/tinner/$ds/txt/XLM/30k_$lg #e.g. #e.g. /srv/scratch4/tinner/wiki/txt/XLM/30k_fr_tr
OUTPATH=$INPATH/xlm_out_$lg                     #_$lg

mkdir -p $OUTPATH

export CUDA_VISIBLE_DEVICES=4,5,6

python train.py \
    --amp 1 \
    --exp_name $exp_name \
    --dump_path $OUTPATH \
    --data_path $INPATH/ \
    --lgs 'tr' \
    --clm_steps '' \
    --mlm_steps 'tr' \
    --emb_dim 2048 \
    --n_layers 12 \
    --n_heads 16 \
    --dropout 0.1 \
    --attention_dropout 0.1 \
    --gelu_activation true \
    --batch_size 8 \
    --bptt 256 \
    --optimizer adam,lr=0.0001 \
    --epoch_size 300000 \
    --max_epoch 2 \
    --validation_metrics _valid_mlm_ppl \
    --stopping_criterion _valid_mlm_ppl,25 \
    --fp16 true
