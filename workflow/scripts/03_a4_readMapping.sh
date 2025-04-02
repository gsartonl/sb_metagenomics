#!/bin/bash

# mapping reads to the assembly #
# $1 = scaffolds
# $2 = FWD
# $3 = REV

# $4 = threads

# $5 = sam
# $6 = sorted.bam
# $7 = final tsv

bwa index $1
bwa mem -t $4 $1 $2 $3 > $5
samtools view -bh $5 | samtools sort - > $6
rm $1.amb
rm $1.ann
rm $1.bwt
rm $1.pac
rm $1.sa
samtools flagstat -O tsv $6 > $7
