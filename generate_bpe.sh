#!/bin/bash
# Usage: ./generate_bpe.sh <LANGUAGE> <dataset folder name>

set -e

lg=$1  # input language
ds=$2 # dataset folder name

INPATH=/srv/scratch4/tinner/$ds/txt
OUTPATH=$INPATH/XLM_$lg_$ds/30k  

FASTBPE=tools/fastBPE/fast  # path to the fastBPE tool

# create output path
mkdir -p $OUTPATH

# learn bpe codes on the training set (or only use a subset of it)
echo "*** Learning BPE for $lg training set ... ***"
$FASTBPE learnbpe 30000 $INPATH/$lg.train > $OUTPATH/codes

echo "*** Applying BPE to $lg training set ... ***"
$FASTBPE applybpe $OUTPATH/train.$lg $INPATH/$lg.train $OUTPATH/codes &

echo "*** Applying BPE to $lg validation set ... ***"
$FASTBPE applybpe $OUTPATH/valid.$lg $INPATH/$lg.valid $OUTPATH/codes &

echo "*** Applying BPE to $lg test set ... ***"
$FASTBPE applybpe $OUTPATH/test.$lg $INPATH/$lg.test $OUTPATH/codes &

echo "*** Getting vocabulary for $OUTPATH/train.$lg to be stored at $OUTPATH/vocab ... ***"
cat $OUTPATH/train.$lg | $FASTBPE getvocab - > $OUTPATH/vocab &

# This will create three files: $OUTPATH/{train,valid,test}.en.pth
# After that we're all set

echo "*** Preprocessing vocabulary for $lg training set ... ***"
python preprocess.py $OUTPATH/vocab $OUTPATH/train.$lg &

echo "*** Preprocessing vocabulary for $lg validation set ... ***"
python preprocess.py $OUTPATH/vocab $OUTPATH/valid.$lg &

echo "*** Preprocessing vocabulary for $lg test set ... ***"
python preprocess.py $OUTPATH/vocab $OUTPATH/test.$lg &
