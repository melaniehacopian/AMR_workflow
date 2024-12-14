## *******************************************************
## BV-BRC AMR analysis   #################################
## *******************************************************

setwd("/PATH/TO/WORKING/DIRECTORY")

# Read in results 

genome_metadata <- read.csv("Metadata_db1.csv")
amr_results <- read.csv("Result_1.csv")


## Filter AMRfinder output for only AMR hits 

amr_results <- amr_results %>%
  filter (Element_type == "AMR")


## Calculate total number of AMR hits per each GID 

amr_hits_count <- amr_results %>%
  group_by(GID) %>%
  dplyr::summarise(hits_count = n())


## Merge genome metadata, amr hits, and genome_ids: 

amr_counts_and_metadata <- merge(genome_metadata, amr_hits_count, by="GID", all = TRUE)

## Merge genome_metadata and amr hits 
## will include genomes with 0 amr hits. 
## However, they need to be changed from NA to 0 

amr_counts_and_metadata[is.na(amr_counts_and_metadata)] <- 0

## Create columns for AMR hits normalized based on PEG and # nucleotides

amr_counts_and_metadata$norm_AMR_pegs<- amr_counts_and_metadata$hits_count / amr_counts_and_metadata$patric_cds
amr_counts_and_metadata$norm_AMR_nts<- amr_counts_and_metadata$hits_count / amr_counts_and_metadata$genome_length


