#!/bin/bash -l

#SBATCH --job-name=prodigal          ## Name of the job.
#SBATCH  -A <ACCOUNT>
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=24           ## number of cpus
#SBATCH --mem-per-cpu=4G           ## number of cpus
#SBATCH --mail-user= <EMAIL>
#SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid


module load prodigal/2.6.3

prodigal -i /PATH/TO/MEGAHIT/CONTIGS -o both_coords.gff -a both_protein.faa -d both_mRNA.fa -p meta -f gff

