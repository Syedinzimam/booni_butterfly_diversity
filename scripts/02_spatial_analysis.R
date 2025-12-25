# =============================================================================
# BOONI BUTTERFLY PROJECT - SPATIAL ANALYSIS
# Interactive Map and Elevation Analysis
# Author: Syed Inzimam Ali Shah
# Date: Apr 2020 - Oct 2021
# =============================================================================

setwd("C:/booni_butterfly_diversity")

# Load packages
library(tidyverse)
library(leaflet)
library(sf)
library(viridis)
library(htmlwidgets)

# Load cleaned data
butterflies <- read_csv("data/cleaned/booni_butterflies_cleaned.csv")

# =============================================================================
# 1. PREPARE SPATIAL DATA
# =============================================================================

# Convert to spatial object
butterflies_sf <- butterflies %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)

# Create color palette for families
family_colors <- colorFactor(
  palette = viridis(5),
  domain = butterflies$Family
)

# =============================================================================
# 2. CREATE INTERACTIVE MAP
# =============================================================================

# Create popup text for each observation
butterflies <- butterflies %>%
  mutate(
    popup_text = paste0(
      "<b>", EnglishName, "</b><br/>",
      "<i>", ScientificName, "</i><br/>",
      "Family: ", Family, "<br/>",
      "Date: ", format(Date, "%d %b %Y"), "<br/>",
      "Elevation: ", round(Elevation_m, 0), "m"
    )
  )

# Create interactive map
booni_map <- leaflet(butterflies) %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldImagery, group = "Satellite") %>%
  addProviderTiles(providers$OpenStreetMap, group = "Street Map") %>%
  addCircleMarkers(
    lng = ~Longitude,
    lat = ~Latitude,
    radius = 8,
    color = ~family_colors(Family),
    fillOpacity = 0.7,
    stroke = TRUE,
    weight = 2,
    popup = ~popup_text,
    label = ~EnglishName
  ) %>%
  addLegend(
    position = "bottomright",
    pal = family_colors,
    values = ~Family,
    title = "Butterfly Family",
    opacity = 0.8
  ) %>%
  addLayersControl(
    baseGroups = c("Street Map", "Satellite"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  addScaleBar(position = "bottomleft")

# Display map
booni_map

# Save interactive map
saveWidget(booni_map, "outputs/maps/booni_butterfly_map.html", selfcontained = TRUE)
cat("Interactive map saved: outputs/maps/booni_butterfly_map.html\n")

# =============================================================================
# 3. ELEVATION ANALYSIS
# =============================================================================

# Elevation range by species
elevation_by_species <- butterflies %>%
  group_by(ScientificName, EnglishName, Family) %>%
  summarise(
    Min_elevation = min(Elevation_m),
    Max_elevation = max(Elevation_m),
    Mean_elevation = mean(Elevation_m),
    Elevation_range = Max_elevation - Min_elevation,
    Observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Mean_elevation))

# Save elevation analysis
write_csv(elevation_by_species, "outputs/tables/elevation_by_species.csv")

# Plot: Elevation ranges by species
p_elevation <- ggplot(elevation_by_species, aes(y = reorder(EnglishName, Mean_elevation))) +
  geom_segment(aes(x = Min_elevation, xend = Max_elevation, yend = EnglishName), 
               size = 1.5, color = "steelblue") +
  geom_point(aes(x = Mean_elevation), size = 3, color = "darkred") +
  labs(
    title = "Elevation Ranges of Butterfly Species",
    subtitle = "Lines show min-max range; dots show mean elevation",
    x = "Elevation (meters)",
    y = NULL
  ) +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 9))

print(p_elevation)
ggsave("outputs/figures/05_elevation_ranges.png", p_elevation, width = 10, height = 8, dpi = 300)

# Elevation vs Family
p_elevation_family <- ggplot(butterflies, aes(x = Family, y = Elevation_m, fill = Family)) +
  geom_boxplot(alpha = 0.7) +
  geom_jitter(width = 0.2, alpha = 0.5, size = 2) +
  scale_fill_viridis_d() +
  labs(
    title = "Elevation Distribution by Family",
    x = "Family",
    y = "Elevation (meters)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

print(p_elevation_family)
ggsave("outputs/figures/06_elevation_by_family.png", p_elevation_family, width = 8, height = 6, dpi = 300)

# =============================================================================
# 4. SPATIAL PATTERNS
# =============================================================================

# Calculate convex hull (area covered)
study_area <- butterflies_sf %>%
  st_union() %>%
  st_convex_hull()

area_km2 <- st_area(study_area) / 1000000  # Convert to km²

cat("\n=== SPATIAL SUMMARY ===\n")
cat("Study area (convex hull):", round(as.numeric(area_km2), 2), "km²\n")
cat("Number of observation points:", nrow(butterflies), "\n")
cat("Elevation gradient:", max(butterflies$Elevation_m) - min(butterflies$Elevation_m), "meters\n")

# Observation density by location
location_summary <- butterflies %>%
  mutate(
    Location_key = paste(round(Latitude, 4), round(Longitude, 4), sep = "_")
  ) %>%
  group_by(Location_key, Latitude, Longitude) %>%
  summarise(
    Species_count = n_distinct(ScientificName),
    Observation_count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Species_count))

cat("\nTop observation hotspots:\n")
print(head(location_summary, 5))

# Save location summary
write_csv(location_summary, "outputs/tables/observation_hotspots.csv")

# =============================================================================
# 5. SEASONAL-ELEVATION PATTERNS
# =============================================================================

# Seasonal elevation patterns
seasonal_elevation <- butterflies %>%
  group_by(Month, Season) %>%
  summarise(
    Mean_elevation = mean(Elevation_m),
    SD_elevation = sd(Elevation_m),
    Observations = n(),
    .groups = "drop"
  )

p_seasonal_elevation <- ggplot(seasonal_elevation, aes(x = Month, y = Mean_elevation, group = 1)) +
  geom_line(color = "darkblue", size = 1.2) +
  geom_point(aes(size = Observations), color = "darkred", alpha = 0.7) +
  geom_errorbar(aes(ymin = Mean_elevation - SD_elevation, 
                    ymax = Mean_elevation + SD_elevation), 
                width = 0.2, alpha = 0.5) +
  labs(
    title = "Seasonal Variation in Observation Elevation",
    subtitle = "Error bars show standard deviation",
    x = "Month",
    y = "Mean Elevation (meters)",
    size = "Observations"
  ) +
  theme_minimal()

print(p_seasonal_elevation)
ggsave("outputs/figures/07_seasonal_elevation.png", p_seasonal_elevation, width = 10, height = 6, dpi = 300)
