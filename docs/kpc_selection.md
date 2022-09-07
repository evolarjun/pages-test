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
SELECT contig_acc, contig_url, start_on_contig, stop_on_contig
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
gsutil -m cp `fgrep 'gs://' 295aa_kpc_contigs.out | awk '{print $6}'` contigs
```

#### Step 2b: Unzip the contig FASTA files
```
gzip -d contigs/*
```

### Step 3: Cut out the coding sequences
