#!/bin/bash -l

#SBATCH --job-name=megahit          ## Name of the job.
#SBATCH  -A <ACCOUNT>
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=36           ## number of cpus
#SBATCH --mem-per-cpu=6G           ## number of cpus
#SBATCH --mail-user= <EMAIL>
#SBATCH --mail-type=ALL
#SBATCH --time=10-00:00:00
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid

conda activate AMR

FPATH=/path/to/sequences

megahit --num-cpu-threads 36 --presets meta-large -1 $FPATH/C1_3_run/mRNA_paired_fwd_C1_3.fq,$FPATH/C3_2_run/mRNA_paired_fwd_C3_2.fq,$FPATH/C4_5_run/mRNA_paired_fwd_C4_5.fq,$FPATH/C5_5_run/mRNA_paired_fwd_C5_5.fq,$FPATH/W1_3_run/mRNA_paired_fwd_W1_3.fq,$FPATH/W3_2_run/mRNA_paired_fwd_W3_2.fq,$FPATH/W4_3_run/mRNA_paired_fwd_W4_3.fq,$FPATH/W5_5_run/mRNA_paired_fwd_W5_5.fq -2 $FPATH/C1_3_run/mRNA_paired_rev_C1_3.fq,$FPATH/C3_2_run/mRNA_paired_rev_C3_2.fq,$FPATH/C4_5_run/mRNA_paired_rev_C4_5.fq,$FPATH/C5_5_run/mRNA_paired_rev_C5_5.fq,$FPATH/W1_3_run/mRNA_paired_rev_W1_3.fq,$FPATH/W3_2_run/mRNA_paired_rev_W3_2.fq,$FPATH/W4_3_run/mRNA_paired_rev_W4_3.fq,$FPATH/W5_5_run/mRNA_paired_rev_W5_5.fq -o megahit_out
