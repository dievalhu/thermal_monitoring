# Install packages if needed

# install.packages("readxl")
# install.packages("dplyr")

library(readxl)
library(dplyr)

# Read data
automated_data <- read_excel("temperature_data.xlsx", sheet = "sowing_data")
manual_data <- read_excel("temperature_data.xlsx", sheet = "manual_data")

# Convert date columns
automated_data$Date <- as.POSIXct(automated_data$Date)
manual_data$DATE <- as.POSIXct(manual_data$DATE)

# Filter records from September 8 to September 18, 2024
automated_filtered <- filter(
  automated_data,
  Date >= as.POSIXct("2024-09-08") & Date <= as.POSIXct("2024-09-18")
)

manual_filtered <- filter(
  manual_data,
  DATE >= as.POSIXct("2024-09-08") & DATE <= as.POSIXct("2024-09-18")
)

# List of equivalent sensor pairs to compare
sensor_pairs <- list(
  c("C1", "S1"),
  c("C2", "S2"),
  c("C3", "S3"),
  c("C4", "S4"),
  c("A1", "S9"),
  c("A2", "S10")
)

# Initialize results table
results <- data.frame(
  Pair = character(),
  F_value = numeric(),
  p_anova = numeric(),
  t_statistic = numeric(),
  p_t_test = numeric(),
  stringsAsFactors = FALSE
)

# Comparison loop
for (sensor_pair in sensor_pairs) {
  automated_sensor <- sensor_pair[1]
  manual_sensor <- sensor_pair[2]
  
  cat(paste0("\n### ", automated_sensor, " vs ", manual_sensor, " ###\n"))
  
  automated_values <- automated_filtered[[automated_sensor]]
  manual_values <- manual_filtered[[manual_sensor]]
  
  # Remove missing values
  automated_values <- automated_values[!is.na(automated_values)]
  manual_values <- manual_values[!is.na(manual_values)]
  
  if (length(automated_values) > 2 && length(manual_values) > 2) {
    # Combine values and group labels
    values <- c(automated_values, manual_values)
    group <- factor(
      c(
        rep("Automated", length(automated_values)),
        rep("Manual", length(manual_values))
      )
    )
    
    # ANOVA
    anova_model <- aov(values ~ group)
    anova_summary <- summary(anova_model)
    
    f_value <- anova_summary[[1]]$`F value`[1]
    p_value_anova <- anova_summary[[1]]$`Pr(>F)`[1]
    
    # Student's t-test
    t_test_result <- t.test(automated_values, manual_values)
    
    # Store results
    results <- rbind(
      results,
      data.frame(
        Pair = paste(automated_sensor, "vs", manual_sensor),
        F_value = round(f_value, 2),
        p_anova = round(p_value_anova, 4),
        t_statistic = round(t_test_result$statistic, 2),
        p_t_test = round(t_test_result$p.value, 4)
      )
    )
    
    # Print detailed results
    print(anova_summary)
    print(t_test_result)
  } else {
    cat("Not enough data available for this sensor pair.\n")
  }
}

# Print final results table
print(results)