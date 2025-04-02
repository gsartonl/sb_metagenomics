#!/bin/bash

# Reads trimming for metagenomics with trim-galore!
# author : gsartonl
# data : 15.05.2021
####--------------------------------------${sample}

## Modules and Conda #
#module load gcc/9.3.0
#module load cutadapt/3.4


## Variables ##
FWD=$1;
REV=$2
workdir=$3;
outdir=$4;

tmp_LIBRARY="$(basename $1 .bar)"
LIBRARY=${tmp_LIBRARY/_R*.fastq.gz/}

mkdir -p ${outdir}
echo $1;
echo $2;
trim_galore --cores 7 --phred33 --basename ${LIBRARY} --output_dir ${outdir} --gzip --fastqc_args "--outdir "${outdir}"/fastqc_trimmed/" --length 80 --max_n 1 --quality 20 --paired ${inDir}/${FWD} ${indir}/${REV}
#trimmomatic PE -phred33 -threads $thrd $rawFWD $rawREV $pairedFWD $unpairedFWD $pairedREV $unpairedREV ILLUMINACLIP:/Applications/anaconda3/pkgs/trimmomatic-0.39-1/share/trimmomatic-0.39-1/adapters/AllIllumina-PEadapters.fa:3:25:7 LEADING:9 TRAILING:9 SLIDINGWINDOW:4:15 MINLEN:60;
