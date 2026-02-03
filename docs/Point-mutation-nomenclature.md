Point mutation nomenclature
=============================

Note that the point mutation nomenclature is not totally standard because we have tried to conform to the literature so that point mutations with extensive literature are named in a way that a reader of the literature should recognize. This means that in a few cases coordinates reported may differ from how they are identified in the reference data using the software. 

Point mutation nomenclature for AMRFinderPlus is as follows. The basic format is:

    <gene_symbol>_<reference><position><mutation>

- `<gene_symbol>` - Gene symbol for the reference "wildtype" protein (e.g., parC, 23S)

- `<reference>` - This is the reference sequence that is replaced. Usually it will be a single amino-acid or nucleotide, but for deletions it may be multiple amino-acids.

- `<position>` - The position in the reference of the reference sequence relative to the start of the gene. Promoter mutations will have a negative number e.g., [mtrR_G-131A](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:mtrR_G-131A). Note that these positions are designed to match the literature, and as you might imagine from the above promoter mutation the position won't necessarily be an offset from the start of the reference sequence used by AMRFinderPlus. One non-standard example is the promoter mutations for blaTEM which use an offset from an identified reference start in order to match the [Sutcliff numbering system](https://pubmed.ncbi.nlm.nih.gov/358200/) e.g., [blaTEMp_C141G](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#blaTEMp_C141G).

- `<mutation>` - This varies depending on the type of mutation and is sometimes composed of multiple parts
   - An amino acid or nucleotide sequence as in [gyrA_S83I](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:gyrA_S83I).
   - For a nonsense mutation, the string Ter for a stop codon as in [mgrB_Q30Ter](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:mgrB_Q30Ter) which means the Q at position 30 is now a stop.
   - Frame shifts in protein-coding genes are reported with the format fsTer\<number\> where \<number\> is the number of amino-acids until the stop codon, e.g., [cirA_Y253CfsTer5](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:cirA_Y253CfsTer5) which means there is a stop codon five residues after the frameshift occurring at position 253. Element symbols that end in TerfsTer0 such as ompK35_Y108TerfsTer0 simply mean that at position 108 a frame-shifting indel turned what was previously a Tyrosine into a stop codon (Ter in HGVS parlance).
   - Deletions will have a "del" for the replacement e.g., [pmrB_ALNQLV129del](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:pmrB_ALNQLV129del) which means the amino acid sequence "ALNQLV" that begins at position 129 is missing. 
   - Insertions will have multiple inserted amino acids after the reference e.g., [folP_P64PSFLY](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#allele:folP_P64PSFLY) which means that the P at position 64 is followed by the inserted sequence SFLY.

See the Reference Gene Catalog for a complete [list of curated point mutations](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#subtype:POINT). The new POINT_DISRUPT model will also identify point mutations in genes that are known to influence resistance when their function is disrupted by mutation; those gene symbols may not appear in the [Reference Gene Catalog](https://www.ncbi.nlm.nih.gov/pathogens/isolates/), though the [reference sequences](https://www.ncbi.nlm.nih.gov/pathogens/refgene/#subtype:POINT_DISRUPT) will appear there.
