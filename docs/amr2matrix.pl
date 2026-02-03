#!/usr/bin/env perl

# Note that this was mostly vibe coded and that it is released under
# the same public domain license as AMRFinderPlus
# See https://github.com/ncbi/amr/blob/master/LICENSE

use strict;
use warnings;
my $usage_msg = <<END;
Usage: perl $0 <file1.tsv> <file2.tsv> ... [ > <table.tsv> ]

Combine AMRFinderPlus output and convert it to a simple presence / absence table.

Note that duplicates are removed and many details of the output are eliminated;
see the original AMRFinderPlus output for details of each hit. This is an example
script and may not do what you want in all cases. Please use caution.

REQUIREMENTS:
1. AMRFinderPlus must have been run with the --name option.
2. Input files must contain "Name", "Element symbol", and "Method" columns.

Ex:
  amrfinder -n assembly1.fa --name assembly1 > assembly1.amrfinder
  amrfinder -n assembly2.fa --name assembly2 > assembly2.amrfinder
  perl amr2matrix.pl *.amrfinder > matrix.tsv

END

# Check arguments
if (@ARGV == 0) {
    die $usage_msg;
}

my %method_map = (
    # Group: COMPLETE
    'ALLELEP'        => 'COMPLETE',
    'ALLELEX'        => 'COMPLETE',
    'BLASTP'         => 'COMPLETE',
    'BLASTX'         => 'COMPLETE',
    'EXACTP'         => 'COMPLETE',
    'EXACTX'         => 'COMPLETE',
    'COMPLETE_NOVEL' => 'COMPLETE',
    'EXTENDED'       => 'COMPLETE',
    'AMBIGUOUS'      => 'COMPLETE',
    'COMPLETE'       => 'COMPLETE',

    # Group: HMM
    'HMM'            => 'HMM',

    # Group: MISTRANSLATION
    'INTERNAL_STOP'  => 'MISTRANSLATION',
    'FRAMESHIFT'     => 'MISTRANSLATION',

    # Group: PARTIAL
    'PARTIALP'       => 'PARTIAL',
    'PARTIALX'       => 'PARTIAL',
    'PARTIAL'        => 'PARTIAL',

    # Group: PARTIAL_END_OF_CONTIG
    'PARTIAL_CONTIG_ENDP' => 'PARTIAL_END_OF_CONTIG',
    'PARTIAL_CONTIG_ENDX' => 'PARTIAL_END_OF_CONTIG',
    'PARTIAL_CONTIG_END'  => 'PARTIAL_END_OF_CONTIG',

    # Group: POINT
    'POINTN'         => 'POINT',
    'POINTP'         => 'POINT',
    'POINTX'         => 'POINT',
);

# Data structures
my %matrix;
my %all_symbols;

# Process each file provided in command line arguments
foreach my $file (@ARGV) {
    open(my $fh, '<', $file) or die "Error: Could not open file '$file': $!\n";

    # Read the header line
    my $header_line = <$fh>;
    unless ($header_line) {
        warn "Warning: File '$file' appears to be empty. Skipping.\n";
        next;
    }
    chomp $header_line;
    
    # Identify column indices
    my @headers = split(/\t/, $header_line);
    my $symbol_col_idx = -1;
    my $method_col_idx = -1;
    my $name_col_idx   = -1;

    for my $i (0 .. $#headers) {
        if ($headers[$i] =~ /^Element symbol/i) {
            $symbol_col_idx = $i;
        }
        elsif ($headers[$i] =~ /^Method/i) {
            $method_col_idx = $i;
        }
        elsif ($headers[$i] =~ /^Name/i) {
            $name_col_idx = $i;
        }
    }

    # ERROR CHECK: If Name column is missing, fail with Usage message
    if ($name_col_idx == -1) {
        warn "\nERROR: File '$file' is missing the 'Name' column.\n";
        warn "Please ensure you ran AMRFinderPlus with the --name option.\n\n";
        die $usage_msg;
    }

    # ERROR CHECK: If other required columns are missing
    if ($symbol_col_idx == -1 || $method_col_idx == -1) {
        warn "\nERROR: File '$file' is missing required columns ('Element symbol' or 'Method').\n\n";
        die $usage_msg;
    }

    # Process the data lines
    while (my $line = <$fh>) {
        chomp $line;
        next if $line =~ /^\s*$/; # Skip empty lines

        my @columns = split(/\t/, $line);

        # Extract Name, Symbol and Method using dynamic indices
        my $name       = defined $columns[$name_col_idx]   ? $columns[$name_col_idx]   : undef;
        my $symbol     = defined $columns[$symbol_col_idx] ? $columns[$symbol_col_idx] : undef;
        my $raw_method = defined $columns[$method_col_idx] ? $columns[$method_col_idx] : undef;

        if (defined $name && defined $symbol && $name ne '' && $symbol ne '') {
            
            # Determine the Category
            my $category;
            if (defined $raw_method && exists $method_map{$raw_method}) {
                $category = $method_map{$raw_method};
            } elsif (defined $raw_method) {
                $category = $raw_method; 
            } else {
                $category = "UNKNOWN";
            }

            # Store in matrix
            $matrix{$name}->{$symbol} = $category;
            $all_symbols{$symbol} = 1;
        }
    }
    close $fh;
}

# PREPARE OUTPUT

# Sort element symbols alphabetically
my @sorted_symbols = sort keys %all_symbols;

# Print the Header Row
print join("\t", "Name", @sorted_symbols) . "\n";

# Print the Data Rows
foreach my $name (sort keys %matrix) {
    print $name;
    
    foreach my $symbol (@sorted_symbols) {
        print "\t";
        if (exists $matrix{$name}->{$symbol}) {
            print $matrix{$name}->{$symbol};
        }
    }
    print "\n";
}
