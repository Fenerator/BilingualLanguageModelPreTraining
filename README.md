# Pre-training of Bilingual Language Models

## Approaches

- Using Facebook's original code: Pre-training in the same way as XLM-R using MLM [here](https://github.com/facebookresearch/xlm#train-your-own-xlm-model-with-mlm-or-mlmtlm)
- (using Huggingface: Pre-training of language model (monolingual only): [here](https://huggingface.co/blog/how-to-train))

## Corpora & Domains

*CC-100* -> multiple domains

*Wikipedia* -> single domain

### Languages

1. English
2. French
3. Turkish

## Experiments

Test size: 5000 lines, validation size: 5000 lines, rest used as training set
Recreate proportions of data used in the original pre-training of XLM-R. We substitute SW by FR resp. TR and created datasets that represent the same proportional amount of pre-training data measured in GiB: SW / EN = 0.53%.

Language Model: **EN_FR** (`mod1.sh`)

| Ex # | Data | EN         | FR    |
|----|-------|------------|-------|
| 1_CC  | CC    | same size as FR (`train_small_n_fr.en`) | 100% full size  |
| 2_CC  | CC    | 100% full size       | 0.53% of the EN size (`train_small.fr`) |
| 1_wiki  | Wiki  | same size as FR (small) | 100%  |
| 2_wiki  | Wiki  | 100% full size       | 0.53% of the EN size (`train_small.fr`) |

Language Model: **EN_TR** (`mod2.sh`)

| Ex # | Data | EN         | TR    |
|----|-------|------------|-------|
| 3_CC  | CC    | same size as TR (`train_small_n_tr.en`) | 100%  |
| 4_CC  | CC    | 100% full size       | 0.53% of the EN size (`train_small.tr`) |
| 3_wiki | Wiki  | same size as TR (`train_small_n_tr.en`) | 100%  |
| 4_wiki  | Wiki  | 100% full size       | 0.53% of the EN size (`train_small.tr`) |

## Steps to train one XLM Model

We apply the MLM approach only, as we do not have parallel corporas.

1. create and activate venv I tested it using Python 3.7.3.

2. install dependencies from `requirements.txt`, I additionally needed  `apex`:

    ```bash
    git clone https://github.com/NVIDIA/apex
    cd apex
    pip install -v --disable-pip-version-check --no-cache-dir ./
    ```

3. all following steps (4-8) are executed by the `pretraining_pipeline.sh` script. This file contains all data related tasks and an examplary XLM model pre-training run of **model 1: en_fr** on the training files of `ex1_wiki` using default parameters. Inside the file `DATA_PATH` needs to be adapted.

    ```bash
    ./pretraining_pipeline.sh 
    ```

4. Download and tokenize the data: generates splits in the `txt` folder.

    ```bash
    # Note: the tokenization includes lower-casing and accent-removal
    ./get-data-wiki.sh en # <lang> <wiki path>
    ./get-data-wiki.sh fr 
    ./get-data-wiki.sh tr  

    ./get-data-cc-100.sh en #<language> <data path>
    ./get-data-cc-100.sh fr 
    ./get-data-cc-100.sh tr 
    ```

    > if error: `head: unrecognized option '--10000'
    > Try 'head --help' for more information` occurs, delete files (corresponding to `<LANG>`) in `data/wiki/txt`.

5. Generate bilingual training datasets and dataset of smaller sizes. All files are stored in the `txt` folder. Requires training files of all languages to be downloaded.

    ```bash
    ./generate-training-partitions.sh wiki en_fr # <dataset> <language pair>
    ./generate-training-partitions.sh wiki en_tr
    ./generate-training-partitions.sh cc en_fr
    ./generate-training-partitions.sh cc en_tr
    ```

6. Generate BPE:
This script learns BPE on the training set of the respective two languages using **30k** codes, applys the encoding to all partitions of the data, creates the post-BPE vocabulary, and binarizes the data.

        ```bash
        ./generate_bpe.sh cc en_fr 30000 # <dataset> <language-pair> <vocab size> <data path>
        ./generate_bpe.sh cc en_tr 30000

        ./generate_bpe.sh wiki en_fr 30000
        ./generate_bpe.sh wiki en_tr 30000 
        ```

7. Move all files into one folder required for one experiment and rename the files inside:

    ```bash
    ./create_XLM_training_data.sh wiki en_fr #<dataset> <language model> <data path>
    ./create_XLM_training_data.sh wiki en_tr
    ./create_XLM_training_data.sh cc en_fr
    ./create_XLM_training_data.sh cc en_tr
    ```

8. Train the model, here, default parameters are used:
`encoder only` is activated by default

    ```bash
    ./mod1.sh <experiment name> <experiment data folder>
    ```

    ```bash
    python train.py

    ## main parameters
    --exp_name xlm_en_zh                       # experiment name
    --dump_path ./dumped                       # where to store the experiment

    ## data location / training objective
    --data_path $OUTPATH                       # data location
    --lgs 'en-zh'                              #  languages lg1-lg2-lg3, ex: en-fr-es-de
    --clm_steps ''                             # CLM objective (for training GPT-2 models) Causal prediction steps (CLM)
    --mlm_steps 'en,zh'                        # MLM objective, lg1,lg2

    ## transformer parameters
    --emb_dim 2048                             # embedding layer size / model dimension (2048 is big, reduce if only 16Gb of GPU memory)
    --n_layers 12                              # number of Transformer layers
    --n_heads 16                               # number of Transformer heads
    --dropout 0.1                              # dropout
    --attention_dropout 0.1                    # attention dropout
    --gelu_activation true                     # GELU instead of ReLU

    ## optimization
    --batch_size 32                            # # Number of sentences per batch
    --bptt 256                                 # sequences length  (streams of 256 tokens)
    --optimizer adam,lr=0.0001                 # optimizer (training is quite sensitive to this parameter)
    --epoch_size 300000                        # number of sentences per epoch
    --max_epoch 100000                         # max number of epochs (~infinite here)
    --validation_metrics _valid_mlm_ppl        # validation metric (when to save the best model)
    --stopping_criterion _valid_mlm_ppl,25     # stopping criterion (if criterion does not improve 25 times)

    ## float16 / AMP API
    --amp 1 \ # Use AMP wrapper for float16 / distributed / gradient accumulation.
    --fp16 true                                # Run model with float16

    ## There are other parameters that are not specified here (see [here](https://github.com/facebookresearch/XLM/blob/master/train.py#L24-L198)).
    ```

## Aim

Control for typology, domain, script of the pre-training material used. Investigate whether similar effects occur in the cross-lingual topic evaluation metrics as was the case with Swahili, where (1) very limited amounts of training material are available and (2) domains seem to be rather limited in terms of diversity / sources. We probably do not need to fine-tune the model on sentence similarity detection, and just use mean pooling over all tokens to derive sentence representations.
