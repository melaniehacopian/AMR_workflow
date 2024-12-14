library(maps)

# Load world map data
world_map <- map_data("world")

# Plot 
ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group),
               fill = "lightgray", color = "white") +
  geom_jitter(data = amr_soil_geography, aes(x = as.numeric(Longitude), y = as.numeric(Latitude), 
                              color = opt_temp_norange, shape = Shape),
             size = 3, width = 4, height = 4) +
  scale_color_viridis_c(option = "viridis", name = "Reported optimal temperature (°C)") +
  scale_shape_manual(values = c(16, 17), guide = "none") +
  labs(title = "",
       x = "Longitude", y = "Latitude") +
  theme_minimal()

