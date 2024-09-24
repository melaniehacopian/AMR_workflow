# Trimming and fastqc of 1 sample

#separate files into r1 and r2
# example for control plot 1

paste - - - - < C1_1.raw \
| tee >(awk 'BEGIN{FS="\t"; OFS="\n"} {if (match($1, " 1:N")) print $1,$2,$3,$4}' > file.r1.fq ) \
| awk 'BEGIN{FS="\t"; OFS="\n"} {if (match($1, " 2:N")) print $1,$2,$3,$4}' > file.r2.fq

#trim samples to remove adapters and delete low-quality sequences

module load trimmomatic/0.39

java -jar /opt/apps/trimmomatic/0.39/trimmomatic-0.39.jar PE file.r1.fq file.r2.fq file_trimmed.r1_paired.fq file_trimmed.r1_unpaired.fq file_trimmed.r2_paired.fq file_trimmed.r2_unpaired.fq ILLUMINACLIP:/opt/apps/trimmomatic/0.39/adapters/TruSeq3-PE.fa:2:30:10 LEADING:5 TRAILING:5 SLIDINGWINDOW:4:15 MINLEN:25



#fastQC of trimmed samples
#make sure adapters were removed

module load fastqc/0.11.9
fastqc file_trimmed.r1_paired.fq
fastqc file_trimmed.r2_paired.fq


