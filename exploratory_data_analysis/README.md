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


There are 1266 phenotypes analyzed in the catalog reported as different

```
cut -f8 full | sed 1d | sort -u | wc -l
1266
```


# Selected phenotypes
200 phenotypes were selected according to the following criteria
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
./get_phenotype_data.sh > phenotypes_to_study.txt
```

# Calculation of sensitivity and specificity

Look for associations with reported odd ratio, risk allele frequency and case and control sample description:

```
grep -wv "NR" phenotypes_to_study.txt | grep -E 'case|control' | grep -vw "NA" | sort -u > phenotypes_to_study_w_required_data.txt
```

Sometimes, there are associations reported more than once since the SNPs were mapped to different genes:

|PUBMEDID|STUDY|DISEASE/TRAIT|INITIAL SAMPLE DESCRIPTION|REPLICATION SAMPLE DESCRIPTION|MAPPED_GENE|SNPS|RISK ALLELE FREQUENCY|P-VALUE|OR or BETA|
| ------------- |:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:| -------------:|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__PRC1__|rs2290203|0.504|4E-8|	1.08|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__PRC1-AS1__|rs2290203|0.504|4E-8|	1.08|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__RCCD1__|rs2290203|0.504|4E-8|	1.08|


That is why we just keep unique associations.

## Breast cancer

```
paste -d"\n" <( paste -d' ' <(printf '*\n%.0s' {1..10}) <(head -n1 phenotypes_to_study.txt | sed 's/\t/\n/g')) <(awk -F $'\t' '$4 == "Breast cancer"' phenotypes_to_study.txt | grep -wv "NR" | grep -E 'case|control' | sed -n -e1p | sed 's/\t/\n/g')
```
* PUBMEDID
25038754
* LINK
http://europepmc.org/abstract/MED/25038754
* STUDY
Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.
* DISEASE/TRAIT
Breast cancer
* INITIAL SAMPLE DESCRIPTION
2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls
* REPLICATION SAMPLE DESCRIPTION
5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls
* SNPS
rs11082321
* RISK ALLELE FREQUENCY
0.21
* P-VALUE
7E-7
* OR or BETA
1.08


> Controls && Positive(+) = Total controls * risk allele frequency

> Controls && Positive(+) = 61179 * 0.21 = 12847.59 ≈ 12848

> Controls && Negative(-) = Total controls - Controls && Negative(+)

> Controls && Negative(-) = 61179 - 12848 = 48331


|               |     Cases     |    Controls   |
| ------------- |:-------------:| -------------:|
| Positive (+)  |      7510     |      12848    |
| Negative (-)  |     26160     |      48331    |
|               |     33670     |      61179    |

'''
> Sensitivity
[1] 0.2230597
> Specificity
[1] 0.7899933
'''

---

```
paste -d"\n" <( paste -d' ' <(printf '*\n%.0s' {1..10}) <(head -n1 phenotypes_to_study.txt | sed 's/\t/\n/g')) <(awk -F $'\t' '$4 == "Breast cancer"' phenotypes_to_study.txt | grep -wv "NR" | grep -E 'case|control' | sed -n -e2p | sed 's/\t/\n/g')
```

* PUBMEDID
25038754
* LINK
http://europepmc.org/abstract/MED/25038754
* STUDY
Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.
* DISEASE/TRAIT
Breast cancer
* INITIAL SAMPLE DESCRIPTION
2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls
* REPLICATION SAMPLE DESCRIPTION
5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls
* SNPS
rs2290203
* RISK ALLELE FREQUENCY
0.504
* P-VALUE
4E-8
* OR or BETA
1.08

> Controls && Positive(+) = Total controls * risk allele frequency

> Controls && Positive(+) = 61179 * 0.504 = 30834.22 ≈ 30834

> Controls && Negative(-) = Total controls - Controls && Positive(+)

> Controls && Negative(-) = 61179 - 30834 = 30345


|               |     Cases     |    Controls   |
| ------------- |:-------------:| -------------:|
| Positive (+)  |     17617     |      30834    |
| Negative (-)  |     16053     |      30345    |
|               |     33670     |      61179    |


```
> Sensitivity
[1] 0.5232201
> Specificity
[1] 0.4960035
```


---


