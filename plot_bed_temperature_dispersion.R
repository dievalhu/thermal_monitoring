# Load libraries
library(ggplot2)
library(dplyr)
library(readxl)
library(tidyr)

# File path
file_path <- "temperature_data.xlsx"

# Target date for the analysis
target_date <- as.Date("2024-09-08")

# Read sheets
automated_data <- read_excel(file_path, sheet = "sowing_data")
manual_data <- read_excel(file_path, sheet = "manual_data")

# Clean column names
names(automated_data) <- trimws(names(automated_data))
names(manual_data) <- trimws(names(manual_data))

# Convert date columns to Date format
automated_data$Date <- as.Date(automated_data$Date)
manual_data$DATE <- as.Date(manual_data$DATE)

# Prepare automated measurements in long format
automated_stats <- automated_data %>%
  filter(Date == target_date) %>%
  select(C1, C2, C3, C4) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Bed",
    values_to = "Temperature"
  ) %>%
  mutate(Method = "Automated")

# Prepare manual measurements in long format
manual_stats <- manual_data %>%
  filter(DATE == target_date) %>%
  select(S1, S2, S3, S4) %>%
  rename(C1 = S1, C2 = S2, C3 = S3, C4 = S4) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Bed",
    values_to = "Temperature"
  ) %>%
  mutate(Method = "Manual")

# Combine both datasets
combined_data <- bind_rows(automated_stats, manual_stats)

# Create jitter plot
temperature_plot <- ggplot(
  combined_data,
  aes(x = Bed, y = Temperature, color = Method)
) +
  geom_jitter(
    position = position_jitterdodge(jitter.width = 0.2),
    alpha = 0.7,
    size = 2
  ) +
  scale_color_manual(values = c("Automated" = "#ff7f0e", "Manual" = "#1f77b4")) +
  labs(
    x = "Bed",
    y = "Temperature (°F)"
  ) +
  theme_minimal() +
  theme(
    axis.line.x = element_line(color = "black", linewidth = 0.6),
    axis.line.y = element_line(color = "black", linewidth = 0.6)
  )

# Save plot as PDF
ggsave("bed_temperature_dispersion.pdf", plot = temperature_plot, width = 10, height = 6)