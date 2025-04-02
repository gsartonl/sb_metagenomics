#!/bin/bash



## usage ##
# see https://github.com/sanger-pathogens/assembly-stats
# -l : min sequence length


assembly-stats -l 500 -t $1 $2 $3 $4 $5 > ${6} ;
#
