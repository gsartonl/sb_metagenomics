#!/bin/bash
# store headers with $4= length and $6=coverage above specified values
scaffolds=$1;
#scaffoldsNorm=$2;
scaffoldsFiltered=$3;
# scaffoldsFilteredNorm=$4;
scaffoldMEGA=$2;
scaffoldFilteredMEGA=$4;
minlen=$5;

echo "----------- HostMapped -----------"
echo "1) Getting contigs headers"
grep '>' ${scaffolds} | sed 's/_/ /g' | awk '{if($4>1000 && $6>1){print $0}}' | sed 's/ /_/g' > $(dirname ${scaffolds})/ScaffoldsToFilter.txt

echo "2) Extracting sequences"
# get the ids in an array - search pattern and if in ids copy until nex pattern
awk 'NR==FNR{ids[$0]; next} />/{f=($0 in ids)} f' $(dirname ${scaffolds})/ScaffoldsToFilter.txt ${scaffolds} \
	> ${scaffoldsFiltered};

echo "### END ###"


# echo "----------- Normalization -----------"
# echo "1) Getting contigs headers"
# grep '>' ${scaffoldsNorm} | sed 's/_/ /g' | awk '{if($4>1000 && $6>1){print $0}}' | sed 's/ /_/g' > $(dirname ${scaffoldsNorm})/ScaffoldsNormToFilter.txt
#
# echo "2) Extracting sequences"
# # get the ids in an array - search pattern and if in ids copy until nex pattern
# awk 'NR==FNR{ids[$0]; next} />/{f=($0 in ids)} f' $(dirname ${scaffoldsNorm})/ScaffoldsNormToFilter.txt ${scaffoldsNorm} \
# 	> ${scaffoldsFilteredNorm};

echo "----------- MEGAHIT -----------"
echo "1) Getting contigs headers"
grep '>' ${scaffoldMEGA} | sed 's/=/ /g' | awk '{if($7>1000 && $5>1){print $0}}' | sed 's/flag /flag=/g' | sed 's/multi /multi=/g' | sed 's/len /len=/g' > $(dirname ${scaffoldMEGA})/ScaffoldsMEGAToFilter.txt

echo "2) Extracting sequences"
	# get the ids in an array - search pattern and if in ids copy until nex pattern
awk 'NR==FNR{ids[$0]; next} />/{f=($0 in ids)} f' $(dirname ${scaffoldMEGA})/ScaffoldsMEGAToFilter.txt ${scaffoldMEGA} \
	> ${scaffoldFilteredMEGA};


echo "### END ###"
### END ###
