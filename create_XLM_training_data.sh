#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

# Experiments on CC data
PATH=/srv/scratch4/tinner/CC/txt/XLM

#/30k_tr, fr, en
mkdir -p $PATH/ex1
mkdir -p $PATH/ex2
mkdir -p $PATH/ex5
mkdir -p $PATH/ex6

# TODO: renaiming!! of the training sets!
# Ex 1
# FR
exp = ex1
LANG_1 = fr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp      #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/train.$LANG_1 $PATH/$exp     #full size
cp $PATH/30k_$LANG_1/train.$LANG_1.pth $PATH/$exp #full size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp                 #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp             #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp            #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/train_small_n_fr.$LANG_2 $PATH/$exp     #same as fr size
cp $PATH/30k_$LANG_2/train_small_n_fr.$LANG_2.pth $PATH/$exp #same as fr size

# Ex 2
# FR
exp = ex2
LANG_1 = fr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp            #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp        #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp       #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/train_small.$LANG_1 $PATH/$exp     #small size
cp $PATH/30k_$LANG_1/train_small.$LANG_1.pth $PATH/$exp #small size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp      #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/train.$LANG_2 $PATH/$exp     # full size
cp $PATH/30k_$LANG_2/train.$LANG_2.pth $PATH/$exp # full size

# Ex 5
# TR
exp = ex5
LANG_1 = tr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp      #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/train.$LANG_1 $PATH/$exp     #full size
cp $PATH/30k_$LANG_1/train.$LANG_1.pth $PATH/$exp #full size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp                 #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp             #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp            #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/train_small_n_tr.$LANG_2 $PATH/$exp     #same as tr size
cp $PATH/30k_$LANG_2/train_small_n_tr.$LANG_2.pth $PATH/$exp #same as tr size

# Ex 6
# TR
exp = ex6
LANG_1 = tr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp            #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp        #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp       #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/train_small.$LANG_1 $PATH/$exp     #small size
cp $PATH/30k_$LANG_1/train_small.$LANG_1.pth $PATH/$exp #small size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp      #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/train.$LANG_2 $PATH/$exp     # full size
cp $PATH/30k_$LANG_2/train.$LANG_2.pth $PATH/$exp # full size

# Experiments on WIKI data
PATH=/srv/scratch4/tinner/wiki/txt/XLM

mkdir -p $PATH/ex3
mkdir -p $PATH/ex4
mkdir -p $PATH/ex7
mkdir -p $PATH/ex8

# Ex 3
# FR
exp = ex3
LANG_1 = fr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp      #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/train.$LANG_1 $PATH/$exp     #full size
cp $PATH/30k_$LANG_1/train.$LANG_1.pth $PATH/$exp #full size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp                 #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp             #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp            #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/train_small_n_fr.$LANG_2 $PATH/$exp     #same as fr size
cp $PATH/30k_$LANG_2/train_small_n_fr.$LANG_2.pth $PATH/$exp #same as fr size

# Ex 4
# FR
exp = ex4
LANG_1 = fr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp            #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp        #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp       #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/train_small.$LANG_1 $PATH/$exp     #small size
cp $PATH/30k_$LANG_1/train_small.$LANG_1.pth $PATH/$exp #small size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp      #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/train.$LANG_2 $PATH/$exp     # full size
cp $PATH/30k_$LANG_2/train.$LANG_2.pth $PATH/$exp # full size

# Ex 7
# TR
exp = ex7
LANG_1 = tr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp      #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp     #always
cp $PATH/30k_$LANG_1/train.$LANG_1 $PATH/$exp     #full size
cp $PATH/30k_$LANG_1/train.$LANG_1.pth $PATH/$exp #full size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp                 #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp             #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp            #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp                #always
cp $PATH/30k_$LANG_2/train_small_n_tr.$LANG_2 $PATH/$exp     #same as tr size
cp $PATH/30k_$LANG_2/train_small_n_tr.$LANG_2.pth $PATH/$exp #same as tr size

# Ex 8
# TR
exp = ex8
LANG_1 = tr
cp $PATH/30k_$LANG_1/codes.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/test.$LANG_1 $PATH/$exp            #always
cp $PATH/30k_$LANG_1/test.$LANG_1.pth $PATH/$exp        #always
cp $PATH/30k_$LANG_1/valid.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/valid.$LANG_1.pth $PATH/$exp       #always
cp $PATH/30k_$LANG_1/vocab.$LANG_1 $PATH/$exp           #always
cp $PATH/30k_$LANG_1/train_small.$LANG_1 $PATH/$exp     #small size
cp $PATH/30k_$LANG_1/train_small.$LANG_1.pth $PATH/$exp #small size
# EN
LANG_2 = en
cp $PATH/30k_$LANG_2/codes.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/test.$LANG_2 $PATH/$exp      #always
cp $PATH/30k_$LANG_2/test.$LANG_2.pth $PATH/$exp  #always
cp $PATH/30k_$LANG_2/valid.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/valid.$LANG_2.pth $PATH/$exp #always
cp $PATH/30k_$LANG_2/vocab.$LANG_2 $PATH/$exp     #always
cp $PATH/30k_$LANG_2/train.$LANG_2 $PATH/$exp     # full size
cp $PATH/30k_$LANG_2/train.$LANG_2.pth $PATH/$exp # full size
