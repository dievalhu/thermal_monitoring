# Install packages if needed

# install.packages("readxl")
# install.packages("dplyr")
# install.packages("tidyr")
# install.packages("ggplot2")

library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

# File path
file_path <- "temperature_data.xlsx"

# Read sheets
sowing_data <- read_excel(file_path, sheet = "sowing_data")
manual_data <- read_excel(file_path, sheet = "manual_data")

# Clean column names
names(sowing_data) <- trimws(names(sowing_data))
names(manual_data) <- trimws(names(manual_data))

# Convert date columns
sowing_data$Date <- as.POSIXct(sowing_data$Date)
manual_data$DATE <- as.POSIXct(manual_data$DATE)

# Filter records from September 8 to September 18, 2024
sowing_filtered <- filter(
  sowing_data,
  Date >= as.POSIXct("2024-09-08") & Date <= as.POSIXct("2024-09-18")
)

manual_filtered <- filter(
  manual_data,
  DATE >= as.POSIXct("2024-09-08") & DATE <= as.POSIXct("2024-09-18")
)

# Create long-format table for automated measurements
automated_df <- sowing_filtered %>%
  select(C1, C2, C3, C4, A1, A2) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Sensor",
    values_to = "Temperature"
  ) %>%
  mutate(Method = "Automated")

# Create long-format table for manual measurements
manual_df <- manual_filtered %>%
  select(S1, S2, S3, S4, S9, S10) %>%
  pivot_longer(
    cols = everything(),
    names_to = "Sensor",
    values_to = "Temperature"
  ) %>%
  mutate(Method = "Manual")

# Merge both datasets
temperature_long <- bind_rows(automated_df, manual_df)

# Classify sensor location and define sensor order
temperature_long <- temperature_long %>%
  mutate(
    Location = ifelse(Sensor %in% c("A1", "A2", "S9", "S10"), "Air", "Bed"),
    Sensor = factor(
      Sensor,
      levels = c("C1", "S1", "C2", "S2", "C3", "S3", "C4", "S4", "A1", "S9", "A2", "S10")
    )
  )

# Create boxplot
temperature_plot <- ggplot(
  temperature_long,
  aes(x = Sensor, y = Temperature, fill = Method)
) +
  geom_boxplot() +
  scale_fill_manual(values = c("Automated" = "#1f77b4", "Manual" = "#ff7f0e")) +
  labs(
    title = "Temperature distribution by sensor and method (September 8-18)",
    x = "Sensor",
    y = "Temperature (°C)"
  ) +
  theme_minimal() +
  theme(
    text = element_text(size = 12),
    axis.text.x = element_text(size = 11),
    legend.position = "bottom",
    legend.box = "horizontal",
    legend.title = element_text(size = 12),
    legend.text = element_text(size = 10)
  )

# Save plot as PDF
ggsave("temperatures.pdf", plot = temperature_plot, width = 10, height = 6)