# Data curation of GWAS catalog

Download GWAS catalog

```
wget https://www.ebi.ac.uk/gwas/api/search/downloads/full
```


Get order of columns

```
head -n1 full | sed 's/\t/\n/g' | cat -n > column_names
```

There are 27986 genome-wide associations in the catalog

```
sed 1d full | wc -l
27986
```


There are 1266 phenotypes analyzed in the catalog reported as different.
```
cut -f8 full | sed 1d | sort -u | wc -l
1266
```


# Selected phenotypes
200 phenotypes were selected according to the following criteria.
The phenotypes must be:
- Clinically relevant
- Relatively easy to measure or determine (no anthropological measures)
- Well represented by a considerable number of studies in the catalog
These phenotypes are contained in the file __selected_general_phenotypes.txt__



As an exploratory phase, we will focus in the following phenotypes:

- Depression (quantitative trait)
- Endometrial cancer
- Lymphoma
- Response to antidepressant treatment (citalopram)
- Response to tamoxifen in breast cancer 
- Breast cancer
- Breast Cancer in BRCA1 mutation carriers
- Response to mTOR inhibitor (rapamycin) 
- Multiple sclerosis 
- Ovarian cancer 
- Hypertension
- Lung cancer
- Autism
- Tuberculosis 
- Alzheimer's disease
- Major depressive disorder
- Epilepsy (generalized)
- Warfarin maintenance dose
- Response to hepatitis C treatment
- Rheumatoid arthritis
- Tuberculosis
- Diabetes
These phenotypes are contained in the file __selected_phenotypes.txt__


Get the following fields for the previous phenotypes:

- PUBMEDID
- LINK
- STUDY
- DISEASE/TRAIT
- INITIAL SAMPLE DESCRIPTION
- REPLICATION SAMPLE DESCRIPTION
- SNPS
- RISK ALLELE FREQUENCY
- P-VALUE OR or BETA

```
./get_phenotype_data-v0.1.sh > phenotypes_to_study.txt
```

Look for associations with reported odd ratio and case and control sample description:

## Breast cancer
```
grep -w "Breast cancer" phenotypes_to_study-v0.1.txt | grep -wv "NR" | grep -E 'case|control'
```


