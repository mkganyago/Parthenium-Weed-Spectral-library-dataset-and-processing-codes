# Parthenium-Weed-Spectral-library-dataset-and-processing-codes

This repository contains R scripts for processing and analyzing spectral data of Parthenium weed, including preprocessing, filtering, masking noisy bands, and resampling to various satellite sensors.

Open on Binder using RStudio: [![Binder](http://mybinder.org/badge_logo.svg)](http://mybinder.org/v2/gh/mkganyago/Parthenium-Weed-Spectral-library-dataset-and-processing-codes/master?urlpath=rstudio)

## Overview

The project processes hyperspectral data to explore spectral profiles, apply filtering techniques, remove noisy regions, and resample data to match multispectral sensors (EnMAP, Hyperion, Sentinel-2, WorldView2). Outputs include cleaned datasets and visualizations.

## Repository Structure

- **`Codes/`**: Contains all R scripts.
  - `01_Libraries.R`: Installs/loads required packages.
  - `02_Data_exploration.R`: Generates raw spectral plots and summary statistics.
  - `03_Spectral_filtering.R`: Applies Moving Average and Savitzky-Golay filters.
  - `04_Spectral_masking.R`: Masks noisy spectral regions.
  - `05_Multisensor_resampling.R`: Resamples data to satellite sensor specifications.
- **`Data/`**: Stores input/output data.
  - `Original_spectra/`: Raw spectral data.
  - `Preprocessed/`: Filtered and masked datasets.
  - `Multisensor_resampled_spectra/`: Sensor-specific resampled data.
- **`Figures/`**: Output plots (spectral profiles, preprocessing results, etc.).

## Dependencies

- R (≥ 4.0)
- Packages: `prospectr`, `ggplot2`, `dplyr`, `tidyr`, `hsdar`, `tidyverse`.

## Usage

1. **Install dependencies**: Run `Codes/01_Libraries.R` first.
2. **Execute scripts in order**:
   - `02_Data_exploration.R`: Generates baseline spectral plots.
   - `03_Spectral_filtering.R`: Applies smoothing filters.
   - `04_Spectral_masking.R`: Removes noisy bands.
   - `05_Multisensor_resampling.R`: Produces sensor-compatible datasets.
3. Outputs are saved to `Data/` and `Figures/`.

## Output Examples

- **Plots**: Spectral profiles (raw, filtered, masked) and sensor-resampled comparisons.
![masked_spectra_plot](https://github.com/user-attachments/assets/e3d72b31-9915-4f78-aea6-e961e8489ba3)

![all_res_plots](https://github.com/user-attachments/assets/a9c94232-c21a-4b36-bf8d-73e55320d9b7)

- **Data**: CSV files for processed spectra (e.g., `moving_average_spectra.csv`, `Parthenium_weed_library_Sentinel2a.csv`).

## License

MIT License. Copyright © 2024 Mahlatse Kganyago. See [LICENSE](https://opensource.org/license/mit) for details.
