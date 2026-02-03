* [[Install with bioconda]]
* [[Install with binary]]

# Manual installation summary

If you want to compile AMRFinderPlus yourself you'll need a C compiler such as [gcc](https://gcc.gnu.org/) and [GNU make](https://www.gnu.org/software/make/) to compile the software as well as the other prerequisites [BLAST+](https://www.ncbi.nlm.nih.gov/books/NBK279690/), [HMMER](http://hmmer.org/), and [libcurl](https://curl.haxx.se/libcurl/). We officially support only compiling AMRFinderPlus with GNU tools on Linux on x86. However we have had success compiling on Linux and MacOS on both x86 and ARM architectures. Your mileage may vary, but let us know if you are having problems.

AMRFinderPlus was developed with g++ (GCC) 7.3.0 and libcurl 7.61.1

To install binaries see [[Installing AMRFinder]].

# Downloading

You can clone the repository using 
```bash
git clone https://github.com/ncbi/amr.git
cd amr
git checkout master
git submodule update --init
```

# Compiling

```bash
make 
```

To adjust the default database directory use something like the following (we are working on a more flexible way to define directories, but this solves the problem in the short term):

```bash
make clean
make DEFAULT_DB_DIR=/usr/local/share/amrfinder/data
```

You may also have to adjust flags in the Makefile for libcurl and for different versions of GCC or other compilers.

# Installation

```bash
make install
```
will copy the AMRFinderPlus executables to `/usr/local/share/amrfinder`. To change the installation location add a INSTALL_DIR option to make e.g.:

```bash
make install INSTALL_DIR=$HOME/amrfinder
```

# Get an AMRFinderPlus database

Remember you will need to get an AMRFinderPlus database in order to run AMRFinderPlus.

You can do that by running `amrfinder -U`

# Test your installation

See [[Test your installation]] for information on how to run tests.
