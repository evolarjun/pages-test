Project 3: Look for selection in a set of KPC genes from isolates in the Pathogen Detection system
=====================================================================================================

For this project we will be looking at a set of coding sequences downloaded from the NCBI Pathogen Detection System. We'll use [HyPhy](http://www.hyphy.org/) to detect residues with evidence for positive selection in those sequences. For the sake of efficiency we're using criteria that will select a limited set of KPC genes, but this can be done for larger sets as well.

For the purposes of illustration we'll use the [FUBAR](https://pubmed.ncbi.nlm.nih.gov/23420840/) test for selected sites implemented in HyPhy.

### Step 1: Find blaKPC in MicroBIGG-E that are 295 amino-acids long

#### Step 1a: Make a working directory

```
mkdir -p ~/project2
cd ~/project2
```

#### Step 1b: Make sure we have authorization to use google cloud tools from the commandline

If you haven't already done this, run the command below and follow the instructions to authorize the google cli
```
gcloud auth login
```

#### Step 1c: get the paths to the contig sequences

We'll use the bigquery command-line interface to grab the paths to the contig sequences

```
bq query --use_legacy_sql=false --max_rows 5000 '
SELECT contig_acc, contig_url, start_on_contig, end_on_contig, strand, element_symbol
FROM `ncbi-pathogen-detect.pdbrowser.microbigge`
WHERE element_symbol LIKE "blaKPC%"
AND element_length = 295
' > 295aa_kpc_contigs.out
```

### Step 2: Download contig sequences

#### Step 2a: Copy the contigs using the URLs found in MicroBIGG-E
```
mkdir contigs
# copy the contig sequences from GS bucket
gsutil -m cp `fgrep 'gs://' 295aa_kpc_contigs.out | awk '{print $4}'` contigs
```

#### Step 2b: Unzip the contig FASTA files
```
gzip -d contigs/*
```

### Step 3: Trim contigs to get the coding sequence

#### Step 3a: Convert the bq output into simple format
```
fgrep 'gs://' 295aa_kpc_contigs.out | awk '{print $2"\t"$6"\t"$8"\t"$10"\t"$12}' > kpc_coords.tab
```

#### Step 3b: Cut out the coding sequences and put them into a single file

Cut out, reverse complement if necessary and provide phylip-compatible
convenient names for KPC sequences.

```
while read -u 10 contig start end strand symbol
do
  if [ "$strand" == "-" ]
  then
    # Cut out the coding sequence and reverse complement
    cat contigs/$contig.fna \
      | seqkit subseq -r "$start:$end" \
      | seqkit seq --seq-type dna --complement --reverse -v
  else
    # Cut out the coding sequence
    cat contigs/$contig.fna | seqkit subseq -r "$start:$end"
  fi | sed  "s/^>.*/>${contig}_$symbol /" 
done 10< kpc_coords.tab > kpc_cds_raw.fna 
```

Remove stop codons and duplicate sequences from FASTA file of KPC genes.
```
cat kpc_cds_raw.fna \
    | seqkit subseq -r 1:-4 \
    | seqkit rmdup -s -D kpc.duplicate_list \
    > kpc_cds.fna
```

### Step 5: Use RAxML to infer a tree

Note that all sequences are the same length so we will treat the FASTA file as an alignment. We need a tree to perform selection tests with HyPhy.

```
raxml-ng --search --msa kpc_cds.fna  --tree rand{50},pars{50} --model GTR+I+G --redo
```

### Step 6: Run FUBAR test with HyPhy

__Need some background on FUBAR test__

```
hyphy fubar --alignment kpc_cds.fna --tree kpc_cds.fna.raxml.bestTree | tee kpc_cds.fubar
```


