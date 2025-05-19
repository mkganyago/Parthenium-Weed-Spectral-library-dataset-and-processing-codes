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
# Preprocess spectral data using Moving Average and Savitzky-Golay filters
#----------------------------------------------------------------
# Helper function to pad or trim a vector to match a specified length
pad_or_trim <- function(x, target_length) {
  n <- length(x)
  if (n < target_length) {
    c(rep(NA, (target_length - n) / 2), x, rep(NA, (target_length - n) / 2))
  } else if (n > target_length) {
    start <- (n - target_length) / 2 + 1
    end <- start + target_length - 1
    x[start:end]
  } else {
    x
  }
}

pivoted_data <- hyperdata %>%
  pivot_longer(-species, names_to = "wavelength", values_to = "reflectance") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(species, wavelength)

head(pivoted_data)

# Apply preprocessing with padding/trimming
preprocessed_data <- pivoted_data %>%
  group_by(species) %>%
  mutate(
    Reflect_MA = pad_or_trim(movav(reflectance, w = 11), length(reflectance)), # Moving Average
    Reflect_SG = pad_or_trim(savitzkyGolay(reflectance, p = 3, w = 11, m = 0), length(reflectance)) # Savitzky-Golay
  ) %>%
  ungroup()

head(preprocessed_data)
#------------------------------------------------------------------
# Original vs Savitzky-Golay vs Moving Average
# Select and format single PH spectrum
plot_data <- preprocessed_data %>%
  filter(species == "PH") %>%
  slice(1:which.max(wavelength)) %>%  # Get full spectrum
  select(wavelength, reflectance, Reflect_MA, Reflect_SG) %>%
  pivot_longer(cols = -wavelength,
               names_to = "Processing",
               values_to = "Reflectance") %>%
  mutate(Processing = recode(Processing,
                             "reflectance" = "Raw",
                             "Reflect_MA" = "Moving Average",
                             "Reflect_SG" = "Savitzky-Golay"))

# Create faceted plot
preprocess_plot <- ggplot(plot_data, aes(x = wavelength, y = Reflectance)) +
  geom_line(color = "#2c7bb6", size = 0.6, na.rm = TRUE) +
  facet_wrap(~ Processing, ncol = 1, scales = "fixed") +
  coord_cartesian(xlim = c(900, 1300), ylim = c(40, 60)) +
  labs(
       x = "Wavelength (nm)",
       y = "Reflectance (%)") +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 14),
    strip.text = element_text(size = 14, face = "bold"),
    panel.spacing = unit(0.5, "lines"),
    panel.grid.minor = element_blank(),
    plot.title = element_text(size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 14, hjust = 0.5)
  )

# Save high-resolution plot
ggsave("./Figures/preprocess_plots.jpeg", preprocess_plot,
       dpi = 600, width = 10, height = 8, units = "in")
#----------------------------------------------------------------
# Export Moving Average processed data
preprocessed_data %>%
  select(species, wavelength, reflectance = Reflect_MA) %>%
  write.csv("./Data/Preprocessed/moving_average_spectra.csv", row.names = FALSE)

# Export Savitzky-Golay processed data
preprocessed_data %>%
  select(species, wavelength, reflectance = Reflect_SG) %>%
  write.csv("./Data/Preprocessed/savitzky_golay_spectra.csv", row.names = FALSE)
