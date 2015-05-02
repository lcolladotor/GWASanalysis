# Data curation of GWAS catalog

Download GWAS catalog

```shell
 wget https://www.ebi.ac.uk/gwas/api/search/downloads/full
--2015-04-27 18:29:54--  https://www.ebi.ac.uk/gwas/api/search/downloads/full
Resolving www.ebi.ac.uk (www.ebi.ac.uk)... 193.62.192.80
Connecting to www.ebi.ac.uk (www.ebi.ac.uk)|193.62.192.80|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: unspecified [text/tsv]
Saving to: ‘full’

    [                                                                            <=>                         ] 14 765 572  1016KB/s   in 16s    

2015-04-27 18:30:10 (910 KB/s) - ‘full’ saved [14765572]
```


Get order of columns

```
head -n1 full | sed 's/\t/\n/g' | cat -n > column_names
```

There are 28827 genome-wide associations in the catalog

```
sed 1d full | wc -l
28827
```


There are 1266 phenotypes analyzed in the catalog reported as different

```
cut -f8 full | sed 1d | sort -u | wc -l
1288
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
- STRONGEST SNP-RISK ALLELE
- SNPS
- RISK ALLELE FREQUENCY
- P-VALUE OR or BETA

```
./get_phenotype_data.sh > phenotypes_to_study.txt
```

# Calculation of sensitivity and specificity

Look for associations with reported odd ratio, risk allele frequency and case and control sample description:

```
grep -wv "NR" phenotypes_to_study.txt | grep -E 'case|control' | grep -vw "NA" | awk -F'\t' '$8 != "" && $9 != "" && $10 != "" && $11 != "" ' | sort -u > phenotypes_to_study_w_required_data
```

Sometimes, there are associations reported more than once since the SNPs were mapped to different genes:

|PUBMEDID|STUDY|DISEASE/TRAIT|INITIAL SAMPLE DESCRIPTION|REPLICATION SAMPLE DESCRIPTION|MAPPED_GENE|SNPS|RISK ALLELE FREQUENCY|P-VALUE|OR or BETA|
| ------------- |:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:|:-------------:| -------------:|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__PRC1__|rs2290203|0.504|4E-8|	1.08|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__PRC1-AS1__|rs2290203|0.504|4E-8|	1.08|
|25038754|Genome-wide association analysis in East Asians identifies breast cancer susceptibility loci at 1q32.1, 5q14.3 and 15q26.1.|Breast cancer|2,867 Chinese ancestry cases, 2,285 Chinese ancestry controls, 2,246 Korean ancestry cases, 2,052 Korean ancestry controls|5,029 Chinese ancestry cases, 5,302 Chinese ancestry controls, 6,066 Korean ancestry cases, 8,003 Korean ancestry controls, 6,572 Japanese ancestry cases, 6,539 Japanese ancestry controls, 16,003 European ancestry cases, 41,335 European ancestry controls|__RCCD1__|rs2290203|0.504|4E-8|	1.08|


That is why we just keep unique associations.

After having the phenotypes to study, manual curation for each paper is performed for:
- Population size of cases and controls
- Risk allele frequency
- Odd ratio
- Determining whether the risk allele frequency belongs to case or control group.


The following are columns added to this file in order to curate each study:
- CASES: Sample size of population for cases
- CONTROLS: Sample size of population for controls
- STUDY PHASE: Phase of study considered in the catalog, (e.g. first, second, third, replication or combined phase)
- CLINICAL VARIABLES: Some relevant clinical measures carried out in the study
- NOTES: Style-free notes about the study (observations, important information, study design, etc..)

Data table is ordered by phenotype column in ascending mode.




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

```
> Sensitivity
[1] 0.2230597
> Specificity
[1] 0.7899933
```

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


``` R
> b = 30834
> d = 30345
> total = 33670
> OR = 1.08
> a = b*total/((d/OR) + b)
> c = total - a
> Sensitivity = a/(a+c)
> Specificity = d/(b+d)
> Sensitivity
[1] 0.5232201
> Specificity
[1] 0.4960035
> (a*d) / (b*c)
[1] 1.08
```


---


