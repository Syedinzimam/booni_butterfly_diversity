# =============================================================================
# BOONI BUTTERFLY PROJECT
# R Setup and Initial Data Exploration
# Author: Syed Inzimam Ali Shah
# Date: Apr 2020 - Oct 2021
# Location: Booni, Upper Chitral, Pakistan
# =============================================================================

# Set working directory to C drive
setwd("C:/booni_butterfly_diversity")

# 1. INSTALL AND LOAD PACKAGES -----------------------------------------------

# Install packages (run once)
install.packages(c(
  "tidyverse",    # Data manipulation and visualization
  "lubridate",    # Date handling
  "sf",           # Spatial data
  "leaflet",      # Interactive maps
  "plotly",       # Interactive plots
  "DT",           # Interactive tables
  "viridis",      # Color palettes
  "knitr",        # Tables
  "rmarkdown"     # Reports
))

# Load packages
library(tidyverse)
library(lubridate)
library(sf)
library(leaflet)
library(plotly)
library(DT)
library(viridis)

# 2. IMPORT DATA --------------------------------------------------------------

# Read CSV file from data/raw folder
butterflies <- read_csv("data/raw/booni_butterfly_csv.txt")

# View data structure
glimpse(butterflies)
head(butterflies)

# 3. DATA CLEANING & PREPARATION ----------------------------------------------

# Clean and prepare data
butterflies_clean <- butterflies %>%
  mutate(
    # Convert date to proper format
    Date = dmy(Date),
    
    # Extract year and month
    Year = year(Date),
    Month = month(Date, label = TRUE),
    Month_num = month(Date),
    
    # Create season variable
    Season = case_when(
      Month_num %in% c(3, 4, 5) ~ "Spring",
      Month_num %in% c(6, 7, 8) ~ "Summer",
      Month_num %in% c(9, 10, 11) ~ "Autumn",
      TRUE ~ "Winter"
    ),
    
    # Convert coordinates to decimal degrees (already done in CSV)
    # Elevation in meters
    Elevation_m = as.numeric(Elevation_m)
  )

# 4. BASIC SUMMARY STATISTICS -------------------------------------------------

# Overall summary
cat("=== BOONI BUTTERFLY SURVEY SUMMARY ===\n")
cat("Total Observations:", nrow(butterflies_clean), "\n")
cat("Unique Species:", n_distinct(butterflies_clean$ScientificName), "\n")
cat("Survey Period:", min(butterflies_clean$Date), "to", max(butterflies_clean$Date), "\n")
cat("Elevation Range:", min(butterflies_clean$Elevation_m), "-", 
    max(butterflies_clean$Elevation_m), "meters\n\n")

# Species list with observation counts
species_summary <- butterflies_clean %>%
  group_by(Family, ScientificName, EnglishName) %>%
  summarise(
    Observations = n(),
    First_seen = min(Date),
    Last_seen = max(Date),
    Min_elevation = min(Elevation_m),
    Max_elevation = max(Elevation_m),
    .groups = "drop"
  ) %>%
  arrange(Family, ScientificName)

print(species_summary)

# Save species summary table
write_csv(species_summary, "outputs/tables/species_summary.csv")

# Family diversity
family_summary <- butterflies_clean %>%
  group_by(Family) %>%
  summarise(
    Species = n_distinct(ScientificName),
    Observations = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Species))

print(family_summary)

# Save family summary table
write_csv(family_summary, "outputs/tables/family_summary.csv")

# 5. BASIC VISUALIZATIONS -----------------------------------------------------

# A. Family diversity bar plot
p1 <- ggplot(family_summary, aes(x = reorder(Family, Species), y = Species, fill = Family)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Species), hjust = -0.2) +
  coord_flip() +
  scale_fill_viridis_d() +
  labs(
    title = "Butterfly Family Diversity in Booni",
    x = "Family",
    y = "Number of Species"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

print(p1)
ggsave("outputs/figures/01_family_diversity.png", p1, width = 8, height = 6, dpi = 300)

# B. Temporal distribution
temporal <- butterflies_clean %>%
  group_by(Month, Month_num) %>%
  summarise(Observations = n(), .groups = "drop") %>%
  arrange(Month_num)

p2 <- ggplot(temporal, aes(x = Month, y = Observations)) +
  geom_col(fill = "steelblue") +
  geom_text(aes(label = Observations), vjust = -0.5) +
  labs(
    title = "Butterfly Observations by Month",
    subtitle = "Booni, Upper Chitral (2020-2021)",
    x = "Month",
    y = "Number of Observations"
  ) +
  theme_minimal()

print(p2)
ggsave("outputs/figures/02_temporal_distribution.png", p2, width = 8, height = 6, dpi = 300)

# C. Elevation distribution
p3 <- ggplot(butterflies_clean, aes(x = Elevation_m)) +
  geom_histogram(binwidth = 50, fill = "forestgreen", alpha = 0.7) +
  labs(
    title = "Distribution of Observations by Elevation",
    x = "Elevation (meters)",
    y = "Number of Observations"
  ) +
  theme_minimal()

print(p3)
ggsave("outputs/figures/03_elevation_distribution.png", p3, width = 8, height = 6, dpi = 300)

# D. Species accumulation over time
accumulation <- butterflies_clean %>%
  arrange(Date) %>%
  mutate(Cumulative_species = cumsum(!duplicated(ScientificName)))

p4 <- ggplot(accumulation, aes(x = Date, y = Cumulative_species)) +
  geom_line(color = "darkred", size = 1) +
  geom_point(color = "darkred", size = 2) +
  labs(
    title = "Species Accumulation Curve",
    subtitle = "New species discovered over time",
    x = "Date",
    y = "Cumulative Number of Species"
  ) +
  theme_minimal()

print(p4)
ggsave("outputs/figures/04_species_accumulation.png", p4, width = 8, height = 6, dpi = 300)

# 6. SAVE CLEANED DATA --------------------------------------------------------

write_csv(butterflies_clean, "data/cleaned/booni_butterflies_cleaned.csv")
