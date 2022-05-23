# Pre-training of Bilingual Language Models

## Approaches

- Using Facebook's original code: Pre-training in the same way as XLM-R with MLM and TLM [here](https://github.com/facebookresearch/xlm#train-your-own-xlm-model-with-mlm-or-mlmtlm)
- using Huggingface: Pre-training of language model (monolingual only): [here](https://huggingface.co/blog/how-to-train)

## Corpora

### Languages

1. English
2. French
3. Turkish

We need the following partitions of each of the languages above:

- single domain
- multiple domain
- small
- large

### Content

- **Domains**: comparable (only Wikipedia) vs. multi-domain (all sources)
- **Amount** of training material: Small, large

## Experiments

Language Model: **EN_FR**

- [ ] single domain for both languages: trained on Wikipedia material only
- [ ] multiple domain for both languages: all domains available
- [ ] equal amount of training material for both languages (full size of smaller dataset)
- [ ] different amount of training material: small amount, large amount (proportional to sizes of SW to EN or GER or FR)

Language Model: **EN_TR**

- [ ] single domain for both languages: trained on Wikipedia material only
- [ ] multiple domain for both languages: all domains available
- [ ] equal amount of training material for both languages (full size of smaller dataset)
- [ ] different amount of training material: small amount, large amount (proportional to sizes of SW to EN or GER or FR)

## Steps to train own XLM Model

We use monolingual data consisting of multiple corpora thus we apply the MLM approach.

Download and tokenize the data:

```bash
# Download and tokenize Wikipedia data in 'data/wiki/en.{train,valid,test}'
# Note: the tokenization includes lower-casing and accent-removal
./get-data-wiki.sh en

# Optionally use this for tokenization:
lg=en
cat my_file.$lg | ./tools/tokenize.sh $lg > my_tokenized_file.$lg &
```

learn BPE using xxx codes:

```bash
OUTPATH=data/processed/XLM_en/30k  # path where processed files will be stored
FASTBPE=tools/fastBPE/fast  # path to the fastBPE tool

# create output path
mkdir -p $OUTPATH

# learn bpe codes on the training set (or only use a subset of it)
$FASTBPE learnbpe 30000 data/wiki/txt/en.train > $OUTPATH/codes
```

apply BPE on all partitions of the data (train/valid/test):

```bash
$FASTBPE applybpe $OUTPATH/train.en data/wiki/txt/en.train $OUTPATH/codes &
$FASTBPE applybpe $OUTPATH/valid.en data/wiki/txt/en.valid $OUTPATH/codes &
$FASTBPE applybpe $OUTPATH/test.en data/wiki/txt/en.test $OUTPATH/codes &
```

get the post-BPE vocabulary:

```bash
cat $OUTPATH/train.en | $FASTBPE getvocab - > $OUTPATH/vocab &
```

Binarize the data:

```bash
# This will create three files: $OUTPATH/{train,valid,test}.en.pth
# After that we're all set
python preprocess.py $OUTPATH/vocab $OUTPATH/train.en &
python preprocess.py $OUTPATH/vocab $OUTPATH/valid.en &
python preprocess.py $OUTPATH/vocab $OUTPATH/test.en &
```

Train the model:

```bash
python train.py

## main parameters
--exp_name xlm_en_zh                       # experiment name
--dump_path ./dumped                       # where to store the experiment

## data location / training objective
--data_path $OUTPATH                       # data location
--lgs 'en-zh'                              # considered languages
--clm_steps ''                             # CLM objective (for training GPT-2 models)
--mlm_steps 'en,zh'                        # MLM objective

## transformer parameters
--emb_dim 1024                             # embeddings / model dimension (2048 is big, reduce if only 16Gb of GPU memory)
--n_layers 12                              # number of layers
--n_heads 16                               # number of heads
--dropout 0.1                              # dropout
--attention_dropout 0.1                    # attention dropout
--gelu_activation true                     # GELU instead of ReLU

## optimization
--batch_size 32                            # sequences per batch
--bptt 256                                 # sequences length  (streams of 256 tokens)
--optimizer adam,lr=0.0001                 # optimizer (training is quite sensitive to this parameter)
--epoch_size 300000                        # number of sentences per epoch
--max_epoch 100000                         # max number of epochs (~infinite here)
--validation_metrics _valid_mlm_ppl        # validation metric (when to save the best model)
--stopping_criterion _valid_mlm_ppl,25     # stopping criterion (if criterion does not improve 25 times)
--fp16 true                                # use fp16 training

## There are other parameters that are not specified here (see [here](https://github.com/facebookresearch/XLM/blob/master/train.py#L24-L198)).
```

## Aim

Control for typology, domain, script of the pre-training material used. Investigate whether similar effects occur in the cross-lingual topic evaluation metrics as was the case with Swahili, where (1) very limited amounts of training material are available and (2) domains seem to be rather limited in terms of diversity / sources. Upload models then to Huggingface, where we can easily use them in the topic model afterwards.
