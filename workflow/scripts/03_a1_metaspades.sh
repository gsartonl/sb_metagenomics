#!/bin/bash

### Analysis ###
outDir=$1;

FWD=$2;
REV=$3;
mem_mb=$(bc <<< $4/1000)


if [ ! -d "$outDir" ];
  then
    echo "New assembly"
	   mkdir -p ${outDir};
     spades.py --meta -o ${outDir} -1 ${FWD} -2 ${REV} -t 30 -m $4 --only-assembler;
else
  echo "Continue assembly
  "
   spades.py --meta -o ${outDir} -1 ${FWD} -2 ${REV} -t 30 -m $4 --only-assembler #--continue ;

fi


#END
