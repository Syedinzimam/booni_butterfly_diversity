# Butterfly Diversity of Booni, Upper Chitral

**A Photographic Documentation and Baseline Survey (2020-2021)**

[![iNaturalist](https://img.shields.io/badge/iNaturalist-Observations-brightgreen)](https://www.inaturalist.org/people/syed_inzimam)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![Old World Swallowtail](photos/species_19.jpg)
*Old World Swallowtail (Papilio machaon) - Booni, Upper Chitral*


##  Project Overview

This repository contains the complete analysis and documentation of butterfly diversity in Booni, Upper Chitral, Pakistan. Through systematic field-based photography conducted between April 2020 and October 2021, **23 butterfly species** across **5 families** were documented, representing the first comprehensive baseline inventory for this region.

The study area spans an elevation gradient of **2,105-2,571 meters** in the Hindu Kush mountain range, covering diverse habitats including agricultural lands, mountain slopes, streams and rivers, meadows, wildlands, and home gardens.

##  Key Findings

- **23 species documented** across 5 families (Lycaenidae, Nymphalidae, Pieridae, Hesperiidae, Papilionidae)
- **37 total observations** with precise GPS coordinates and elevation data
- **466-meter elevation gradient** revealing altitudinal distribution patterns
- **Regional endemic species** including Chitral Inky Skipper, Chitrali Satyr, and Chitral White Admiral
- **Seasonal patterns** showing peak diversity during June-July period

##  Repository Structure

```
booni-butterfly-diversity/
├── data/
│   ├── raw/                    # Original observation data
│   └── cleaned/                # Processed dataset
├── scripts/
│   ├── 01_data_exploration.R   # Initial analysis and visualizations
│   ├── 02_spatial_analysis.R   # Mapping and elevation analysis
│   ├── 03_species_checklist.R  # Species list generation
│   └── 04_photo_gallery.R      # Photo organization
├── outputs/
│   ├── figures/                # All generated plots (PNG)
│   ├── tables/                 # Summary tables (CSV)
│   └── maps/                   # Interactive HTML maps
├── photos/                     # Butterfly photographs (23 species)
├── reports/
│   ├── 05_final_report.Rmd     # R Markdown source
│   └── 05_final_report.html    # Complete report (view in browser)
└── README.md
```

##  Study Area

- **Location:** Booni, Upper Chitral District, Khyber Pakhtunkhwa, Pakistan
- **Coordinates:** 36°15'N, 72°15'E
- **Elevation Range:** 2,105 - 2,571 m.a.s.l.
- **Survey Period:** April 2020 - October 2021
- **Climate Zone:** Montane temperate

##  Methodology

### Data Collection
- Photography-based documentation using Redmi Note 10 Pro
- GPS coordinates recorded for each observation
- Habitat type and elevation documented
- All observations uploaded to [iNaturalist](https://www.inaturalist.org/people/syed_inzimam)

### Species Identification
- Expert verification by **Ackram Awan** (Butterfly Expert, Pakistan)
- iNaturalist community identification
- Regional field guides (Bingham 1905-1907; Wynter-Blyth 1957)

### Data Analysis
- **R (v4.5.1)** for all statistical analyses
- **Spatial analysis:** `sf`, `leaflet` packages
- **Visualizations:** `ggplot2`, `viridis`
- **Report generation:** R Markdown

##  Key Visualizations

### Family Diversity
![Family Diversity](outputs/figures/01_family_diversity.png)

### Temporal Distribution
![Temporal Distribution](outputs/figures/02_temporal_distribution.png)

### Species Accumulation
![Species Accumulation](outputs/figures/04_species_accumulation.png)

##  Notable Species

| Species | Scientific Name | Significance |
|---------|----------------|--------------|
| Chitral Inky Skipper | *Erynnis pathan* | Regional endemic |
| Chitrali Satyr | *Satyrus pimpla* | Named after the region |
| Chitral White Admiral | *Limenitis lepechini* | Conservation interest |
| Loew's Blue | *Plebejidea loewii* | Highest elevation record (2,571m) |
| Old World Swallowtail | *Papilio machaon* | Only swallowtail species |

## 🛠 Technical Details

**Software & Tools:**
- R 4.5.1
- RStudio
- R Packages: `tidyverse`, `sf`, `leaflet`, `lubridate`, `viridis`, `knitr`, `rmarkdown`
- Git & GitHub for version control

**Hardware:**
- Redmi Note 10 Pro (photography)
- GPS-enabled smartphone (georeferencing)

##  Usage

### Clone Repository
```bash
git clone https://github.com/Syedinzimam/booni-butterfly-diversity.git
cd booni-butterfly-diversity
```

### Run Analysis
```r
# Set working directory
setwd("path/to/booni-butterfly-diversity")

# Run scripts in order
source("scripts/01_data_exploration.R")
source("scripts/02_spatial_analysis.R")
source("scripts/03_species_checklist.R")
source("scripts/04_photo_gallery.R")

# Generate report
rmarkdown::render("reports/05_final_report.Rmd")
```

##  Conservation Implications

This baseline dataset provides critical information for:
- Monitoring climate change impacts in the Hindu Kush
- Identifying priority areas for butterfly conservation
- Establishing long-term biodiversity monitoring programs
- Supporting conservation planning in Upper Chitral
- Training local naturalists in biodiversity documentation

##  Related Projects

- [Pakistan Biodiversity Hotspot Analysis](https://github.com/Syedinzimam/pakistan-biodiversity-analysis)
- [Species Distribution Modeling: Himalayan Ibex](https://github.com/Syedinzimam/SDM_Himalayan_Ibex)

##  Citation

If you use this data or methodology in your work, please cite:

```
Shah, S.I.A. (2025). Butterfly Diversity of Booni, Upper Chitral: A Photographic 
Documentation and Baseline Survey. GitHub repository. 
https://github.com/Syedinzimam/booni-butterfly-diversity
```

##  Contributing

Contributions, suggestions, and feedback are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

##  Contact

**Syed Inzimam Ali Shah**
- **Email:** inzimamsyed12@gmail.com
- **GitHub:** [@Syedinzimam](https://github.com/Syedinzimam)
- **LinkedIn:** [Syed Inzimam](https://www.linkedin.com/in/syed-inzimam)
- **iNaturalist:** [@syed_inzimam](https://www.inaturalist.org/people/syed_inzimam)

##  Academic Background

- **BS Zoology** - Virtual University of Pakistan
- **B.Sc. Forestry** - Pakistan Forest Institute

##  License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

##  Acknowledgments

- **Ackram Awan** - Expert identification and verification
- **iNaturalist Community** - Additional identification support

---

**Status:**  Complete | **Last Updated:** June 2025 | **Data Period:** April 2020 - October 2021
