#!/bin/bash -l

#SBATCH --job-name=AMRFinder         ## Name of the job.
#SBATCH  -A <ACCOUNT>
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=24           ## number of cpus
#SBATCH --mem-per-cpu=3G           ## number of cpus
#SBATCH --mail-user= <EMAIL>
#SBATCH --mail-type=ALL
#SBATCH --time=3-00:00:00
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid

conda activate AMR

FPATH=/PATH/TO/PRODIGAL/OUTPUT

amrfinder --plus -p $FPATH/both_protein.faa --threads 24 -o AMR_protein_output.txt --name both -i 0.3 -c 0.5 --protein_output AMR_proteins.faa
