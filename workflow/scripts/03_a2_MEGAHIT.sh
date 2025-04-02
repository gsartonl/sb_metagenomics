#!/bin/bash

FWD=$2;
REV=$3;
outDir=$1;
threads=$4;
LIBRARY=$5;
rm -r ${outDir} # megahit not working if dir already exists
megahit -1 ${FWD} -2 ${REV} -o ${outDir} -t ${threads} --out-prefix ${LIBRARY} --continue

# --out-prefix ${LIBRARY}
