## *******************************************************
## Case study analysis  ##################################
## *******************************************************

setwd("/WORKING/DIRECTORY")

# Load packages
library(tidyverse)
library(DESeq2)

my_sampleInfo = read.table("salmon_names.txt", header=TRUE)

my_sampleInfo <- my_sampleInfo %>%
  mutate_if(is.character, as.factor)

my_sampleInfo$Sample_name = as.character(my_sampleInfo$Sample_name)

my_countdata = read.table("all_quants.txt", header=TRUE, row.names=1, check.names=FALSE)

my_countdata <- round(my_countdata)

dds = DESeqDataSetFromMatrix(countData=my_countdata, colData=my_sampleInfo, design=~Treatment)
dds <- DESeq(dds)
dds_2 <- DESeq(dds, minReplicatesForReplace=Inf)

res <- results( dds )
res_df <- as.data.frame(res)


# AMR proteins
AMR_protein_hits = read.table("AMR_protein_output.txt", header=TRUE, fill=TRUE, sep = '\t')
AMR_genes <- AMR_protein_hits %>%
  filter(Element_type=="AMR")


heat_genes <- AMR_protein_hits %>%
  filter(Element_subtype=="HEAT")


# Add gene type column
res_df <- res_df %>%
  mutate(Type = case_when(log2FoldChange >= 2 & padj <= 0.05 ~ "upregulated",
                          log2FoldChange <= 0.5 & padj <= 0.05 ~ "downregulated",
                               TRUE ~ "not significant"))

# Add colour, size and alpha (transparency) to volcano plot 
cols <- c("upregulated" = "#98c379", "downregulated" = "#26b3ff", "not significant" = "grey") 
cols <- c("upregulated" = "white", "downregulated" = "white", "not significant" = "white") 
sizes <- c("upregulated" = 2, "downregulated" = 2, "not significant" = 1) 
alphas <- c("upregulated" = 0.5, "downregulated" = 0.5, "not significant" = 0.5)

# AMR plot
vol_plot_amr <- ggplot(res_df, aes(x = (log2FoldChange),
             y = -log10(padj), alpha=Type, fill=Type)) + 
  geom_point(shape = 21, color="black") +
  geom_point(data = sig_amr, # New layer containing sig amr transcripts   
             size = 2,
             shape = 21,
             alpha=1,
             fill = "firebrick",
             colour = "black") +
  geom_hline(yintercept = -log10(0.05),
             linetype = "dashed") +
  geom_vline(xintercept = c(log2(0.5), log2(2)),
             linetype = "dashed") +
  scale_fill_manual(values = cols) +
  scale_alpha_manual(values=alphas)+
  ggtitle("")+
  ylab("-Log10 adjusted p-value")+	
  xlab("Log2 fold change")+
  xlim(-35, 35) +
  annotate('rect', xmin=-35, xmax=35, ymax=-log10(0.05), ymin=0, alpha=.2, fill='grey')+
  annotate('rect', xmin=-35, xmax=-log2(2), ymin=14, ymax=-log10(0.05), alpha=.2, fill="#26b3ff")+
  annotate('rect', xmin=log2(2), xmax=35, ymin=14, ymax=-log10(0.05), alpha=.2, fill='#98c379')+
  annotate('rect', xmin=-log2(2), xmax=log2(2), ymin=14, ymax=-log10(0.05), alpha=.2, fill='grey')+
  theme_classic()+
  theme(legend.position = "none")

# HEAT plot
vol_plot_heat <- ggplot(res_un_df, aes(x = (log2FoldChange),
                                      y = -log10(padj), alpha=Type, fill=Type)) + 
  geom_point(shape = 21, color="black") +
  geom_point(data = sig_heat, # New layer containing sig amr transcripts   
             size = 2,
             shape = 21,
             alpha=1,
             fill = "black",
             colour = "black") +
  geom_hline(yintercept = -log10(0.05),
             linetype = "dashed") +
  geom_vline(xintercept = c(log2(0.5), log2(2)),
             linetype = "dashed") +
  scale_fill_manual(values = cols) +
  scale_alpha_manual(values=alphas)+
  ggtitle("")+
  ylab("-Log10 adjusted p-value")+	
  xlab("Log2 fold change")+
  xlim(-35, 35) +
  annotate('rect', xmin=-35, xmax=35, ymax=-log10(0.05), ymin=0, alpha=.2, fill='grey')+
  annotate('rect', xmin=-35, xmax=-log2(2), ymin=14, ymax=-log10(0.05), alpha=.2, fill="#26b3ff")+
  annotate('rect', xmin=log2(2), xmax=35, ymin=14, ymax=-log10(0.05), alpha=.2, fill='#98c379')+
  annotate('rect', xmin=-log2(2), xmax=log2(2), ymin=14, ymax=-log10(0.05), alpha=.2, fill='grey')+
  theme_classic()+
  theme(legend.position = "none")


## *******************************************************
## Cohen's D by Drug Class  ##############################
## *******************************************************

head(summed_tpm_drug_class) 

format_for_cohen <- summed_tpm_drug_class %>%
  pivot_wider(
    id_cols = Class,           
    names_from = plot_id,                     
    values_from = summed_tpm,                                 
  )

# Calculate Mean and Standard Deviation
# Compute the mean and standard deviation for each drug class in warmed and control groups
mean_warmer <- apply(format_for_cohen[, 6:9], 1, mean)  
mean_control <- apply(format_for_cohen[, 2:5], 1, mean)  
sd_warmer <- apply(format_for_cohen[, 6:9], 1, sd)    
sd_control <- apply(format_for_cohen[, 2:5], 1, sd)      

# Calculate Cohen's D
cohen_d <- (mean_warmer - mean_control) / sqrt((sd_warmer^2 + sd_control^2) / 2)

cohens_d_df <- data.frame(Class = rownames(format_for_cohen), Cohen_D = cohen_d)

