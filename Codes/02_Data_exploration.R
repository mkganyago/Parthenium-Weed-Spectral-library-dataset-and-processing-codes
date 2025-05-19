#------------------------------------------------------------------
#--------------------Parthenium Weed Spectral Library--------------
#-----------------------Licence Agreement--------------------------
# Copyright <2024> <Copyright Holder: Mahlatse Kganyago (mahlatse@uj.ac.za)>
# MIT Licence (https://opensource.org/license/mit)
#------------------------------------------------------------------
# Source the script------------------------------------------------
source("./Codes/01_Libraries.R")
# -----------------------------------------------------------------
# Load Original data ----------------------------------------------
hyperdata <- read.csv("./Data/Original_spectra/parthenium_weed_data.csv", header=TRUE, as.is=TRUE, check.names=FALSE)
head(hyperdata)
str(hyperdata)

# Plot the averaged spectra---------------------------------------
# Function to compute min, mean, and max for spectral data
#library(tidyverse)
# Compute summary statistics by species
summary_data <- hyperdata %>%
  pivot_longer(-species, names_to = "wavelength", values_to = "value") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(species, wavelength) %>%
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    .groups = "drop"
  )

head(summary_data)

# Create faceted plot
spectral_plot <- ggplot(summary_data, aes(x = wavelength)) +
  geom_ribbon(aes(ymin = min, ymax = max), fill = "grey60", alpha = 0.3) +
  geom_line(aes(y = mean), color = "darkblue", linewidth = 0.5) +
  facet_wrap(~ species, ncol = 2) +  # Creates 2x2 grid for 4 species
  coord_cartesian(ylim = c(0, 80)) +  # Fixed y-axis range
  labs(x = "Wavelength", y = "Reflectance (%)",
       title = "") +
  theme_minimal() +
  theme(
    strip.background = element_rect(fill = "grey90"),
    strip.text = element_text(face = "bold")
  )

# Save high-resolution plot
ggsave("./Figures/original_spectral_profiles.jpeg", spectral_plot,
       dpi = 600, width = 10, height = 8, units = "in")

# Averaged spectra per species
avereaged_spectra_plot <- ggplot(summary_data, aes(x = wavelength, y = mean, color = species)) +
  geom_line(size = 1) +
  labs(title = "",
       x = "Wavelength (nm)",
       y = "Reflectance (%)",
       color = "Species") +
  theme_minimal()+
  theme(
    legend.position = "top",
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 14)
  )

# Save high-resolution plot
ggsave("./Figures/original_spectral_profiles_mean.jpeg", avereaged_spectra_plot,
       dpi = 600, width = 15, height = 8, units = "in")
#----------------------------------------------------------------



