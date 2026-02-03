Database Updates
=================

This should be as easy as running:
    
    amrfinder --update

Some users have reported errors with the automatic updating. You can automatically update to a directory different from the default by using [[amrfinder_update]]. Ex:

    amrfinder_update -d <database_directory>

To use that directory when you run `amrfinder` use the `-d` option: 

    amrfinder -d <database_directory>/latest  ...

Note that if you're running under sudo your path might change (e.g., https://github.com/ncbi/amr/issues/74). The following should work:

    sudo PATH="$PATH" amrfinder --force_update

Software Upgrades
=================

Instructions for upgrading AMRFinderPlus depend on how it was installed in the first place. A summary and new features for each release can be seen in the [list of releases](https://github.com/ncbi/amr/releases).

Bioconda installations
----------------------

For Bioconda installations:

If necessary

    source ~/miniconda3/bin/activate

Then

    conda update -c conda-forge -c bioconda ncbi-amrfinderplus

Sometimes conda refuses to `update` because it doesn't want to update dependencies. Force a specific version where `<version>` is replaced with the latest version:

    conda install -c conda-forge -c bioconda ncbi-amrfinderplus=<version>

E.g.:
    
    conda install -c conda-forge -c bioconda ncbi-amrfinderplus=4.2.5



Binary installations
--------------------

Basically just re-install, though you shouldn't have to install any prerequisites since presumably they're already installed so you just need to follow [[the instructions to download and untar the binary|Install-with-binary#installing-amrfinderplus-itself]]

Source installation
-------------------

You should update your sources to the latest release version of the software (e.g., `git pull`)
or download the latest sources from the [latest release](https://github.com/ncbi/amr/releases/latest). For example:
    
    git pull
    git submodule update
    make clean
    make

See [[Compile from source]] for more details.

