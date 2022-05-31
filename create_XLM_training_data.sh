#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

# Experiments on CC data
# usage: ./create_XLM_training_data.sh  <dataset> <language model>

set -e

ds=$1
lm=$2

INPATH=/srv/scratch4/tinner/test/$ds/processed/$lm
OUTPATH=/srv/scratch4/tinner/test

# create directories for each experiment and fill them with symbolic links
if [ $lm == en_fr ]; then
    mkdir -p $OUTPATH/ex1_$ds
    mkdir -p $OUTPATH/ex2_$ds

    for exp in ex1_$ds ex2_$ds; do
        ln -s $INPATH/codes $OUTPATH/$exp/codes
        ln -s $INPATH/vocab $OUTPATH/$exp/vocab

        for lg in $(echo $lm | sed -e 's/\_/ /g'); do
            ln -s $INPATH/test.$lg $OUTPATH/$exp/test.$lg
            ln -s $INPATH/test.$lg.pth $OUTPATH/$exp/test.$lg.pth
            ln -s $INPATH/valid.$lg $OUTPATH/$exp/valid.$lg
            ln -s $INPATH/valid.$lg.pth $OUTPATH/$exp/valid.$lg.pth
        done
    done

    # individual for ex1
    ln -s $INPATH/train_small_n_fr.en $OUTPATH/ex1_$ds/train.en
    ln -s $INPATH/train_small_n_fr.en.pth $OUTPATH/ex1_$ds/train.en.pth
    ln -s $INPATH/train.fr $OUTPATH/ex1_$ds/train.fr
    ln -s $INPATH/train.fr.pth $OUTPATH/ex1_$ds/train.fr.pth

    # individual for ex2
    ln -s $INPATH/train.en $OUTPATH/ex2_$ds/train.en
    ln -s $INPATH/train.en.pth $OUTPATH/ex2_$ds/train.en.pth
    ln -s $INPATH/train_small.fr $OUTPATH/ex2_$ds/train.fr
    ln -s $INPATH/train_small.fr.pth $OUTPATH/ex2_$ds/train.fr.pth

fi

if [ $lm == en_tr ]; then
    mkdir -p $OUTPATH/ex3_$ds
    mkdir -p $OUTPATH/ex4_$ds

    for exp in ex3_$ds ex4_$ds; do
        ln -s $INPATH/codes $OUTPATH/$exp/codes
        ln -s $INPATH/vocab $OUTPATH/$exp/vocab

        for lg in $(echo $lm | sed -e 's/\_/ /g'); do
            ln -s $INPATH/test.$lg $OUTPATH/$exp/test.$lg
            ln -s $INPATH/test.$lg.pth $OUTPATH/$exp/test.$lg.pth
            ln -s $INPATH/valid.$lg $OUTPATH/$exp/valid.$lg
            ln -s $INPATH/valid.$lg.pth $OUTPATH/$exp/valid.$lg.pth
        done
    done

    # individual for ex3
    ln -s $INPATH/train_small_n_tr.en $OUTPATH/ex3_$ds/train.en
    ln -s $INPATH/train_small_n_tr.en.pth $OUTPATH/ex3_$ds/train.en.pth
    ln -s $INPATH/train.tr $OUTPATH/ex3_$ds/train.tr
    ln -s $INPATH/train.tr.pth $OUTPATH/ex3_$ds/train.tr.pth

    # individual for ex4
    ln -s $INPATH/train.en $OUTPATH/ex4_$ds/train.en
    ln -s $INPATH/train.en.pth $OUTPATH/ex4_$ds/train.en.pth
    ln -s $INPATH/train_small.tr $OUTPATH/ex4_$ds/train.tr
    ln -s $INPATH/train_small.tr.pth $OUTPATH/ex4_$ds/train.tr.pth
fi
