---
# Methods
---

## AMRFinderPlus database

For more information on the format and methods used to compile the database see
the [AMRFinderPlus database documentation](AMRFinderPlus-database.md).

The AMRFinderPlus database is generated at NCBI and curation is ongoing. The
most recent versions are available at
https://ftp.ncbi.nlm.nih.gov/pathogen/Antimicrobial_resistance/AMRFinderPlus/database/latest,
and older versions are archived there as well. Hits are identified based on the [Reference Gene Hierarchy](https://www.ncbi.nlm.nih.gov/pathogens/genehierarchy/) and are named by the most specific hit that meets all requirements. 

## Protein searches (-p)

AMRFinderPlus protein searches use the database of AMR gene sequences, protein
profile hidden Markov models (HMMs), the hierarchical tree of AMR protein
families, and a custom rule-set to generate names and coordinates for AMR
genes, along with descriptions of the evidence used to identify the sequence.
Genes are reported with the following procedure after both HMMER and BLASTP
searches are run.

### BLASTP matches

BLASTP is run with the `-evalue 1e-20 -comp_based_stats 0` 
options against the AMR gene database described above.  Exact BLAST matches
over the full length of the reference protein are reported. If there is no
exact match, then the following default rules are applied *unless overridden by
a curated blast cutoff*: Matches with < 90% identity or with < 50% coverage of
the protein are dropped. If the hit is to a fusion protein than at least 90% of
the protein must be covered. Curated blast cutoffs override these defaults.
A BLAST match to a reference protein is removed if it is covered by another
BLAST match which has more identical residues or the same number of identical
residues, but to a longer reference protein. A single match is chosen as the
best of what remains sorting by the following criteria in order (1) if it is
exact; (2) has more identical residues; (3) hits a shorter protein; or (4) the
gene symbol comes first in alphabetical order.

### HMM matches

HMMER version 3.1b2 (http://hmmer.org/) is run using the `--cut_tc -Z 10000`
options with the HMM database described above. HMM matches with full_score
< TC1 or domain_score < TC2 are dropped. All HMM matches to HMMs for parent
nodes of other HMM matches in the hierarchy are removed. The match(es) with the
highest full score are kept. If a BLAST match is not exact and an HMM up the 
hierarchy exists, it must match at least one HMM up the hierarchy at above cutoff.

## Translated DNA searches (-n)

Translated AMRFinder can help to identify partial, split or unannotated AMR
proteins. It runs BLASTX of the assembly genomic sequences against the AMR
protein database with the parameters: `-word_size 3 -evalue 1e-10
-query_gencode <GENCODE> -seg no -comp_based_stats 0 -max_target_seqs 10000
-show_gis`. The algorithm for selecting hits is as described above for
proteins, but HMM searches are not performed.

## Point mutation identification

Point mutations are curated on an
[`--organism`](Running-AMRFinderPlus#--organism-option) specific basis and are
identified when AMRFinderPlus is run with the curated `--organism` option.

Point mutations are identified by blastn alignments that must cover at least 50%
of the reference (or `--coverage_min` if set) at 90% identity (or `--ident_min`
if set). Offsets are calculated relative to the beginning of the reference and
reported in that coordinate system. That is if there are indels within the
query sequence the coordinates of the point mutation will reflect the offset
from the start codon in the reference rather than in the query sequence.

### POINT\_DISRUPT point mutations

Mutations in some genes that are known to be associated with resistance when
dirupted are detected by AMRFinderPlus and have the subtype POINT_DISRUPT. See
the Reference Gene Catalog for a [list of POINT\_DISRUPT
genes](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#POINT_DISRUPT) and in
what taxa they are searched for (add the "whitelisted taxa" column to see which
organisms are curated for each of the genes). AMRFinderPlus identifies these
disrupted genes using translated BLAST against nucleotides to be able to
correctly identify nonsense mutations, indels, and frame shifts. This means that
they are only identified when the `--nucleotide` option is used along with the
corresponding [`--organism`](Running-AMRFinderPlus#--organism-option).

Because translated BLAST is used to identify the disrupting mutations it is
possible that some mutations may be missed, especially if they occur at the
ends of genes where not enough identical sequence may be present for BLAST to
detect an aligning fragment. Very large insertions may only show up as partial
alignments and may not be reported.

## AMR-SUSCEPTIBLE and _Streptococcus pneumoniae_ PBP genes

Genes in the database that are of [subtype](Interpreting-results#a-note-about-subtype-amr-susceptible-and-streptococcus-pneumoniae) AMR-SUSCEPTIBLE ([listed here](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#subtype:(%22AMR-SUSCEPTIBLE%22))) are detected by using a cutoff to identify genes more divergent than expected for the known susceptible variants of the gene. Detection of these genes is currently only activated when the `--organism Streptococcus_pneumoniae` option is used. 

## Combining translated nucleotide and protein hits

When provided with nucleotide, protein, and coordinate information
AMRFinderPlus will attempt to remove hits that overlap by > 75%

Protein hits generally take priority over nucleotide hits, except if the protein hit is of lower "quality" than the nucleotide hit where quality is measured by the hit "Method". 

    ALLELE > EXACT > BLAST > INTERNAL_STOP > PARTIAL_CONTIG_END > PARTIAL > HMM


For algorithmic details see Feldgarden et al. Sci Rep. 2021 Jun 16;11(1):12728 doi: [10.1038/s41598-021-91456-0](https://doi.org/10.1038/s41598-021-91456-0). PMID: [34135355](https://pubmed.ncbi.nlm.nih.gov/34135355/); PMCID: [PMC8208984](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8208984/).
