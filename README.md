# Pre-training of Bilingual Language Models

## Approaches

- Using Facebook's original code: Pre-training in the same way as XLM-R with MLM and TLM [here](https://github.com/facebookresearch/xlm#train-your-own-xlm-model-with-mlm-or-mlmtlm)
- using Huggingface: Pre-training of language model (monolingual only): [here](https://huggingface.co/blog/how-to-train)

## Corpora & Domains

*CC-100* -> multiple domains

*Wikipedia* -> single domain

### Languages

1. English: training size CC: WIKI:
2. French: training size CC : WIKI: 26685413
3. Turkish: training size CC: 1759580 WIKI:

We need the following partitions of each of the languages above:

- **small**: proportions to the pre-training material used in XLM-R
- **large**: use the same amount for both languages

## Experiments

Test size: 5000 lines, validation size: 5000 lines, rest used as training set
Recreate proportions of data used in the original pre-training of XLM-R. We substitute SW by FR resp. TR and created datasets that represent the same proportional amount of pre-training data measured in GiB: SW / EN = 0.53%.

Language Model: **EN_FR**

| Ex | Data | EN         | FR    |
|----|-------|------------|-------|
| 1  | CC    | same size as FR (small) | 100%  |
| 2  | CC    | 100% full size       | 0.53% of the EN size |
| 3  | Wiki  | same size as FR (small) | 100%  |
| 4  | Wiki  | 100% full size       | 0.53% of the EN size |

Language Model: **EN_TR**

| Ex | Data | EN         | TR    |
|----|-------|------------|-------|
| 1  | CC    | same size as TR (small) | 100%  |
| 2  | CC    | 100% full size       | 0.53% of the EN size |
| 3  | Wiki  | same size as TR (small) | 100%  |
| 4  | Wiki  | 100% full size       | 0.53% of the EN size |

## Steps to train one XLM Model

We apply the MLM approach only, as we do not have parallel corporas.

1. create venv, activate

2. install dependencies, apex:

    ```bash
    git clone https://github.com/NVIDIA/apex
    cd apex
    pip install -v --disable-pip-version-check --no-cache-dir ./
    ```

    ```bash
    # install XML package
    pip install -e .
    ```

3. Download and tokenize the data:

    ```bash
    tmux attach-session -t bllmpt

    # Download and tokenize Wikipedia data in 'data/wiki/en.{train,valid,test}'
    # Note: the tokenization includes lower-casing and accent-removal
    ./get-data-wiki.sh en #  Wiki:
    ./get-data-wiki.sh fr #  Done
    ./get-data-wiki.sh tr #  Done 

    ./get-data-cc.sh en #  CC:
    ./get-data-cc.sh fr #  Done
    ./get-data-cc.sh tr #  Done
    ```

    > if error: `head: unrecognized option '--10000'
    > Try 'head --help' for more information` occurs, delete files (correpsonding to `<LANG>`) in `data/wiki/txt`.

4. Generate training partitions

```bash
./generate_partitions.sh
```

5. Generate BPE:
    This script learns BPE on the training set using 30k codes, applys the encoding to all partitions of the data, creates the post-BPE vocabulary, and binarizes the data.

    Don't forget to adapt `$INPATH`. Vocab size set to 30'000.

    ```bash
    ./generate_bpe.sh en cc # 
    ./generate_bpe.sh fr cc # bllmpt-7 done
    ./generate_bpe.sh tr cc # Done

    ./generate_bpe.sh en wiki # 
    ./generate_bpe.sh fr wiki #  bllmpt_fr done
    ./generate_bpe.sh tr wiki # Done
    ```

5. Move all files into one required folder:

6. Train the model:

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
    --emb_dim 2048                             # embeddings / model dimension (2048 is big, reduce if only 16Gb of GPU memory)
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
