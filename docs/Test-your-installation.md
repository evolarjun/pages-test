Make sure `amrfinder` and the dependencies blast and HMMER are executable and in your path. If you installed via bioconda you may need to run:
```bash
source ~/miniconda3/bin/activate amrfinder
```
Make sure you have the latest AMRFinder database files:
```bash
amrfinder -u
```

The [bioconda installation](Install-with-bioconda.md) doesn't yet include the test files, so if you need to you can use the following commands to download them:

```bash
    BASE_URL=https://raw.githubusercontent.com/ncbi/amr/master
    curl --silent --location -O ${BASE_URL}/test_amrfinder.sh
```

Then to test the version of `amrfinder` that is in your `PATH` (e.g., installed with Bioconda) type

```bash
bash test_amrfinder.sh -p
```

Or if you're in the source or binary directory you downloaded from github and want to test `./amrfinder` use:
```bash
bash test_amrfinder.sh
```

If the tests all pass the output will end with

```
Success!
```

## Troubleshooting

### Make sure the dependencies are executable

The most common issues are that the AMRFinderPlus can't find blast or HMMER binaries. Make sure you can run the following:

```bash
blastp -help
```
If that does not print out a long help message from blastp then AMRFinder may not know where to find your blast executables. If you installed blast via bioconda then running `source ~/miniconda3/bin/activate` may fix this issue.

```bash
hmmsearch -h
```
If that command doesn't print a help message from HMMER then AMRFinder may not know where to find the HMMER executables.  If you installed HMMER via bioconda then running `source ~/miniconda3/bin/activate` may fix this issue.

### Download the latest database

```bash
amrfinder -u
```
### Try updating to the latest version

```bash
conda update -c bioconda -y ncbi-amrfinderplus
```

## Email

If you are still having trouble installing AMRFinderPlus or have any questions let us know by opening an [issue on GitHub](https://github.com/ncbi/amr/issues?q=is%3Aissue) or emailing us at pd-help@ncbi.nlm.nih.gov. 
