## *******************************************************
## Soil analysis   #######################################
## *******************************************************

host_info <- read.csv("Host_info.csv")

soil_genomes <- host_info %>%
  filter(soil_yn == "Soil")

# Create soil AMR dataset

amr_soil_df <- merge(amr_counts_and_metadata, host_info, by="GID", all = TRUE)


winter_palette <- c("#F12A91", "#7CE630", "#F5F500", "#18F1EE",
                "#FF8400", "#A314EB", "#433BB8", "#EC0909")

# Create separate dataset excluding isolates with optimal temperature of 37

amr_soil_df_NO37 <- amr_soil_df_revised %>%
  filter(soil_yn == "Soil") %>%
  filter(! optimal_temperature == 37)


# Plotting 

amr_temp_scat_soil_37_exclusion <- ggplot(amr_soil_df_NO37, aes(x=optimal_temperature, y=norm_AMR_pegs, color = Phylum)) +
  geom_point(size=2, shape=16) + 
  geom_smooth(method=lm, color = "red", linetype = "dashed")+
  ylab("Encoded AMR genes (# per protein-encoding gene)")+
  xlab("Reported optimal temperature (°C)")+
  ggtitle("")+
  scale_color_manual(values=winter_palette)+
  geom_jitter()+
  theme(
    axis.text.x = element_text(size=14), axis.text.y = element_text(size=14),
    axis.title.x = element_text(size = 14),  axis.title.y = element_text(size = 14)) +
  expand_limits(y = c(0, 0.004))+
  theme_classic()

amr_temp_scat_soil <- ggplot(amr_soil_df, aes(x=optimal_temperature, y=norm_AMR_pegs, color = Phylum)) +
  geom_point(size=2, shape=16) + 
  geom_smooth(method=lm, color = "red", linetype = "dashed")+
  ylab("Encoded AMR genes (# per protein-encoding gene)")+
  xlab("Reported optimal temperature (°C)")+
  ggtitle("")+
  geom_jitter()+
  scale_color_manual(values=winter_palette)+
  theme(
    axis.text.x = element_text(size=14), axis.text.y = element_text(size=14),
    axis.title.x = element_text(size = 14),  axis.title.y = element_text(size = 14)) +
  expand_limits(y = c(0, 0.004))+
  theme_classic()




# Mixed Hierarchical linear regressions
# Normalized / non Normalized 
# All isolates / 37 excluded isolates 

random_effect_model <- lmer(norm_AMR_pegs ~ opt_temp_norange + (1 | Phylum/genus), data = amr_soil_df_revised)
summary(random_effect_model)

random_effect_model <- lmer(hits_count ~ opt_temp_norange + (1 | Phylum/genus), data = amr_soil_df_revised)
summary(random_effect_model)

random_effect_model <- lmer(norm_AMR_pegs ~ opt_temp_norange + (1 | Phylum/genus), data = amr_soil_df_NO37)
summary(random_effect_model)

random_effect_model <- lmer(hits_count ~ opt_temp_norange + (1 | Phylum/genus), data = amr_soil_df_NO37)
summary(random_effect_model)
