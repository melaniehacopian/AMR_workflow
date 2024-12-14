#!/bin/bash



#getting the initital list of genomes etc from the BVBRC db
# Run each line separately (only needs to be done once)
#wget ftp://anonymous:password@ftp.bvbrc/genomes/RELEASE_NOTES/genome_lineage
#wget ftp://anonymous:password@ftp.bvbrc/genomes/RELEASE_NOTES/genome_metadata


cat genome_metadata | cut -f 1,2,4,5,23,24,26,27,28,29,30,31,32,35,40,41,42,53,54,59,60 | awk 'BEGIN { FS = OFS = "\t" } { for(i=1; i<=NF; i++)  if($i ~ /^ *$/) $i = "NA"}; 1' | grep -v "NA$" | sed 's/C$/\n/g' | grep -v "^$" | awk 'BEGIN { FS = OFS = "\t" } { for(i=1; i<=NF; i++)  if($i ~ /^ *$/) $i = "NA"}; 1' |grep -v "NA$" | grep -v "\-$" >db1.txt      #### List of genomes with consistent annotation and metadata (e.g., sequencing platform, depth, # of chromo, # plasmids, genome length, # of prot, origin, known AMR, temp range, opt temp)

echo -e GID"\t"Protein identifier"\t"Gene symbol"\t"Sequence name"\t"Scope"\t"Element type"\t"Element subtype"\t"Class"\t"Subclass"\t"Method"\t"Target length"\t"Reference sequence length"\t"% Coverage of reference sequence"\t"% Identity to reference sequence"\t"Alignment length"\t"Accession of closest sequence"\t"Name of closest sequence"\t"HMM t"\id"HMM description >Result.txt

echo GID >AnGeno.txt #### import file listing the analyzed genomes - including those with no hits.

head -n 1  < genome_lineage | cut -f 1-10 > Tax.txt

###################
###################
#LOOPING through the genomes and running amrfinder
IFS=$'\n'
while read line 
do
echo "###################################"
echo $line
Gid=$(echo $line | cut -f 1 )
echo $Gid

Gid2=$(echo $line | cut -f 2 )

#retrieve FAA file
wget -q --tries=3 --connect-timeout=30 ftp://anonymous:password@ftp.bvbrc.org/genomes/$Gid/$Gid.PATRIC.faa

grep -v "^$"  $Gid.PATRIC.faa | sed 's/\ \ */_/g' | tr '\n' '\t' | sed 's/>/\n&/g' | grep -v "^$" | awk  'NF > 1'  | grep -v "^$" | cut -c 2-  | nl | sed 's/^\ \ */>/g' | sed 's/\t/|/1' | tr '\t' '\n' >temp0.txt

source ~/miniconda3/bin/activate
conda activate amrfinder  

amrfinder --plus -p temp0.txt >temp1.txt

tail -n +2 < temp1.txt | cut -d "|" -f 2- | sed "s/^/$Gid\t/g" >>Result.txt #ID of the ABR traits in selected genomes

grep $Gid2 genome_lineage | cut -f 1-10 >> Tax.txt
echo $Gid >>AnGeno.txt

rm $Gid.PATRIC.faa

done < db1.txt
