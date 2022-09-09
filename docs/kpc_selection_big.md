# Project 4

## Step 1: Get a list of contigs with sequences of interest

### Step 1a: Create a working directory for this project

    mkdir -p ~/project5
    cd ~/project5

### Step 1b: Use BigQuery to get a list of contigs with KPC genes
```sh
bq query --use_legacy_sql=false --max_rows 50000 '
SELECT contig_acc, contig_url, start_on_contig, end_on_contig, strand, element_symbol
FROM `ncbi-pathogen-detect.pdbrowser.microbigge`
WHERE element_symbol LIKE "blaKPC%"
AND element_length = 293
AND amr_method IN ("EXACTX", "EXACTP", "ALLELEX", "ALLELEP")
' > 293aa_kpc_contigs.out
```

Lets take a look at the results

```sh
head 293aa_kpc_contigs.out
```

```
+----------------------+----------------------------------------------------------------------------------------------+-----------------+---------------+--------+----------------+
|      contig_acc      |                                          contig_url                                          | start_on_contig | end_on_contig | strand | element_symbol |
+----------------------+----------------------------------------------------------------------------------------------+-----------------+---------------+--------+----------------+
| ABHYDV010000138.1    | gs://ncbi-pathogen-assemblies/Klebsiella/1391/303/ABHYDV010000138.1.fna.gz                   |            7625 |          8506 | +      | blaKPC-3       |
| ABHXWB010000147.1    | gs://ncbi-pathogen-assemblies/Escherichia_coli_Shigella/1391/899/ABHXWB010000147.1.fna.gz    |             780 |          1661 | +      | blaKPC-3       |
| ABHXOB010000044.1    | gs://ncbi-pathogen-assemblies/Klebsiella/1392/629/ABHXOB010000044.1.fna.gz                   |            7759 |          8640 | +      | blaKPC-3       |
| ABHXOB010000093.1    | gs://ncbi-pathogen-assemblies/Klebsiella/1392/629/ABHXOB010000093.1.fna.gz                   |           12108 |         12989 | +      | blaKPC-3       |
| NZ_JAMPTY010000024.1 | gs://ncbi-pathogen-assemblies/Klebsiella/1327/241/NZ_JAMPTY010000024.1.fna.gz                |           41292 |         42173 | +      | blaKPC-2       |
| NZ_JANVCW010000005.1 | gs://ncbi-pathogen-assemblies/Klebsiella/1409/664/NZ_JANVCW010000005.1.fna.gz                |           77234 |         78115 | +      | blaKPC-2       |
| ABHYHV010000214.1    | gs://ncbi-pathogen-assemblies/Pseudomonas_aeruginosa/1391/196/ABHYHV010000214.1.fna.gz       |             356 |          1237 | +      | blaKPC-2       |
```

### Step 1c: How many contigs are we looking at?

```sh
wc -l 293aa_kpc_contigs.out
```
```
25052 293aa_kpc_contigs.out
```

Number of lines minus the header and footer 
25052 - 4 = 25048 contigs

It's a large number so we have to worry a little about performance.

### Step 2: Copy contig sequences from Google Storage bucket

```sh
mkdir contigs
# copy the contig sequences from GS bucket
time fgrep 'gs://' 293aa_kpc_contigs.out | awk '{print $4}' | gsutil -m cp -I contigs
```

```
...
- [25.2k/25.2k files][323.6 MiB/323.6 MiB] 100% Done 560.4 KiB/s ETA 00:00:00
Operation completed over 25.2k objects/323.6 MiB.

real	22m24.361s
user	7m37.503s
sys	1m12.552s
```

## Step 3: Cut out coding sequences

Because this is a large number of sequences there are some performance considerations. We'll use seqkit here because we're using it for many other steps in the process and it is fairly fast for what it does. Writing a custom script that can run this process in a highly parallel manner could speed things up considerably.

### Step 3a: Create BED file of coordinates we want to cut out
```sh
fgrep 'gs://' 293aa_kpc_contigs.out | awk '{print $2"\t"$6-1"\t"$8"\t"$12"\t1\t"$10}' > kpc_cds.bed
```

### Step 4b: Reformat FASTA contig identifiers

```sh
for file in contigs/*
do
    contig=`basename $file .fna.gz`
    zcat $file | sed "s/^>.*/>$contig/"
done > contigs.fna
```
Took about 1.5 minutes

### Step 4c: Cut out coding sequence

```sh
time cat contigs.fna | seqkit subseq --bed kpc_cds.bed > kpc_cds_all.fna
```
```
[INFO] read BED file ...
[INFO] 25162 BED features loaded

real	0m0.820s
user	0m0.500s
sys	0m0.471s
```

## Step 5: Prepare sequences for selection analysis


Trim stop codon and remove duplicate sequences for FUBAR analysis, then rename sequences to format suitable for downstream analysis

```sh
cat kpc_cds_all.fna \
    | seqkit subseq -r 1:879 \
    | seqkit rmdup -s -D kpc.duplicate_list \
    | perl -pe 's/>(.*)_.*(blaKPC.*)/>$2_$1/' \
    > kpc_cds.fna
```

How many unique CDS sequences do we have from the starting 25,162?

```sh
fgrep -c '>' kpc_cds.fna
```
```
60
```

## Step 6: Use RAxML to infer a tree

Note that all sequences are closely related and the same length so we will treat the FASTA file as an alignment. We need a tree to perform selection tests with HyPhy.

```sh
raxml-ng --search --msa-format FASTA --msa kpc_cds.fna --model GTR+I+G --redo
```

### Step 6: Run FUBAR test with HyPhy

__Need some background on FUBAR test__

```sh
hyphy fubar --alignment kpc_cds.fna --tree kpc_cds.fna.raxml.bestTree | tee kpc_cds.fubar
```

```
...
### Running an iterative zeroth order variational Bayes procedure to estimate the posterior mean of rate weights
* Using the following settings
	* Dirichlet alpha  : 0.5

### Tabulating site-level results
|     Codon      |   Partition    |     alpha      |      beta      |Posterior prob for positive selection|
|:--------------:|:--------------:|:--------------:|:--------------:|:-----------------------------------:|
|      239       |       1        |        3.090   |       26.278   |       Pos. posterior = 0.9417       |
----
## FUBAR inferred 1 sites subject to diversifying positive selection at posterior probability >= 0.9
Of these,  0.06 are expected to be false positives (95% confidence interval of 0-1 )

```


