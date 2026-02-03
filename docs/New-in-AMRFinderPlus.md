# AMRFinderPlus 4.2

__WARNING:__ This version has a different database format from versions 1.0-4.0 and is not compatible with those database versions (ie. this is not compatible with database releases before 2025-12-03.1). Run `amrfinder -u` after installing to download the most recent compatible database version.

AMRFinderPlus version 4.2.4 has a few changes. The most significant is we added the ability for AMRFinderPlus to identify putatively function disrupting mutations in genes that lead to resistance when disrupted (frame shifts and stop codons) . Calls for these genes will have a subtype of POINT_DISRUPT.

As part of this new functionality we slightly revised our standard point mutation naming system to handle the sometimes complex mutations identified by the new POINT_DISRUPT module and to bring them closer to the HGVS standard. "STOP" became "Ter" and Frame shifts will identify the length of sequence before the stop codon E.g., cirA_Y253CfsTer5. See https://github.com/ncbi/amr/wiki/Point-mutation-nomenclature for details.

Another change was made to better handle an edge case we encountered. The rules designed to get correct call on partial fusion genes were changed where the previous versions excluded extended proteins with > 20-aa that don't align. Version 4.2.4 allows a fusion gene call to override the smaller individual subunit call if 1 or more amino-acids align to the fusion gene than the subunit gene.

Concurrent with making these changes we also significantly refactored the code to interpret blast output for both AMRFinderPlus and StxTyper and made for slightly improved alignments. These changes can change match statistics (e.g., % Identity and % Coverage) for the following reasons:

- AMRFinderPlus improved translated BLAST alignments when the final amino-acid is a mismatch, this sometimes causes AMRFinderPlus version 4.2.2 to identify slightly longer alignments with a slightly lower overall percent identity. Stop codons are not included in the hit length, or percent identity.
- When the first Methionine (M) of a reference protein aligns to a Leucine (L), Isoleucine (I), or Valine (V) it is no-longer counted as a mismatch in the percent identity calculation reported by AMRFinderPlus. This behavior makes for more accurate statistics for proteins annotated with an incorrect early start.

## Upgrading

See [[Upgrading]] for instructions on how to update to the latest version of the software and database.

See [[Installing AMRFinder]] for help with new installations.

## Known issues

* Customers installing from the binary distribution have sometimes had linking problems because of glibc versions and libcurl. Please let us know if you have problems. Bioconda installations should avoid these issues.

# Usage: 

    # print a list of command-line options
    amrfinder --help 

    # Download the latest AMRFinderPlus database
    amrfinder -u
    
    # Protein AMRFinderPlus
    amrfinder -p <protein.fa> 

    # Translated nucleotide AMRFinderPlus
    amrfinder -n <assembly.fa>

    # protein AMRFinderPlus using GFF to get genomic coordinates
    amrfinder -p <protein.fa> -g <protein.gff> 

    # search for AMR genes and Campylobacter protein mutations
    amrfinder -p <protein.fa> -O Campylobacter 

    # Search for everything AMRFinderPlus can find:
    # AMR genes, plus genes, protein and nucleotide point mutations, skip blacklisted genes and combine results
    amrfinder -p <protein.fa> -g <protein.gff> -n <assembly.fa> --plus -O Campylobacter 

# Help

Please open a GitHub issue or email us at pd-help@ncbi.nlm.nih.gov if you any questions or concerns.

