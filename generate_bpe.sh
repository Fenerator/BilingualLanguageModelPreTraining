#!/bin/bash
# Usage: ./generate_bpe.sh <LANGUAGE> <dataset>

set -e

lg=$1 # input language
ds=$2 # dataset folder name

INPATH=/srv/scratch4/tinner/$ds/txt
OUTPATH=$INPATH/XLM/30k_$lg

FASTBPE=tools/fastBPE/fast # path to the fastBPE tool

# create output path
mkdir -p $OUTPATH

# learn bpe codes on the training set (or only use a subset of it)
echo "*** Learning BPE for $lg training set storing in $OUTPATH/codes.$lg... ***"
$FASTBPE learnbpe 30000 $INPATH/$lg.train >$OUTPATH/codes.$lg

echo "*** Applying BPE to $lg training set ... ***"
$FASTBPE applybpe $OUTPATH/train.$lg $INPATH/$lg.train $OUTPATH/codes.$lg #FULL Dateset

if [ $lg==en ]; then
    echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
    $FASTBPE applybpe $OUTPATH/train_small_n_fr.$lg $INPATH/$lg.train_small_n_fr $OUTPATH/codes.$lg #FULL Dateset
    $FASTBPE applybpe $OUTPATH/train_small_n_tr.$lg $INPATH/$lg.train_small_n_tr $OUTPATH/codes.$lg #FULL Dateset
fi

if [ $lg==fr ]; then
    echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
    $FASTBPE applybpe $OUTPATH/train_small.$lg $INPATH/$lg.train_small $OUTPATH/codes.$lg #FULL Dateset
fi

if [ $lg==tr ]; then
    echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
    $FASTBPE applybpe $OUTPATH/train_small.$lg $INPATH/$lg.train_small $OUTPATH/codes.$lg #FULL Dateset
fi

echo "*** Applying BPE to $lg validation set ... ***"
$FASTBPE applybpe $OUTPATH/valid.$lg $INPATH/$lg.valid $OUTPATH/codes.$lg

echo "*** Applying BPE to $lg test set ... ***"
$FASTBPE applybpe $OUTPATH/test.$lg $INPATH/$lg.test $OUTPATH/codes.$lg

echo "*** Getting vocabulary for $OUTPATH/train.$lg to be stored at $OUTPATH/vocab.$lg ... ***"
cat $OUTPATH/train.$lg | $FASTBPE getvocab - >$OUTPATH/vocab.$lg

# This will create three files: $OUTPATH/{train,valid,test}.$lg.pth
# After that we're all set

echo "*** Preprocessing vocabulary for $lg training set ... ***"
python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/train.$lg

echo "*** Preprocessing vocabulary for $lg validation set ... ***"
python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/valid.$lg

echo "*** Preprocessing vocabulary for $lg test set ... ***"
python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/test.$lg

if [ $lg==tr ]; then
    echo "*** Preprocessing vocabulary for $lg small training set ... ***"
    python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/train_small.$lg
fi

if [ $lg==fr ]; then
    echo "*** Preprocessing vocabulary for $lg small training set ... ***"
    python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/train_small.$lg
fi

if [ $lg==en ]; then
    echo "*** Preprocessing vocabulary for $lg small training set ... ***"
    python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/train_small_n_fr.$lg
    python preprocess.py $OUTPATH/vocab.$lg $OUTPATH/train_small_n_tr.$lg
fi

#new
