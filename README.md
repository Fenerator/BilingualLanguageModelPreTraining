# Pre-training of Bilingual Language Models

## Approaches

- Using Facebook's original code: Pre-training in the same way as XLM-R with MLM and TLM [here](https://github.com/facebookresearch/xlm#ii-cross-lingual-language-model-pretraining-xlm)
- using Huggingface: Pre-training of language model (monolingual only): [here](https://huggingface.co/blog/how-to-train)

## Corpi

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

## Steps to Run One Experiment

## Aim

Control for typology, domain, script of the pre-training material used. Investigate whether similar effects occur in the cross-lingual topic evaluation metrics as was the case with Swahili, where (1) very limited amounts of training material are available and (2) domains seem to be rather limited in terms of diversity / sources. Upload models then to Huggingface, where we can easily use them in the topic model afterwards.
