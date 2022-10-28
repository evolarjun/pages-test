# Project 3 Downloading contigs

A slow step in [Project 3](Project-3) is downloading the contig sequences ([Step 2](Project-2#step-2-filter-for-sequences-less-than-297-amino-acids-in-length)). Below are some alternative ways to speed it up by parallelizing the process.

These all assume that you already have the 293aa_kpc_contigs.out file created in [Step 1](https://github.com/ncbi/workshop-asm-ngs-2022/wiki/Project-3#step-1-get-a-list-of-contigs-with-sequences-of-interest).

## Download the contig sequences in parallel on one VM using GNU `parallel`

[GNU parallel](https://www.gnu.org/software/parallel/) will run multiple processes based on what is passed to it on STDIN. Here we split up the list of URLs we need to download into multiple files and run 12 jobs in parallel (which a few rounds of testing downloads on a subset showed me was a reasonably good value).

First we isolate just the URLs from the `bq` output

```shell
fgrep 'gs://' 293aa_kpc_contigs.out | awk '{print $4}' > kpc_contig_urls
```

Then we split up the file into 12 approximately equal parts to run in parallel using [`split`](https://www.man7.org/linux/man-pages/man1/split.1.html).

```shell
split -nl/12 kpc_contig_urls
```

Then we use `parallel` to run 12 jobs at once using the new files created by `split` as input. We're redirecting the output of `gsutil` because it's not particularly useful here (and there is a lot of it).

```shell
time ls x?? | parallel -j 12 "cat {} | gsutil -m cp -I contigs 2> /dev/null"
```

```
real	2m16.951s
user	15m5.962s
sys	2m10.548s
```

## You can now return to [Project 3 Step 3](https://github.com/ncbi/workshop-asm-ngs-2022/wiki/Project-3#step-3-cut-out-coding-sequences)

