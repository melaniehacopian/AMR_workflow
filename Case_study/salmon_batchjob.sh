#!/bin/bash -l

#SBATCH --job-name=salmon_index         ## Name of the job.
#SBATCH  -A <ACCOUNT>
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=24           ## number of cpus
#SBATCH --mem-per-cpu=3G           ## number of cpus
#SBATCH --mail-user= <EMAIL>
#SBATCH --mail-type=ALL
#SBATCH --time=3-00:00:00
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid


module load salmon/1.8.0

# First make a salmon index

salmon index -t /PATH/TO/PRODIGAL/.fa/FILE -i both_index -p 24

# Run salmon quanitfication

READSW=/PATH/TO/WARMED/READS
READSC=/PATH/TO/CONTROL/READS

salmon quant -i both_index -l A -1 $READSC/control_QC_reads/all_control_READ1_paired.fasta -2 $READSC/control_QC_reads/all_control_READ2_paired.fasta -p 24 -o salmon_control

salmon quant -i both_index -l A -1 $READSW/warmed_QC_reads/all_warmed_READ1_paired.fasta -2 $READSW/warmed_QC_reads/all_warmed_READ2_paired.fasta -p 24 -o salmon_warmed

