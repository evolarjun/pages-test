See [Test your installation](Test-your-installation.md) for some basic examples of expected input and expected output.

# Usage:

`amrfinder (-p <protein_fasta> | -n <nucleotide_fasta) [options]`<br />
`amrfinder -u`

The only required arguments are either `-p <protein_fasta>` for proteins or `-n
<nucleotide_fasta>` for assembled nucleotide sequence. We also provide an automatic update
mechanism to update the database by using `-u`. This will update to
the latest AMR database. See [Software upgrades](https://github.com/ncbi/amr/wiki/Upgrading#software-upgrades) for information about updating the software. Use '`--help`' to see the complete set of options and flags.

## Options:

### Commonly used options:

- `--protein <protein_fasta>` or `-p <protein_fasta>` Protein FASTA file to search.

- `--nucleotide <nucleotide_fasta>` or `-n <nucleotide_fasta>` Assembled nucleotide FASTA file to search. When running in combined mode (ie. using `-n`, `-p`, and `-g` options) this should be the genomic sequence, not the cut out coding sequence.

- `--gff <gff_file>` or `-g <gff_file>` GFF file to give sequence coordinates for
proteins listed in `-p <protein_fasta>`. Required for combined searches of
protein and nucleotide. The value of the 'Name=' variable in the 9th field in
the GFF must match the identifier in the protein FASTA file (everything between
the '>' and the first whitespace character on the defline). The first
column of the GFF must be the nucleotide sequence identifier in the
nucleotide\_fasta if provided (everything between the '>' and the first
whitespace character on the defline). To interpret the output of
[external PGAP](https://github.com/ncbi/pgap) annotations use the `--pgap`
option.

- `--organism <organism>` or `-O <organism>` Taxon used for screening known
  resistance causing point mutations specific typing (Stx Type for
  _Escherichia) and blacklisting of common, non-informative genes. `amrfinder
  -l` will list the possible values for this option. Note that rRNA mutations
  will not be screened if only a protein file is provided. To screen known
  Shigella mutations use Escherichia as the organism. See [Organism
  option](#--organism-option) below for more details.

- `--list_organisms` or `-l` Print the list of all possible taxonomy groups used
with the `-O/--organism` option.
 
- `--update` or `-u` Download the latest version of the AMRFinderPlus database to
the default location (location of the AMRFinderPlus binaries/data). Creates a
directory under `data` in the format `YYYY-MM-DD.<version>` (e.g.,
`2019-03-06.1`). Will not overwrite an existing directory. Use `--force_update`
to overwrite the existing directory with a new download.

- `--force_update` or `-U`  Download the latest version of the AMRFinderPlus
database to the default location. Creates a directory under `data` in the
format `YYYY-MM-DD.<version>` (e.g., `2019-03-06.1`), and overwrites an
existing directory.

- <a name="option--plus">`--plus` Provide results from "Plus" genes such as virulence factors,
stress-response genes, etc. See [AMRFinderPlus
database](/ncbi/amr/wiki/AMRFinderPlus-database#types-of-proteins-covered) for details.

- `--database_version` or `-V` Print out complete version information of both
  the database and software. This information is printed to STDERR by default when running AMRFinderPlus on files (using `-n` or `-p`), and this option should appear alone if it is used.

- `--print_node` <a name="option--print_node"></a> Add an additional "Hierarchy node" column to the output with the node identifier used for naming this hit in the AMRFinderPlus reference gene hierarchy. See our [Reference Gene Hierarchy help](https://www.ncbi.nlm.nih.gov/pathogens/docs/gene_hierarchy/) for more information.

## Less frequently used options:

- `--annotation_format <format>` or `-a <format>` read non-standard format to
determine GFF entry association with protein and nucleotide FASTA entries. This
option is experimental at this time; please report issues to
pd-help@ncbi.nlm.nih.gov.  In addition to the default which works with GenBank
and RefSeq files and is described in the section [Input file
formats](#input-file-formats) the following options are available. See [Input file
formats](#input-file-formats) for more details.
    -  `genbank` - GenBank (default)
    -  `bakta` - Bakta: rapid & standardized annotation of bacterial genomes, MAGs &
  plasmids
    -  `microscope` - Microbial Genome Annotation & Analysis Platform 
    -  `patric` - Pathosystems Resource Integration Center / BV-BRC
    -  `pgap` - NCBI Prokaryotic Genome Annotation Pipeline
    -  `prokka` - Prokka rapid prokaryotic genome annotation
    -  `pseudomonasdb` - The Pseudomonas Genome Database
    -  `rast` - Rapid Annotation using Subsystem Technology

- `--blast_bin <directory>` Directory to search for 3rd party binaries (blast and
hmmer) if not in the path.

- `--database <database_dir>` or `-d <database_dir>` Use an alternate database
directory. This can be useful if you want to run an analysis with a database
version that is not the latest. This should point to the directory containing
the full AMRFinderPlus database files. It is possible to create your own custom
databases, but it is not a trivial exercise. See [AMRFinderPlus database](AMRFinderPlus-database.md) for
details on the format.

- `--threads <#>` The number of threads to use for processing. AMRFinderPlus defaults
to 4 on hosts with >= 4 cores. Setting this number higher than the number of
cores on the running host may cause `blastp` to fail. Using more than 4 threads
may speed up searches with nucleotide sequences, but will have little effect if
only protein is used as the input.

- `--version` or `-v` Print out just the software version. For more complete information we recommend you use the `-V` command described above, but this is here to maintain backward compatibility.

- `--mutation_all <point_mut_report>` Report genotypes at all locations screened
for point mutations. This file allows you to distinguish between called point
mutations that were the sensitive variant and the point mutations that could
not be called because the sequence was not found. This file will contain all
detected variants from the reference sequence, so it could be used as an
initial screen for novel variants. Note "Gene symbols" for mutations not in the
database (identifiable by [UNKNOWN] in the Sequence name field) have offsets
that are relative to the start of the sequence indicated in the field
"Accession of closest sequence" while "Gene symbols" from known point-mutation
sites have gene symbols that match the
[Pathogen Detection Reference Gene Catalog](https://www.ncbi.nlm.nih.gov/pathogens/isolates#/refgene/).  See 
 [standardized nomenclature for point mutations](Point-mutation-nomenclature) for an explanation of the point mutations nomenclature used.

- `--name <identifier>` Prepend a column containing an identifier for this run of 
AMRFinderPlus. For example this can be used to add a sample name column to the 
AMRFinderPlus results.

- `--nucleotide_output <nucleotide.fasta>` Print a FASTA file of just the regions
of the `--nucleotide <input.fa>` that were identified by AMRFinderPlus. This
will include the entire region that aligns to the references for point
mutations. 

- `--nucleotide_flank5_output <nucleotide.fasta>` FASTA file of the regions of
the `--nucleotide <input.fa>` that were identified by AMRFinderPlus plus
`--nucleotide_flank5_size` additional nucleotides in the 5' direction, this
will include the entire region that aligns to the references for point
mutations plus the additional flank. 

- `--nucleotide_flank5_size <num_bases>` The number of additional bases in the 5'
direction to add to the element sequence in the `--nucleotide_flank5_output`
direction.

- `-o <output_file>` Print AMRFinderPlus output to a file instead of standard out.

- `--protein_output <protein.fasta>` Print FASTA file of Proteins identified by
AMRFinderPlus in the `--protein <input.fa>` file. Only selects from the
proteins provided on input, AMRFinderPlus will not do a translation of hits
identified from nucleotide sequence. 

- `-q` suppress the printing of status messages to standard error while AMRFinderPlus
is running. Error messages will still be printed.

- `--report_all_equal` Report all equally scoring BLAST and HMM matches. This
will report multiple lines for a single element if there are multiple reference
proteins that have the same score. On those lines the fields _Accession of
closest sequence_ and _Name of closest sequence_ will be different showing each
of the database proteins that are equally close to the query sequence.

- `--ident_min <0-1>` or `-i <0-1>` Minimum identity for a blast-based hit hit
(Methods BLAST or PARTIAL). -1 means use the curated threshold if it exists and
0.9 otherwise. Setting this value to something other than -1 will override
curated similarity cutoffs. We only recommend using this option if you have a 
specific reason; don't make our curators sad by throwing away some of their 
hard work.

- `--coverage_min <0-1>` or `-c <0-1>` Minimum proportion of reference gene
covered for a BLAST-based hit (Methods BLAST or PARTIAL). Default value is 0.5

- `--translation_table <1-33>` or `-t <1-33>` Number from 1 to 33 to represent
the translation table used for BLASTX. Default is 11. See [Translation table
description](https://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi) for
a description of the available tables.

- `--pgap` Alters the GFF and FASTA file handling to correctly interpret the
output of the pgap pipeline. Note that you should use the `annot.fna` file in
the pgap output directory as the argument to the `-n/--nucleotide` option.

- `--gpipe_org` Use Pathogen Detection taxgroup names as arguments to the --organism option

- `--parm <parameter string>` Pass additional parameters to amr_report. This is
mostly used for development and debugging.

- `--debug` Perform some additional integrity checks. May be useful for
debugging, but not intended for public use.

## `--organism` option

The `-O/--organism` option is used to get organism-specific results. For those
organisms which have been curated, using `--organism` will get optimized
organism-specific results. AMRFinderPlus uses the `--organism` for two
purposes:

1. To screen for point mutations
2. To filter out genes that are nearly universal in a group and uninformative
3. To identify divergent _Streptococcus pneumoniae_ and _Neisseria gonorrhoeae_ pbp proteins that are usually penicillin resistant (`-O Streptococcus_pneumoniae` or `-O Neisseria_gonorrhoeae`)
4. To run [StxTyper](https://github.com/ncbi/stxtyper) to type Stx operons (`-O Escherichia`).

We currently curate a limited set of organisms for point mutations and/or
blacklisting of some [plus genes](AMRFinderPlus-database#plus-proteins.md) that
are not likely to be informative in those species. Use `amrfinder -l` to list
the organism options that can be used in the current database. Use the
[Reference Gene
Catalog](https://www.ncbi.nlm.nih.gov/pathogens/isolates#/refgene/) to identify
the [point
mutations](https://www.ncbi.nlm.nih.gov/pathogens/isolates#/refgene/whitelisted_taxa:*)
and [blacklisted
genes](https://www.ncbi.nlm.nih.gov/pathogens/isolates#/refgene/blacklisted_taxa:*)
that are affected by this option. A summary of what taxa have received specific attention from curators and where the AMRFinderPlus database has coverage for point mutations, virulence genes, and stress response genes is on the [Curated organisms](Curated-organisms) page.


For information on which organisms our curators have specifically worked on and believe we have good coverage in the AMRFinderPlus database for see [Curated Organisms](Curated-Organisms.md)

<a name="organisms-table">

| Organism option                 | Point mutations   | Blacklisted `--plus` genes | Notes         |
| :-------------------------------| :---------------: | :------------------------: | :------------ |
| Acinetobacter_baumannii         | X                 |                            | Use for the [_A. baumannii-calcoaceticus_ species complex](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=909768) |
| Bordetella_pertussis            | X                 |                            |
| Burkholderia_cepacia            | X                 |                            | Use for the [_Burkholderia cepacia_ species complex](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=87882) |
| Burkholderia_mallei             | X                 |                            |               |
| Burkholderia_pseudomallei       | X                 |                            | Use for the [_Burkholderia pseudomallei_ species complex](https://www.ncbi.nlm.nih.gov/Taxonomy/Browser/wwwtax.cgi?id=111527) |
| Campylobacter                   | X                 |                            | Use for _C. coli_ and _C. jejuni_ | 
| Citrobacter_freundii            | X                 |                            |               |
| Clostridioides_difficile        | X                 |                            |               |
| Corynebacterium_diphtheriae     | X                 |                            |               |
| Enterobacter_asburiae           | X                 |                            |               | 
| Enterobacter_cloacae            | X                 |                            |               |
| Enterococcus_faecalis           | X                 |                            |               |
| Enterococcus_faecium            | X                 |                            | Use for _E. hirae_              |
| Escherichia                     | X                 | X                          | Use for _Shigella_ and _Escherichia_, will also run StxTyper if `--nucleotide` and `--plus` are used. |
| Haemophilus_influenzae          | X                 |                            |               |
| Klebsiella_oxytoca              | X                 | X                          |   |
| Klebsiella_pneumoniae           | X                 | X                          | Use for _K. pneumoniae_ species complex and _K. aerogenes_ |
| Neisseria_gonorrhoeae           | X                 |                            |               |
| Neisseria_meningitidis          | X                 |                            |               |
| Pseudomonas_aeruginosa          | X                 |                            |               |
| Salmonella                      | X                 | X                          |               |
| Serratia_marcescens             | X                 |                            |               |
| Staphylococcus_aureus           | X                 |                            |               |
| Staphylococcus_pseudintermedius | X                 | X                          |               |
| Streptococcus_agalactiae        | X                 |                            |               |
| Streptococcus_pneumoniae        | X                 |                            | Use for _S. pneumoniae_ and _S. mitis_              |
| Streptococcus_pyogenes          | X                 |                            |               |
| Vibrio_cholerae                 | X                 | X                          |               |
| Vibrio_parahaemolyticus         | X                 |                            |               |
| Vibrio_vulnificus               | X                 |                            |               |

Note that variant detection for Streptococcus\_pneumoniae PBPs uses a mechanism
identifying divergent alleles. See [Interpreting Results](Interpreting-results#a-note-about-subtype-amr-susceptible-and-streptococcus-pneumoniae.md) for more
information.

# Temporary files

AMRFinderPlus creates a fair number of temporary files in `/tmp` by default. If the environment variable `TMPDIR` is set AMRFinderPlus will instead put the temporary files in the directory pointed to by `$TMPDIR`.

# Examples

These examples use the test files [test_prot.gff](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff), [test_prot.fa](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa), and [test_dna.fa](https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa) if you want to try them for yourself.

    # print a list of command-line options
    amrfinder --help
    
    # Download the latest AMRFinderPlus database
    amrfinder -u
    
    # Protein AMRFinder with no genomic coordinates
    amrfinder -p test_prot.fa
    
    # Translated nucleotide AMRFinder (will not use HMMs)
    amrfinder -n test_dna.fa
    
    # Protein AMRFinder using GFF to get genomic coordinates and 'plus' genes
    amrfinder -p test_prot.fa -g test_prot.gff --plus
    
    # Protein AMRFinder with Escherichia protein point mutations
    amrfinder -p test_prot.fa -O Escherichia
    
    # Full AMRFinderPlus search combining results
    amrfinder -p test_prot.fa -g test_prot.gff -n test_dna.fa -O Escherichia --plus

# Accessory programs for non-standard database issues

AMRFinderPlus includes a couple of programs to assist with non-standard scenarios for database updates.

[`amrfinder_update`](amrfinder_update) downloads and indexes the latest database version to a custom location.

[`amrfinder_index`](amrfinder_index) will run the commands to generate the BLAST and HMMER databases from the distributed AMRFinderPlus database files. This indexing is automatic when running `amrfinder -u` or `amrfinder_update`.


# Input file formats

There are three possible input files to AMRFinderPlus, the `--protein` FASTA
file, the `--nucleotide` FASTA file, and the `--gff` file to tie them together.
Any of these files will be automatically decompressed with `gunzip` if their
filename ends in `.gz`; automatic handling of gzipped input files requires the
command `gunzip` to be in your path.

Note that AMRFinderPlus does not support unicode (UTF-8), however as of version
3.11.14 it should ignore unicode characters that don't start contain bytes
between 0x00 and 0x1F.

When run in the most sensitive and accurate "combined" mode AMRFinderPlus needs
a way to relate the results from the protein FASTA file and the nucleotide
FASTA file together and it uses the `--gff` file to do that. Unfortunately
there isn't a standard for relating the entries of the FASTA files with the GFF
file.  By default AMRFinderPlus reads the format of files downloaded from
GenBank/RefSeq. The `--annotation_format` option added to version 3.10.38 adds
automated parsing of the output files of different annotation engines. 

### The `--annotation_format <format>` option

This option allows AMRFinderPlus to parse and associate entries in GFF files
with protein and nucleotide FASTA files in the data coming out of other
annotation systems and databases. This feature is a bit experimental as we do
not have extensive experience with many of these data sources, so please report
any issues to pd-help@ncbi.nlm.nih.gov or as [GitHub
issues](https://github.com/ncbi/amr/issues). The default behavior is described
under the [`-g <gff_file>`](#-g-gff_file) section below. 

Parameters for the `--annotation_format` / `-a` are as follows:

- `genbank` - Files downloaded from NCBI GenBank or RefSeq (default), rules are somewhat complicated by need to handle various NCBI-produced formats
- `standard` - Default behavior follows [the rules below](#--annotation_format-standard) to parse files downloaded from NCBI databases
- `bakta` - Bakta: rapid & standardized annotation of bacterial genomes, MAGs &
  plasmids <https://github.com/oschwengers/bakta>
- `microscope` - Microbial Genome Annotation & Analysis Platform <https://mage.genoscope.cns.fr/microscope>
- `patric` - Pathosystems Resource Integration Center <https://www.patricbrc.org> / BV-BRC <https://www.bv-brc.org>
- `pgap` - NCBI Prokaryotic Genome Annotation Pipeline <https://www.ncbi.nlm.nih.gov/genome/annotation_prok>
- `prodigal` - Prodigal Gene Prediction Software <https://github.com/hyattpd/Prodigal>
- `prokka` - Prokka rapid prokaryotic genome annotation <https://github.com/tseemann/prokka>
- `pseudomonasdb` - The Pseudomonas Genome Database <https://pseudomonas.com/>
- `rast` - Rapid Annotation using Subsystem Technology <http://RAST.nmpdr.org>

### `-g <gff_file>` 

GFF files are used to get sequence coordinates for AMRFinderPlus hits from protein
sequence and associate them with hits on nucleotide sequence. Use the [`--annotation_format` option described above](#the---annotation_format-format-option) for some common data sources. 

The defaults will correctly parse input files downloaded from NCBI resources such as GenBank and RefSeq (`--annotation_format genbank`). This parsing is very similar to the "Standard behavior" described below except that `locus_tag=<protein accession>` and `<project>:<accession>` formats are handled in deflines and GFF files.

Note that in GFF files some characters in identifiers need to be escaped using URL-style escapes:

- \# (comment start)
- tab (%09)
- newline (%0A)
- carriage return (%0D)
- % percent (%25)
- control characters (%00 through %1F, %7F)
- ; semicolon (%3B)
- = equals (%3D)
- & ampersand (%26)
- , comma (%2C)

In addition quotes and tick-marks are trimmed, and for the default `--annotation_format genbank` the ":" character should be avoided or escaped because it is used in some NCBI formats.

#### `--annotation_format standard`

This is enabled by the `--annotation_format standard` option and is very similar to `--annotation_format genbank`.  
__The value of the 'Name=' variable in the 9th field in the GFF must
match the identifier in the protein FASTA file__ (everything between the '>'
and the first whitespace character on the defline). The first column of the GFF
must be the nucleotide sequence identifier in the nucleotide_fasta if provided
(everything between the '>' and the first whitespace character on the defline).
See
[test_prot.gff](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff),
[test_prot.fa](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa),
and
[test_dna.fa](https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa)
for a simple example. See [Test your installation](Test-your-installation.md) for how to run the
examples.  

Simple example below (These were taken from
[test_prot.gff](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff).
See those files to see how the identifiers line up):

```
contig09	.	gene	1	675	.	-	.	Name=aph3pp-Ib_partial_5p_neg
contig09	.	gene	715	1377	.	-	.	Name=sul2_partial_3p_neg
contig11	.	gene	113	547	.	+	.	Name=blaTEM-internal_stop
```
Matching deflines from assembly:
```
>contig09 >case4_case6_sul2_aph3pp-Ib Providencia rettgeri strain Pret_2032, whole genome shotgun sequence  2160922-2162737  150-1527 (reverse comp'd)
>contig11 blaTEM divergent, with internal stop codon
```
Matching protein deflines:
```
>aph3pp-Ib_partial_5p_neg  NZ_QKNQ01000001.1 Providencia rettgeri strain Pret_2032, whole genome shotgun sequence  2160922-2162737  150-1527  704-137
>sul2_partial_3p_neg   NZ_QKNQ01000001.1 Providencia rettgeri strain Pret_2032, whole genome shotgun sequence  2160922-2162737  150-1377  2-667
>blaTEM-internal_stop
```

Some annotation pipelines will produce annotation files that AMRFinderPlus will have trouble reading. The [`--annotation_format` option described above](#the---annotation_format-format-option) will automatically handle most of them, but it it usually a simple matter to convert them to an appropriate format. If you are having trouble email us at pd-help@ncbi.nlm.nih.gov (or open a [GitHub issue](https://github.com/ncbi/amr/issues))  with examples of the FASTA and GFF files you are trying to use and we should be able to help. 


### `-p <protein_fasta>` and `-n <nucleotide_fasta>`

FASTA files are in a fairly standard format: Lines beginning with '>' are
considered deflines, and sequence identifiers are the first non-whitespace
characters on the defline. Sequence identifiers are what is reported AMRFinderPlus
output Example FASTA files:
[`test_prot.fa`](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa)
and
[`test_dna.fa`](https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa).
The sequence identifiers must match  the GFF file to use combined searches or
add genomic coordinates to protein searches (see above).

Because of some strange handling by BLAST the following additional requirements must be met for the FASTA sequence identifiers for the `-n <nucleotide_fasta>` file:

'makeblastdb' truncates and/or alters sequence identifiers with the following characteristics. Now nucleotide FASTA identifiers (characters after '>' and before the first whitespace) with any of the following will cause `amrfinder` to exit with an error message.

   - FASTA identifier starts with '?'
   - FASTA identifier contains the two character sequence ',,' or '\t' (the character '\\' followed by the character 't')
   - FASTA identifier ends with ';' '~' ',' or '.'

If you're having trouble with the input file formats see the
[`--annotation_format` option described
above](#the---annotation_format-format-option) or email us at
pd-help@ncbi.nlm.nih.gov (or open a [github
issue](https://github.com/ncbi/amr/issues))  with examples of the FASTA and GFF
files you are trying to use and we should be able to help.

# Output format

AMRFinder output is in tab-delimited format (.tsv). The output format depends
on the options `-p`, `-n`, and `-g`. Protein searches with gff files (`-p <file.fa> -g <file.gff>` and translated dna searches (`-n <file.fa>`) will  
include the `Contig id`, `start`, and `stop` columns. 

### Sample AMRFinderPlus report:

`amrfinder -p ` [`test_prot.fa`](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.fa) ` -g ` [`test_prot.gff`](https://raw.githubusercontent.com/ncbi/amr/master/test_prot.gff) ` -n ` [`test_dna.fa`](https://raw.githubusercontent.com/ncbi/amr/master/test_dna.fa)` -O Campylobacter`

Should
result in the sample output shown below and in [`test_both.expected`](https://raw.githubusercontent.com/ncbi/amr/master/test_both.expected).

```
Protein id               Contig id Start Stop Strand Element symbol Element name                                              Scope Type Subtype Class          Subclass       Method              Target length Reference sequence length % Coverage of reference % Identity to reference Alignment length Closest reference accession Closest reference name                                              HMM accession HMM description
blaTEM-156               contig01    101  961      + blaTEM-156     class A beta-lactamase TEM-156                            core  AMR  AMR     BETA-LACTAM    BETA-LACTAM    ALLELEP                       286                       286                  100.00                  100.00              286 WP_061158039.1              class A beta-lactamase TEM-156                                      NF000531.2    TEM family class A beta-lactamase
blaPDC-114_blast         contig02      1 1191      + blaPDC         PDC family class C beta-lactamase                         core  AMR  AMR     BETA-LACTAM    CEPHALOSPORIN  BLASTP                        397                       397                  100.00                   99.75              397 WP_061189306.1              class C beta-lactamase PDC-114                                      NF000422.6    PDC family class C beta-lactamase
blaOXA-436_partial       contig03    101  802      + blaOXA         OXA-48 family class D beta-lactamase                      core  AMR  AMR     BETA-LACTAM    BETA-LACTAM    PARTIALP                      233                       265                   87.92                  100.00              233 WP_058842180.1              OXA-48 family carbapenem-hydrolyzing class D beta-lactamase OXA-436 NF012161.0    class D beta-lactamase
vanG                     contig04    101 1147      + vanG           D-alanine--D-serine ligase VanG                           core  AMR  AMR     GLYCOPEPTIDE   VANCOMYCIN     EXACTP                        349                       349                  100.00                  100.00              349 WP_063856695.1              D-alanine--D-serine ligase VanG                                     NF000091.3    D-alanine--D-serine ligase VanG
NA                       contig05    260 2021      - 23S_A2075G     Campylobacter macrolide resistant 23S                     core  AMR  POINT   MACROLIDE      MACROLIDE      POINTN                       1762                      2912                   60.51                   99.83             1762 NC_022347.1:1040292-1037381 23S ribosomal RNA                                                   NA            NA
gyrA                     contig06     31 2616      + gyrA_T86A      Campylobacter quinolone resistant GyrA                    core  AMR  POINT   QUINOLONE      QUINOLONE      POINTP                        862                       863                   99.88                   99.54              862 WP_002857904.1              DNA gyrase subunit A GyrA                                           NA            NA
NA                       contig06   2680 3102      + rplV_A103V     Campylobacter macrolide resistant RplV                    core  AMR  POINT   MACROLIDE      MACROLIDE      POINTX                        141                       141                  100.00                   97.16              141 WP_002851214.1              50S ribosomal protein L22                                           NA            NA
50S_L22                  contig07    101  526      + rplV_A103V     Campylobacter macrolide resistant RplV                    core  AMR  POINT   MACROLIDE      MACROLIDE      POINTP                        141                       141                  100.00                   97.16              141 WP_002851214.1              50S ribosomal protein L22                                           NA            NA
NA                       contig08    101  700      + blaTEM         TEM family class A beta-lactamase                         core  AMR  AMR     BETA-LACTAM    BETA-LACTAM    PARTIAL_CONTIG_ENDX           200                       286                   69.93                  100.00              200 WP_061158039.1              class A beta-lactamase TEM-156                                      NA            NA
aph3pp-Ib_partial_5p_neg contig09      1  675      - aph(3'')-Ib    aminoglycoside O-phosphotransferase APH(3'')-Ib           core  AMR  AMR     AMINOGLYCOSIDE STREPTOMYCIN   PARTIAL_CONTIG_ENDP           225                       267                   81.27                  100.00              217 WP_001082319.1              aminoglycoside O-phosphotransferase APH(3'')-Ib                     NF032896.1    APH(3'') family aminoglycoside O-phosphotransferase
sul2_partial_3p_neg      contig09    715 1377      - sul2           sulfonamide-resistant dihydropteroate synthase Sul2       core  AMR  AMR     SULFONAMIDE    SULFONAMIDE    PARTIAL_CONTIG_ENDP           221                       271                   81.55                  100.00              221 WP_001043265.1              sulfonamide-resistant dihydropteroate synthase Sul2                 NA            NA
NA                       contig10    486 1307      + blaOXA         OXA-9 family oxacillin-hydrolyzing class D beta-lactamase core  AMR  AMR     BETA-LACTAM    BETA-LACTAM    INTERNAL_STOP                 274                       274                  100.00                   99.64              274 WP_000722315.1              oxacillin-hydrolyzing class D beta-lactamase OXA-9                  NA            NA
blaTEM-internal_stop     contig11    113  547      + blaTEM         TEM family class A beta-lactamase                         core  AMR  AMR     BETA-LACTAM    BETA-LACTAM    INTERNAL_STOP                 144                       286                   50.35                   97.22              144 WP_000027057.1              broad-spectrum class A beta-lactamase TEM-1                         NA            NA
nimIJ_hmm                contigX       1  501      + nimIJ          NimIJ family 5-nitroimidazole reductase                   core  AMR  AMR     NITROIMIDAZOLE NITROIMIDAZOLE HMM                           166                       165                   98.18                   76.54              162 WP_005812825.1              NimIJ family 5-nitroimidazole reductase                             NF000262.1    NimIJ family 5-nitroimidazole reductase
```

### Fields:

- __Protein id__ - This is from the FASTA defline for the protein or DNA sequence.
- __Contig id__ - (optional) Contig name.
- __Start__ - (optional) 1-based coordinate of first nucleotide coding for protein in DNA sequence on contig.
- __Stop__ - (optional) 1-based coordinate of last nucleotide coding for protein in DNA sequence on contig.  Note that for protein hits (where the Method is HMM or ends in P) the coordinates are taken from the GFF, which means that for circular contigs when the protein spans the contig break the stop coordinate may be larger than the contig size (see the [GFF3 standard](https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md) for details)
- __Strand__ - The orientation of the sequence identified '+' or '-' strand is indicated relative to the query sequence.
- __Element symbol__ - Gene or gene-family symbol for protein or nucleotide hit. For point mutations it is a combination of the gene symbol and the SNP definition separated by "\_", for stx operons it is the operon type/subtype followed by "\_operon". Point mutations are the gene followed by "\_" then the mutation. See also [StxTyper README](https://github.com/ncbi/stxtyper/blob/main/README.md) and [Point mutation nomenclature](Point-mutation-nomenclature.md).
- __Element name__ - Full-text name for the protein, RNA, or point mutation.
- __Scope__ - The AMRFinderPlus database is split into 'core' AMR proteins that are expected to have an effect on resistance and 'plus' proteins of interest added with less stringent inclusion criteria. These may or may not be expected to have an effect on phenotype. 
- __Type__ - AMRFinderPlus genes are placed into functional categories based on predominant function AMR, STRESS, or VIRULENCE. See [Element Type and Subtype](Interpreting-results#element-type-and-subtype) for more details.
- __Subtype__ - Further elaboration of functional category into (ACID, AMR, BIOCIDE, HEAT, METAL, POINT, POINT_DISRUPT, STX_TYPE) if more specific category is available, otherwise he element is repeated. See [Element Type and Subtype](Interpreting-results#element-type-and-subtype) for more details.
- __Class__ - For AMR genes this is the class of drugs that this gene is known to contribute to resistance of. 
- __Subclass__ - If more specificity about drugs within the drug class is known it is elaborated here. 
- __Method__ - Type of hit found by AMRFinder. A suffix of 'P' or 'X' is appended to "Methods" that could be found by protein or nucleotide. See [The Method column](/ncbi/amr/wiki/Interpreting-results#the-method-column) for more information on standard AMRFinderPlus "Methods" and how they are determined. For StxTyper output there are a slightly different set of "Methods" because of differences in operon typing. See the [StxTyper output documentation](https://github.com/ncbi/stxtyper#output) for details.
  - ALLELE - 100% sequence match over 100% of length to a protein named at the allele level in the AMRFinderPlus database.
  - EXACT - 100% sequence match over 100% of length to a protein in the database that is not a named allele.
  - BLAST - BLAST alignment is > 90% of length and > 90% identity to a protein in the AMRFinderPlus database.
  - PARTIAL - BLAST alignment is > 50% of length, but < 90% of length and > 90% identity to the reference, and does not end at a contig boundary.
  - PARTIAL_CONTIG_END - BLAST alignment is > 50% of length, but < 90% of length and > 90% identity to the reference, and the break occurrs at a contig boundary indicating that this gene is more likely to have been split by an assembly issue.
  - HMM - HMM was hit above the cutoff, but there was not a BLAST hit that met standards for BLAST or PARTIAL. This does not have a suffix because only protein sequences are searched by HMM. 
  - INTERNAL_STOP - Translated blast reveals a stop codon that occurred before the end of the protein. This can only be assessed if the `-n <nucleotide_fasta>` option is used.
  - POINT - Point mutation identified by blast.  
- __Target length__ - The length of the query protein or gene. The length will be in amino-acids if the reference sequence is a protein, but nucleotide if the reference sequence is nucleotide.
- __Reference sequence length__ - The length of the Reference protein or nucleotide in the database if a blast alignment was detected, otherwise NA. Stx operons have this field as blank or NA because the references used are protein sequences for the two subunits.
- __% Coverage of reference__ - % of reference covered by blast hit if a blast alignment was detected, otherwise NA. Stx operons have this field as blank or NA to avoid confusion about the way % identities are calculated for Stx Typing. See the [StxTyper documentation](https://github.com/ncbi/stxtyper/blob/main/README.md) for details.
- __% Identity to reference__ - % amino-acid identity to reference protein or nucleotide identity for nucleotide reference if a blast alignment was detected, otherwise NA. For Stx operons this is the combined amino-acid identity of the two subunits.
- __Alignment length__ - Length of BLAST alignment in amino-acids or nucleotides if nucleotide reference if a blast alignment was detected, otherwise NA.
- __Closest reference accession__ - RefSeq accession for reference hit by BLAST if a blast alignment was detected otherwise NA. Note that only one reference will be chosen if the blast hit is equidistant from multiple references. For point mutations the reference is the sensitive "wild-type" allele, and the element symbol describes the specific mutation. Check the [Reference Gene Catalog](https://www.ncbi.nlm.nih.gov/pathogens/refgene/) for more information on specific mutations or reference genes. For Stx operons this is comma-separated accessions of the reference proteins for the stxA and stxB subunits (if both are present).
- __Closest reference name__ - Full name assigned to the closest reference hit if a blast alignment was detected, otherwise NA.
- __HMM accession__ - Accession for the HMM, NA if none.
- __HMM description__ - The family name associated with the HMM, NA if none.
- __Hierarchy node__ (optional) - The node in the [Reference Gene Hierarchy](https://www.ncbi.nlm.nih.gov/pathogens/genehierarchy/) that this hit was assigned to for naming. Fusion genes and stx operons with multiple hierarchy types will have multiple values separated by '::'. This field only appears when the `--print_node` option is used.

## Common errors and what they mean

### Protein id "\<protein id\>" is not in the .gff-file

To automatically combine overlapping results from protein and nucleotide searches the coordinates of the protein in the assembly contigs must be indicated by the GFF file. This requires a GFF file where the value of the 'Name=' variable of the 9th field in the GFF must match the identifier in the protein FASTA file (everything between the '>' and the first whitespace character on the defline). See the [section on GFF file format](Running-AMRFinderPlus#-g-gff_file) for details of how AMRFinderPlus associates FASTA file entries with GFF file entries.

## Known Issues

#### Circular contigs
AMRFinderPlus does not have the concept of circular contigs, so genes that cross the break in circular contigs may be detected only as fragments. By default AMRFinderPlus has a length cutoff of 50% of the full gene length, so one side or the other should be detected at least as a partial_contig_end or blast hit. Depending on the annotation system proteins may be annotated crossing the contig boundary in circular contigs (NCBI's PGAP does this). These full-length proteins will be analyzed by AMRFinderPlus. Note that the stop coordinate in this case will extend past the contig boundary as described by the [GFF specification](https://github.com/The-Sequence-Ontology/Specifications/blob/master/gff3.md).

#### GFF file formats are not all standard
GFF files are used to identify coordinates for protein sequences, but the association between the identifiers in the GFF and FASTA files is not part of the standard. See [Input file formats](#input-file-formats) for details of how AMRFinderPlus associates FASTA file entries with GFF file entries. If you have issues getting your GFF files to work please file an issue or email us at pd-help@ncbi.nlm.nih.gov including the files you are trying to use. 

If you find bugs or have other questions/comments please email
us at pd-help@ncbi.nlm.nih.gov or Create a [GitHub issue](https://github.com/ncbi/amr/issues).
