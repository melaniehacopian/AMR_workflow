#!/bin/bash -l

#SBATCH --job-name=sortme2    ## Name of the job.
#SBATCH  -A <ACCOUNT>
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=48          ## number of cpus
#SBATCH --mail-user= <EMAIL>
#SBATCH --mail-type=ALL
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid
#SBATCH --mem-per-cpu=6G           ## number of cpus

conda activate AMR

# For warmed plot ID 5
FPATH=/path/to/Raw_Data

DPATH=/path/to/databases

/pub/hacopiam/miniconda3/envs/AMR/bin/sortmerna --workdir . --ref $DPATH/silva-arc-16s-id95.fasta --ref $DPATH/rfam-5.8s-database-id98.fasta --ref $DPATH/rfam-5s-database-id98.fasta --ref $DPATH/silva-arc-23s-id98.fasta --ref $DPATH/silva-bac-16s-id90.fasta --ref $DPATH/silva-bac-23s-id98.fasta --ref $DPATH/silva-euk-18s-id95.fasta --ref $DPATH/silva-euk-28s-id98.fasta --reads $FPATH/file_trimmed.r1_paired.fq --reads $FPATH/file_trimmed.r2_paired.fq --fastx  --aligned rRNA --other mRNA --out2 --sout --threads 48
