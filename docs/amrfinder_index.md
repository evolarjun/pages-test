`amrfinder_index` will rebuild the BLAST and HMMER databases in a database directory. This functionality is normally provided by `amrfinder -u` and `amrfinder_update`, but is included as a separate program to help with certain unusual scenarios.

### Usage:

    amrfinder_index [--quiet] [--debug] <database_directory>

### Options:

There is a required positional parameter which is the database directory. Note this should be the actual directory containing the database files, not the parent "data" directory (e.g., `data/2023-02-23.1`). 

`--quiet` or `-q` Suppress status messages to STDERR

`--debug` prints the hmmpress and makeblastdb commands to STDOUT prior to running them

### Output:

This will generate the AMR.LIB.h3\*, AMRProt.p??, and AMR\_DNA-\*.n?? files in the database directory that are used by HMMER and BLAST when running AMRFinderPlus.


