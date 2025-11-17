# =============================================================================
# BOONI BUTTERFLY PROJECT - SPECIES PHOTO GALLERY
# Author: Syed Inzimam Ali Shah
# Date: June 2025
# =============================================================================

setwd("C:/booni_butterfly_project")

# Load packages
library(tidyverse)
library(knitr)
library(kableExtra)

# Load cleaned data
butterflies <- read_csv("data/cleaned/booni_butterflies_cleaned.csv")

# =============================================================================
# 1. CREATE SPECIES CHECKLIST (ONE RECORD PER SPECIES)
# =============================================================================

# Get unique species with first observation details
species_checklist <- butterflies %>%
  arrange(Date) %>%
  group_by(ScientificName) %>%
  slice(1) %>%
  ungroup() %>%
  select(Family, EnglishName, ScientificName, Date, Elevation_m, Latitude, Longitude) %>%
  arrange(Family, ScientificName) %>%
  mutate(
    Species_ID = row_number(),
    Photo_filename = paste0("species_", sprintf("%02d", Species_ID), ".jpg")
  )

# Add observation counts
obs_counts <- butterflies %>%
  group_by(ScientificName) %>%
  summarise(Total_observations = n(), .groups = "drop")

species_checklist <- species_checklist %>%
  left_join(obs_counts, by = "ScientificName")

# Save species checklist
write_csv(species_checklist, "outputs/tables/species_checklist.csv")

cat("Species checklist created with", nrow(species_checklist), "species\n")

# =============================================================================
# 2. CREATE ANNOTATED SPECIES LIST
# =============================================================================

# Species list by family
species_by_family <- species_checklist %>%
  group_by(Family) %>%
  summarise(
    Species = paste(EnglishName, collapse = ", "),
    Count = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(Count))

# Create formatted table
annotated_list <- species_checklist %>%
  mutate(
    First_observed = format(Date, "%d %b %Y"),
    Elevation = paste0(round(Elevation_m, 0), "m")
  ) %>%
  select(
    `#` = Species_ID,
    Family,
    `English Name` = EnglishName,
    `Scientific Name` = ScientificName,
    `First Observed` = First_observed,
    Elevation,
    `Total Obs.` = Total_observations
  )

# Save as formatted table
write_csv(annotated_list, "outputs/tables/annotated_species_list.csv")

# Print to console
cat("\n=== BOONI BUTTERFLY SPECIES CHECKLIST ===\n\n")
print(kable(annotated_list, format = "simple"))

# =============================================================================
# 3. FAMILY SUMMARY
# =============================================================================

family_breakdown <- species_checklist %>%
  group_by(Family) %>%
  summarise(
    Species_count = n(),
    Percentage = round(100 * n() / nrow(species_checklist), 1),
    .groups = "drop"
  ) %>%
  arrange(desc(Species_count))

cat("\n=== FAMILY DIVERSITY ===\n")
print(kable(family_breakdown, 
            col.names = c("Family", "Species", "%"),
            format = "simple"))

# =============================================================================
# 4. NOTABLE SPECIES HIGHLIGHTS
# =============================================================================

cat("\n=== NOTABLE SPECIES ===\n")

# Highest elevation species
highest <- species_checklist %>% 
  arrange(desc(Elevation_m)) %>% 
  slice(1)
cat("Highest elevation:", highest$EnglishName, "at", round(highest$Elevation_m, 0), "m\n")

# Lowest elevation species
lowest <- species_checklist %>% 
  arrange(Elevation_m) %>% 
  slice(1)
cat("Lowest elevation:", lowest$EnglishName, "at", round(lowest$Elevation_m, 0), "m\n")

# Endemic/regional species
regional_species <- species_checklist %>%
  filter(str_detect(EnglishName, "Chitral|Chitrali"))

cat("\nRegional endemic species:", nrow(regional_species), "\n")
if(nrow(regional_species) > 0) {
  cat("  -", paste(regional_species$EnglishName, collapse = "\n  - "), "\n")
}

# =============================================================================
# 5. PHENOLOGY SUMMARY
# =============================================================================

# First and last observation dates by species
phenology <- butterflies %>%
  group_by(ScientificName, EnglishName) %>%
  summarise(
    First_date = min(Date),
    Last_date = max(Date),
    Active_months = n_distinct(month(Date)),
    .groups = "drop"
  ) %>%
  mutate(
    First_month = format(First_date, "%B"),
    Last_month = format(Last_date, "%B")
  ) %>%
  select(EnglishName, ScientificName, First_month, Last_month, Active_months) %>%
  arrange(First_month)

write_csv(phenology, "outputs/tables/species_phenology.csv")

cat("\n=== PHENOLOGY PATTERNS ===\n")
cat("Early season species (April-May):\n")
early <- phenology %>% filter(First_month %in% c("April", "May"))
cat("  -", paste(early$EnglishName, collapse = "\n  - "), "\n")

cat("\nPeak season species (June-July):\n")
peak <- phenology %>% filter(First_month %in% c("June", "July"))
cat("  -", paste(peak$EnglishName, collapse = "\n  - "), "\n")

# =============================================================================
# 6. PHOTO ORGANIZATION GUIDE
# =============================================================================

cat("\n=== PHOTO ORGANIZATION GUIDE ===\n")
cat("Save your butterfly photos in: photos/\n")
cat("Use this naming scheme:\n\n")

photo_guide <- species_checklist %>%
  select(Species_ID, EnglishName, ScientificName, Photo_filename) %>%
  mutate(
    `Current filename` = "your_photo_name.jpg",
    `Rename to` = Photo_filename
  ) %>%
  select(Species_ID, EnglishName, `Rename to`)

print(kable(photo_guide, format = "simple"))

write_csv(photo_guide, "outputs/tables/photo_naming_guide.csv")

cat("\n=== CHECKLIST COMPLETE ===\n")
cat("Files created:\n")
cat("  - outputs/tables/species_checklist.csv\n")
cat("  - outputs/tables/annotated_species_list.csv\n")
cat("  - outputs/tables/species_phenology.csv\n")
cat("  - outputs/tables/photo_naming_guide.csv\n")

