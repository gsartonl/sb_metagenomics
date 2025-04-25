#!/usr/bin/env python3

##
# Filtering scaffolds after assembly.
# Scaffolds with a length below 1000bp and a kmer coverage of 1 are removed from the scaffold file
#
##

import os
import sys
import argparse

import gzip
from Bio import SeqIO
from functions import check_file_exists

parser = argparse.ArgumentParser(prog="filter metaspades scaffolds")
parser.add_argument('-l','--length', action='store', default=1000, type=int)
parser.add_argument('-c', '--coverage', action='store', default=1, type=int)
parser.add_argument('-i', '--infile', action='store', required=True)
parser.add_argument('-o', '--outfile', action='store', required=True)

args=vars(parser.parse_args())
print(args)
check_file_exists(args['infile'])

def check_scaffold_metrics(scaffold_header, threshold_length, threshold_cov) :
    number = scaffold_header.split('_')[1]
    length = int(scaffold_header.split('_')[3])
    cov = float(scaffold_header.split('_')[5])
    if length >= threshold_length and cov >= threshold_cov :
        print(f"Scafflod n°{number}: PASS thresholds")
        return(True)
    else :
        if length < threshold_length and cov >= threshold_cov:
            print(f"Scafflod n°{number} has length below threshold: {length}")
        elif length >= threshold_length and cov < threshold_cov :
            print(f"Scafflod n°{number} has coverage below threshold: {cov}")
        else:
            print(f"Scafflod n°{number} has length and coverage below threshold: L={length} ; C={cov}")
        return(False)

def filter_scaffold(input_file, output_file, threshold_length, threshold_cov):
    """
    Filters scaffolds in FASTA file
    """
    # handle gz files (in case it's needed, shouldn't be with spades defaults)
    opener = gzip.open if input_file.endswith('gzip') else open
    with opener(input_file, 'rt') as handle, open(output_file, 'w') as out_f:
        filtered_records = (
            record for record in SeqIO.parse(handle, 'fasta')
            if check_scaffold_metrics(record.description, threshold_length, threshold_cov)
        )
        SeqIO.write(filtered_records, out_f, 'fasta')

## MAIN ##
filter_scaffold(input_file=args['infile'],
                output_file=args['outfile'],
                threshold_length=args['length'],
                threshold_cov=args['coverage'])