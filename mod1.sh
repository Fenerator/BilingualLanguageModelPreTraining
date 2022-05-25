#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Usage: ./mod1.sh
#

lg=$1 # input language
ds=$2 # dataset folder name

INPATH=/srv/scratch4/tinner/$ds/txt
OUTPATH=$INPATH/XLM/30k_$lg

export CUDA_VISIBLE_DEVICES=5,6

python train.py \
    --amp 1 \
    --exp_name xlm_tr_test1 \
    --dump_path ./dumped \
    --data_path $OUTPATH/ \
    --lgs 'tr' \
    --clm_steps '' \
    --mlm_steps 'tr' \
    --emb_dim 2048 \
    --n_layers 12 \
    --n_heads 16 \
    --dropout 0.1 \
    --attention_dropout 0.1 \
    --gelu_activation true \
    --batch_size 32 \
    --bptt 256 \
    --optimizer adam,lr=0.0001 \
    --epoch_size 300000 \
    --max_epoch 2 \
    --validation_metrics _valid_mlm_ppl \
    --stopping_criterion _valid_mlm_ppl,25 \
    --fp16 true
