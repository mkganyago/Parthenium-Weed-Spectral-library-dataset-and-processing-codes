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
#
library(hsdar)
# convert the data.frame to matrix
spectra_m<-as.matrix(hyperdata[,2:2152])
str(spectra_m)

# Get the wavelengths from names of original data
wavelength<-as.numeric(names(hyperdata[,2:2152]))
str(wavelength)

# Create Spec lib
field_data<-speclib(spectra_m, wavelength)
str(field_data)

species<-hyperdata$species
SI(field_data) <- as.character(species)
str(field_data)
names(SI(field_data)) <- "Species"

# Plot
par(mfrow = c(1,1))
plot(field_data,col= "red", xlim= c(400,2500), legend = list(x = "topleft"))

# Mask 
hsdar::mask(field_data) <- c(350,399,1350,1460,1790,1960,2300, 2500)

par(mfrow=c(1,1))
plot(field_data, FUN = 1)

#------------------------------------------------------------------
# Resampling to EnMap
resampled_enmap_data <- spectralResampling(field_data, "EnMAP", response_function = F)

# Print resampled wv
wavelength(resampled_enmap_data)

# Plot resampled spectra
par(mfrow=c(1,1))
plot(resampled_enmap_data)

#check the structure for Resampled EnMap data
str(resampled_enmap_data)
resampled_enmap_res<-spectra(resampled_enmap_data)

#check structure again
str(resampled_enmap_res)

# Extract the SI (Species names) from speclib and Wavelengths
class_names <- SI(resampled_enmap_data)
column_bandnames <- round(wavelength(resampled_enmap_data), 2)

# Rename the data
resampled_enmap_res <- as.data.frame(cbind(class_names,resampled_enmap_res))
head(resampled_enmap_res)
length(resampled_enmap_res)

names(resampled_enmap_res)[2:243] <- as.character(column_bandnames)

head(resampled_enmap_res)

# Compute summary statistics by species
summary_data_enmap <- resampled_enmap_res %>%
  pivot_longer(-Species, names_to = "wavelength", values_to = "value") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(Species, wavelength) %>%
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    .groups = "drop"
  )

head(summary_data_enmap)

# Averaged spectra per species
averaged_spectra_plot_enmap <- ggplot(summary_data_enmap, aes(x = wavelength, y = mean, color = Species)) +
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
ggsave("./Figures/enmap_spectral_profiles_mean.jpeg", averaged_spectra_plot_enmap,
       dpi = 600, width = 15, height = 8, units = "in")

# Write to CSV
write.csv(resampled_enmap_res, "./Data/Multisensor_resampled_spectra/Parthenium_weed_library_enmap.csv")
#------------------------------------------------------------------
# Resampling to Hyperion
resampled_hyperion_data <- spectralResampling(field_data, "Hyperion", response_function = F)

# Print resampled wv
wavelength(resampled_hyperion_data)

#check the structure for Resampled hyperion data
str(resampled_hyperion_data)
resampled_hyperion_res<-spectra(resampled_hyperion_data)

#check structure again
str(resampled_hyperion_res)

# Extract the SI (Species names) from speclib and Wavelengths
class_names <- SI(resampled_hyperion_data)
column_bandnames <- round(wavelength(resampled_hyperion_data), 2)

# Rename the data
resampled_hyperion_res <- as.data.frame(cbind(class_names,resampled_hyperion_res))
head(resampled_hyperion_res)
length(resampled_hyperion_res)

names(resampled_hyperion_res)[2:243] <- as.character(column_bandnames)

head(resampled_hyperion_res)

# Compute summary statistics by species
summary_data_hyperion <- resampled_hyperion_res %>%
  pivot_longer(-Species, names_to = "wavelength", values_to = "value") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(Species, wavelength) %>%
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    .groups = "drop"
  )

head(summary_data_hyperion)

# Averaged spectra per species
averaged_spectra_plot_hyperion <- ggplot(summary_data_hyperion, aes(x = wavelength, y = mean, color = Species)) +
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
ggsave("./Figures/hyperion_spectral_profiles_mean.jpeg", averaged_spectra_plot_hyperion,
       dpi = 600, width = 15, height = 8, units = "in")

# Write to CSV
write.csv(resampled_hyperion_res, "./Data/Multisensor_resampled_spectra/Parthenium_weed_library_hyperion.csv")
#------------------------------------------------------------------
# Resampling to Sentinel2a
resampled_Sentinel2a_data <- spectralResampling(field_data, "Sentinel2a", response_function = T)

# Print resampled Sentinel-2
wavelength(resampled_Sentinel2a_data)

#check the structure for Resampled Sentinel2a data
str(resampled_Sentinel2a_data)
resampled_Sentinel2a_res<-spectra(resampled_Sentinel2a_data)

#check structure again
str(resampled_Sentinel2a_res)

# Extract the SI (Species names) from speclib and Wavelengths
class_names <- SI(resampled_Sentinel2a_data)
column_bandnames <- round(wavelength(resampled_Sentinel2a_data), 2)

# Rename the data
resampled_Sentinel2a_res <- as.data.frame(cbind(class_names,resampled_Sentinel2a_res))
head(resampled_Sentinel2a_res)
length(resampled_Sentinel2a_res)

names(resampled_Sentinel2a_res)[2:14] <- as.character(column_bandnames)

head(resampled_Sentinel2a_res)

# Compute summary statistics by species
summary_data_s2a <- resampled_Sentinel2a_res %>%
  pivot_longer(-Species, names_to = "wavelength", values_to = "value") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(Species, wavelength) %>%
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    .groups = "drop"
  )

head(summary_data_s2a)

# Averaged spectra per species
averaged_spectra_plot_s2a <- ggplot(summary_data_s2a, aes(x = wavelength, y = mean, color = Species)) +
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
ggsave("./Figures/s2_spectral_profiles_mean.jpeg", averaged_spectra_plot_s2a,
       dpi = 600, width = 15, height = 8, units = "in")

# Write to CSV
resampled_Sentinel2a_res %>%
  write.csv("./Data/Multisensor_resampled_spectra/Parthenium_weed_library_Sentinel2a.csv", row.names = F)
#------------------------------------------------------------------
# Resampling to WorldView2-8
resampled_wv2_data <- spectralResampling(field_data, "WorldView2-8", response_function = T)

# Print resampled wv
wavelength(resampled_wv2_data)

#check the structure for Resampled wv2 data
str(resampled_wv2_data)
resampled_wv2_res<-spectra(resampled_wv2_data)

#check structure again
str(resampled_wv2_res)

# Extract the SI (Species names) from speclib and Wavelengths
class_names <- SI(resampled_wv2_data)
column_bandnames <- round(wavelength(resampled_wv2_data), 2)

# Rename the data
resampled_wv2_res <- as.data.frame(cbind(class_names,resampled_wv2_res))
head(resampled_wv2_res)
length(resampled_wv2_res)

names(resampled_wv2_res)[2:9] <- as.character(column_bandnames)

head(resampled_wv2_res)

# Compute summary statistics by species
summary_data_wv2 <- resampled_wv2_res %>%
  pivot_longer(-Species, names_to = "wavelength", values_to = "value") %>%
  mutate(wavelength = as.numeric(wavelength)) %>%
  group_by(Species, wavelength) %>%
  summarise(
    min = min(value),
    mean = mean(value),
    max = max(value),
    .groups = "drop"
  )

head(summary_data_wv2)

# Averaged spectra per species
averaged_spectra_plot_wv2 <- ggplot(summary_data_wv2, aes(x = wavelength, y = mean, color = Species)) +
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
ggsave("./Figures/wv2_spectral_profiles_mean.jpeg", averaged_spectra_plot_wv2,
       dpi = 600, width = 15, height = 8, units = "in")

# Write to CSV
resampled_wv2_res %>%
  write.csv("./Data/Multisensor_resampled_spectra/Parthenium_weed_library_wv2.csv", row.names = T)

plot_list <- list(averaged_spectra_plot_enmap,averaged_spectra_plot_hyperion, averaged_spectra_plot_s2a, averaged_spectra_plot_wv2)

# Combine all plots into a single column layout
all_res_plots <- grid.arrange(grobs = plot_list, ncol = 2)

# Save high-resolution plot
ggsave("./Figures/all_res_plots.jpeg", all_res_plots,
       dpi = 600, width = 15, height = 8, units = "in")
