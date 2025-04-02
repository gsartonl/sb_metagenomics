#!/bin/bash

mkdir gene_catalog
cat metag_assembly/metag*/metag*fna > gene_catalog/gene_catalog_all.fna
cat metag_assembly/metag*/metag*faa > gene_catalog/gene_catalog_all.faa
cd gene_catalog
mkdir cdhit9590
cd-hit-est -i gene_catalog_all.fna -o cdhit9590/gene_catalog_cdhit9590.fasta \
-c 0.95 -T 64 -M 0 -G 0 -aS 0.9 -g 1 -r 1 -d 0
