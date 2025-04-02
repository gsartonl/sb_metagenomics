#!/bin/bash

# annotation of metagenomic contigs with prokka #

assembly=$1 # scaffolds
outDir=$2   # annotation directory
LIBRARY=$3  # locustag

prokka \
  --outdir ${outDir} \
  --force \
  --prefix ${LIBRARY} \
  --locustag ${LIBRARY} \
  --compliant \
  --evalue 1e-06 \
  --cpu 16 \
  ${assembly}
