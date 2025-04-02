# bbmap.sh -Xmx30G \
#   usejni=t \
#   threads=20 overwrite=t \
#   qin=33 minid=0.95\ #min alignment identity
#   maxindel=3 \ # the lower the faster
#   bwr=0.16 \ # restrict alignment band to this fraction of the read length
#   bw=12 \ #bandwidth
#   quickmatch fast \
#   minhits=2 \ #Minimum number of seed hits required for candidate sites.
#   path=$6 \ #Specify the location to write the index.
#   qtrim=rl \ #quality trim ends befor mapping
#   trimq=15 \ # min average quality to trim reads
#   untrim \ # undo trimming after mapping
#   in1=$1 \ # read input FWD
#   in2=$2 \ # read input REV
#   outu1=$3 \ # unmapped reads
#   outu2=$4 \ # unmapped reads
#   outm=$5  # mapped reads and log
module load gcc
module load openjdk/17.0.3_7
module load bbmap/38.63


bbmap.sh -Xmx30G threads=20 overwrite=t qin=33 minid=0.95 maxindel=3 bwr=0.16 bw=12 quickmatch fast minhits=2 path=$7 ref=$6 qtrim=rl trimq=15 untrim in1=$1 in2=$2 outu1=$3 outu2=$4 outm=$5
