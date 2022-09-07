Run the latest version of AMRFinderPlus on an assembly
=======================================================

Sometimes the results in MicroBIGG-E are from older versions of the software and you might want/need more recent results.

In this project we will show you how to access assemblies on the NCBI "ftp" site and run AMRFinderPlus.

we're going to look at assemblies for the following three biosamples: SAMN10432927, SAMN10221241, SAMN10221017

You can view the current pipeline results in the [Isolates Browser](https://www.ncbi.nlm.nih.gov/pathogens/isolates/#SAMN10432927%20SAMN10221241%20SAMN10221017) and [MicroBIGG-E](https://www.ncbi.nlm.nih.gov/pathogens/microbigge/#SAMN10432927%20SAMN10221241%20SAMN10221017). 

### FILL IN SOME MORE BACKGROUND HERE?

### Step 1: Find the path to assemblies

On the NCBI FTP site (also accessable via HTTPS) RefSeq and GenBank assemblies are indexed in tab-delimited text files with metadata and paths to assembly directories. For RefSeq the file is <https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt>, and for GenBank the file is <https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_genbank.txt>.  These files contain records for all assemblies at NCBI, so as you can imagine they're quite large.

RefSeq assemblies have accessions that start with **GCF_**, while GenBank assemblies have accessions that start with **GCA__**.

#### Step 1a: Make a work directory

```
mkdir -p ~/project1
cd ~/project1
```

#### Step 1b: Downlaod the metadata tables

```
wget https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_genbank.txt
```

#### Step 1b: Get the paths from the metadata table

```
egrep 'SAMN10432927|SAMN10221241|SAMN10221017' assembly_summary_genbank.txt | cut -f 3,20 > urls.tab
```

### Step 2: Download assembly and annotation files

For the most sensitive and accurate results with AMRFinderPlus use the assembly, GFF annotation, and annotated proteins as input.

```
while read -u 10 biosample URL
do
  # Make a working directory
  mkdir $biosample
  # get the list of input files for AMRFinderPlus
  curl -L $URL | egrep 'genomic.fna.gz|genomic.gff.gz|protein.faa.gz' | egrep -v '_rna_|_cds_' | cut -d '"' -f 2 > $biosample/files_to_get
  cd $biosample
  # For each of the required files
  for file in `cat files_to_get`
  do 
    # Download the file
    curl -L -O "$URL/$file" 
    # uncompress the file
    gzip -d $file
  done
  cd ..
done 10< urls.tab
```

### Step 3: Run AMRFinderPlus on each of the assemblies and annotations
```
for biosample in `cut -f 1 urls.tab`
do
  cd $biosample
  amrfinder -n *_genomic.fna -p *_protein.faa -g *_genomic.gff -O Escherichia --plus --threads 16 > $biosample.amrfinder
  cd ..
done
```

### Step 4: Look at the results

#### Step 4a: Examine AMRFinderPlus results for SAMN10432927

Some verbiage about what we're looking at...
```
d2l SAMN10432927/SAMN10432927.amrfinder
```

#### Step 4b: Examine AMRFinderPlus results for SAMN10221241
```
d2l SAMN10221241/SAMN10221241.amrfinder
```

#### Step 4c: Examine AMRFinderPlus results for SAMN10221017
```
d2l SAMN10221017/SAMN10221017.amrfinder
```
