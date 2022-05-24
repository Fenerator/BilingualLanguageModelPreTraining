#!/bin/bash
# Usage: ./generate_bpe.sh <LANGUAGE>

set -e

lg=$1  # input language

OUTPATH=data/processed/XLM_$lg/30k  # path where processed files will be stored
FASTBPE=tools/fastBPE/fast  # path to the fastBPE tool

# create output path
mkdir -p $OUTPATH

# learn bpe codes on the training set (or only use a subset of it)
$FASTBPE learnbpe 30000 data/wiki/txt/$lg.train > $OUTPATH/codes

$FASTBPE applybpe $OUTPATH/train.$lg data/wiki/txt/$lg.train $OUTPATH/codes &
$FASTBPE applybpe $OUTPATH/valid.$lg data/wiki/txt/$lg.valid $OUTPATH/codes &
$FASTBPE applybpe $OUTPATH/test.$lg data/wiki/txt/$lg.test $OUTPATH/codes &

cat $OUTPATH/train.$lg | $FASTBPE getvocab - > $OUTPATH/vocab &

# This will create three files: $OUTPATH/{train,valid,test}.en.pth
# After that we're all set
python preprocess.py $OUTPATH/vocab $OUTPATH/train.$lg &
python preprocess.py $OUTPATH/vocab $OUTPATH/valid.$lg &
python preprocess.py $OUTPATH/vocab $OUTPATH/test.$lg &