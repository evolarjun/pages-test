Pathogen Detection in the cloud workshop
====================================

## Microbial Pathogen resources at google cloud

These projects demonstrate how to access and do some simple analyses using [NCBI Pathogen Detection](https://www.ncbi.nlm.nih.gov/pathogens/) data and cloud resources in Google Cloud.

Workshop organization
----------------------
- [Background](Pathogen-Background)
- Exercises
    + [Project 1:](Project-1) Use BigQuery to search MicroBIGG-E and Isolates data
    + [VM Setup](Setup)
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

More information
---------------------------
See the [Pathogen Detection home page](https://www.ncbi.nlm.nih.gov/pathogens/) and [NCBI Pathogen Detection Project web documentation](https://www.ncbi.nlm.nih.gov/pathogens/pathogens_help/) for more information on the Pathogen Detection Project. For questions about this self-paced demo/tutorial or anything else about the NCBI Pathogen Detection project email us at <mailto:pd-help@ncbi.nlm.nih.gov>.

Has this been useful?
-----------------------

Please let us know at suggest@ncbi.nlm.nih.gov if this has been useful and if
you're using any of these resources in your work and especially if you use
these resources in your publications.
