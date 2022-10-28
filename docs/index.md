2022 ASM NGS Pre-conference workshop
====================================

## Microbial Pathogen and SARS-CoV-2 Resources in the Cloud

This is the pre-conference workshop wiki where we'll take you through the projects used for the conference.


Workshop organization
----------------------
- [Setup](Setup)
- Part 1: SRA and NCBI Virus
    + [Introduction](Introduction)
    + [Background](Background)
    + [Introductory Exercises](Exercises)
    + Projects
        + [Project A](Project_A): Find SARS-CoV-2 data with paired Illumina and ONT samples, generated using ARTICv3
        + [Project B](Project_B): Find SARS-CoV-2 data with low reference coverage
        + [Project C](Project_C): Find variant calls that are common between paired Illumina and ONT SARS-CoV-2 records
- Part 2: NCBI Pathogen Detection
	+ [Background](Pathogen-Background)
	+ Exercises
		+ [Project 1:](Project-1) Use BigQuery to search MicroBIGG-E and Isolates data
        + [Project 2:](Project-2) Build a phylogeny of reference blaKPC alleles
		+ [Project 3:](Project-3) Look for evidence of positively selected sites in blaKPC genes

Workshop goals
---------------
- Demonstrate use of BigQuery in the Google Cloud Console and commandline `bq` 
- Show how BigQuery can be used to do analysis of microbigge, isolates, and
  isolate_exceptions tables and how they relate to the web interface
- Demonstrate downloading sequences and phylogenetic analysis from the
  Reference Gene Catalog and visualization using iTOL
- Demonstrate using `gsutil` to download MicroBIGG-E contig sequences from
  cloud storage buckets
- Demonstrate the use of seqkit to perform some common operations on FASTA
  files
- Show how to slice out coding sequences from contig sequences and perform
  simple selection analysis on genes in MicroBIGG-E


Don't have a cloud account?
-----------------------------
NIH [Science and Technology Research Infrastructure for Discovery,
Experimentation, and Sustainability (STRIDES) Initiative](https://datascience.nih.gov/strides) has launched a new NIH
Cloud Lab program that lets you experiment with using cloud for your research.
You can request a GCP or AWS account, and will receive $500 and three months,
in addition to access to biomedical tutorials that walk you through common
cloud-based research use cases. This is available to intramural researchers
currently but expect it to be ready for extramural researchers in the coming
months. Learn more via this link- <https://cloud.nih.gov/resources/cloudlab/>

Has this been useful?
-----------------------

Please let us know at suggest@ncbi.nlm.nih.gov if this has been useful and if you're using any of these resources in your work and especially if you use these resources in your publications.
