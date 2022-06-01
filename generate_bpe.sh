#!/bin/bash
# Usage: ./generate_bpe.sh <dataset> <lm-pair> <vocab size> <data path>

set -e

ds=$1 # dataset folder name
lm=$2 # language model pair (e.g. en_tr or en_fr)
vocabSize=$3
DATA_PATH=$4

#INPATH=/srv/scratch4/tinner/$ds/txt
INPATH=$DATA_PATH/$ds/txt
#OUTPATH=/srv/scratch4/tinner/$ds/processed/$lm
OUTPATH=$DATA_PATH/$ds/processed/$lm
echo LM $lm

FASTBPE=tools/fastBPE/fast # path to the fastBPE tool

# create output path
mkdir -p $OUTPATH

# learn bpe codes on the bilingual training set
echo "*** Learning BPE for $lm training set. Storing in $OUTPATH/codes ... ***"
$FASTBPE learnbpe $vocabSize $INPATH/$lm.train >$OUTPATH/codes

echo "*** Getting post BPE vocabulary for $INPATH/$lm.train to be stored at $OUTPATH/vocab ... ***"
cat $INPATH/$lm.train | $FASTBPE getvocab - >$OUTPATH/vocab

for lg in $(echo $lm | sed -e 's/\_/ /g'); do
    for split in train valid test; do
        echo "*** Applying BPE to $lg $split sets ... ***"
        $FASTBPE applybpe $OUTPATH/$split.$lg $INPATH/$lg.$split $OUTPATH/codes
        echo "*** Preprocessing Vocab for $OUTPATH/$split.$lg ... ***"
        python preprocess.py $OUTPATH/vocab $OUTPATH/$split.$lg
    done
    if [ $lg == en ]; then
        echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
        $FASTBPE applybpe $OUTPATH/train_small_n_fr.$lg $INPATH/$lg.train_small_n_fr $OUTPATH/codes
        $FASTBPE applybpe $OUTPATH/train_small_n_tr.$lg $INPATH/$lg.train_small_n_tr $OUTPATH/codes
        echo "*** Preprocessing vocabulary for $lg small training set n_fr and n_tr ... ***"
        python preprocess.py $OUTPATH/vocab $OUTPATH/train_small_n_fr.$lg
        python preprocess.py $OUTPATH/vocab $OUTPATH/train_small_n_tr.$lg
    fi
    if [ $lg == fr ]; then
        echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
        $FASTBPE applybpe $OUTPATH/train_small.$lg $INPATH/$lg.train_small $OUTPATH/codes
        echo "*** Preprocessing vocabulary for $lg small training set ... ***"
        python preprocess.py $OUTPATH/vocab $OUTPATH/train_small.$lg
    fi
    if [ $lg == tr ]; then
        echo "*** Applying BPE to $lg smaller training set of $lg ... ***"
        $FASTBPE applybpe $OUTPATH/train_small.$lg $INPATH/$lg.train_small $OUTPATH/codes
        echo "*** Preprocessing vocabulary for $lg small training set ... ***"
        python preprocess.py $OUTPATH/vocab $OUTPATH/train_small.$lg
    fi
done
