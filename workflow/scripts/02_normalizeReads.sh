# bbnorm.sh -Xmx30G \
#   threads=20 \
#   in1=$1 \ #FWD input
#   in2=$2 \ #REV input
#   out1=$3 \ #FWD output
#   out2=$4 \ #REV output
#   target=40 \ #target normalization rate
#   mindepth=0 \ #Kmers with depth below this number will not be included when calculating the depth of a read.
#   hist=$5 \ #kmer depth histogram
#   peaks=$6 \ # peaks and log
#
module load gcc
module load openjdk/17.0.3_7
bbnorm.sh -Xmx900G threads=20 in1=$1 in2=$2 out1=$3 out2=$4 target=40 mindepth=0 hist=$5 peaks=$6

#-Xmx30G threads=20 in1=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/01_trimmed/merged/CM1_R1_merged.fq in2=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/01_trimmed/merged/CM1_R2_merged.fq out1=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/02_hostRemoval/CM1_R1_Normalized.fq out2=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/02_hostRemoval/CM1_R2_Normalized.fq target=40 mindepth=0 hist=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/02_hostRemoval/CM1_Kmer.hist peaks=/work/FAC/FBM/DMF/pengel/spirit/gsartonl/metagenomics/02_hostRemoval/CM1_peaks.txt
