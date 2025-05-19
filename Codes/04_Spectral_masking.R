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
#----------------------------------------------------------------
# Removal of noisy regions (Masking)
#----------------------------------------------------------------
# Define the function to mask noisy spectral bands
mask_noisy_bands <- function(data, noisy_bands) {
  # Iterate over each noisy band range and set values to NA
  for (band in noisy_bands) {
    data <- data %>%
      mutate(reflectance = ifelse(
        wavelength >= band[1] & wavelength <= band[2],
        NA,  # Mark these ranges as NA
        reflectance
      ))
  }
  return(data)
}
#----------------------------------------------------------------
# glimpse of the data
head(hyperdata)

pivoted_data <- hyperdata %>%
  pivot_longer(-species, names_to = "wavelength", values_to = "reflectance") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(species, wavelength)

head(pivoted_data)

# Define the noisy regions
# (350–399 nm; 1350–1465 nm, 1790–1960 nm, and 2350–2500 nm)
noisy_bands <- list(
  c(350, 399),
  c(1350, 1465),
  c(1790, 1960),
  c(2350, 2500)
)

# Remove/Filter the noisy spectral bands 
masked_data <- mask_noisy_bands(pivoted_data, noisy_bands)

head(masked_data)

#Export Masked spectra 
masked_data %>%
  write.csv("./Data/Preprocessed/masked_spectra.csv", row.names = FALSE)

# Combine original and filtered data for comparison
combined_data <- bind_rows(
  pivoted_data %>% mutate(type = "Raw Spectra"),
  masked_data %>% mutate(type = "Masked Spectra")
)

# Plot the original vs masked spectra with gaps and ablines for noisy bands
masked_spectra_plot <- ggplot(combined_data, aes(x = wavelength, y = reflectance, color = type)) +
  geom_line(aes(group = interaction(type)), alpha = 0.5) +
  facet_wrap(~ type, scales = "fixed") +
  coord_cartesian(ylim = c(0, 80)) +
  labs(
    x = "Wavelength (nm)",
    y = "Reflectance (%)",
    color = "") +
  theme_minimal() +
  geom_vline(xintercept = unlist(noisy_bands), linetype = "dashed", color = "red") +
  theme(legend.position = "none",
    axis.title.x = element_text(size = 14),
    axis.title.y = element_text(size = 14),
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    strip.text = element_text(size = 14, face = "bold"),
    legend.text = element_text(size = 14)
  )

# Save high-resolution plot
ggsave("./Figures/masked_spectra_plot.jpeg", masked_spectra_plot,
       dpi = 600, width = 15, height = 8, units = "in")
