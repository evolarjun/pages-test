# Installation

AMRFinderPlus requires HMMER, BLAST+, Linux, and perl. We provide a [bioconda](https://bioconda.github.io/) package, x86 Linux binaries, a docker image, and the source code is available to compile AMRFinderPlus yourself. In our experience it compiles well on x86 and ARM MacOS and Linux, but we haven't extensively tested compiling AMRFinderPlus on other systems. We aren't officially supporting non-x86 Linux systems at this time. 

# How to install

## Bioconda

Here are links to instructions for three methods of installation. The simplest, and recommended method is to [install AMRFinderPlus](Install-with-bioconda.md) and all of the prerequisites with bioconda. See [Install with bioconda](Install-with-bioconda.md).

## Docker

A DockerHub image [NCBI/amr](https://hub.docker.com/r/ncbi/amr#!) is provided, and should be downloadable using `docker pull ncbi/amr`. The build instructions for the docker image are [available on GitHub](https://github.com/ncbi/docker/tree/master/amr). See the [docker README](https://github.com/ncbi/docker/blob/master/amr/README.md) for details and some examples of how to use it.

# Other methods

### Prerequisites

Bioconda will install the prerequisites for you, but for other methods you will need to have the prerequisites [BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK279690/), [HMMER](http://hmmer.org/), and [libcurl](https://curl.haxx.se/libcurl/) installed. See [Bioconda prerequisite installation](Bioconda-prerequisite-installation.md) for instructions to install them with bioconda.

## Install from binaries
[How to install with binary distribution](Install-with-binary.md) 
## Compile from source
[How to install by compiling from source](Compile-from-source.md)  

# Test your installation
After installation we recommend you [Test your installation](Test-your-installation.md).



