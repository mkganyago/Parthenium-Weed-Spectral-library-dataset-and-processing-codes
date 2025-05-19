#------------------------------------------------------------------
#--------------------Parthenium Weed Spectral Library--------------
#-----------------------Licence Agreement--------------------------
# Copyright <2024> <Copyright Holder: Mahlatse Kganyago (mahlatse@uj.ac.za)>
# MIT Licence (https://opensource.org/license/mit)
#------------------------------------------------------------------
# -------------------Required libraries----------------------------
# Install necessary packages if they are not already installed
if (!requireNamespace("prospectr", quietly = TRUE)) install.packages("prospectr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("tidyverse", quietly = TRUE)) install.packages("tidyverse")
if (!requireNamespace("tidyr", quietly = TRUE)) install.packages("tidyr")
if (!requireNamespace("skimr", quietly = TRUE)) install.packages("skimr")

# Load the required libraries
library(prospectr)
library(ggplot2)
library(dplyr)
library(tidyr)
