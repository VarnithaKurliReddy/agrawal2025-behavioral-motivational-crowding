# Behavioral and Motivational Crowding Undermine Sustainable Development

**Replication code for:** Agrawal, A., Chhatre, A., Gerber, E.R., Kurli, V. "Behavioral and Motivational Crowding Undermine Sustainable Development" 

**Authors:** Arun Agrawal¹, Ashwini Chhatre², Elisabeth R. Gerber³, Varnitha Kurli⁴

¹University of Notre Dame, ²Indian School of Business, ³University of Michigan, ⁴University of Colorado Boulder

## Abstract

This repository contains Stata replication code for our analysis of the Mid-Himalayan Watershed Development Project in northern India. We find that material incentives in sustainable development programs can undermine both pro-environmental behaviors and motivations - phenomena we term "behavioral crowding" and "motivational crowding." Our study demonstrates these effects are distinct and that behavioral change aligns with motivational shifts imperfectly at best.

## Data Availability

Research data available on Zenodo: [![DOI](https://doi.org/10.5281/zenodo.16904496)

## Requirements

- **Stata 17+** (tested on Stata 17.0)
- **Required packages:** 
  ```stata
  ssc install estout
  ssc install outreg2  
  ssc install reghdfe
  ssc install coefplot
  ```

## Usage

1. Download data from Zenodo and extract to `./1_data/1_processed/` directory
2. Set working directory to repository root
3. Run master do-file:
   ```stata
   do do_files/0_project_masterdofile.do
   ```

## Repository Structure

```
├── do_files/
│   ├── 0_project_masterdofile.do    # Master file - runs all analysis
│   ├── 1_matching_results_project.do # Matching and main results analysis
│   ├── 2_maintext_figures.do        # Generate main paper figures (1-4)
│   └── 3_supplementary_figures.do   # Generate supplementary figures & tables
└── README.md
```

## Contact

For questions about the replication code: [varnitha.kurli@colorado.edu]

## Acknowledgments

We thank Satya Prasanna for fieldwork organization and data collection in Himachal Pradesh. Funding provided by the National Science Foundation (SES-0961868, SES-0418024) and University of Michigan's Ford School of Public Policy.
