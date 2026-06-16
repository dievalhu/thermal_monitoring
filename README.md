````markdown
# IoT-Based Thermal Monitoring for *Agaricus bisporus* Cultivation

This repository contains the dataset and R scripts used to analyze temperature records collected during the cultivation of *Agaricus bisporus*. The study compares a traditional manual monitoring procedure with an IoT-based automated thermal monitoring system deployed in a commercial mushroom production chamber.

The objective is to evaluate whether automated monitoring improves temporal resolution, traceability, and the detection of short-term thermal fluctuations that are not captured by sparse manual readings.

---

## Repository Contents

```text
.
├── temperature_data.xlsx
├── plot_temperature_distribution.R
├── plot_bed_temperature_dispersion.R
├── statistical_comparison_anova_ttest.R
├── temperatures.pdf
├── bed_temperature_dispersion.pdf
└── README.md
````

### Files

* `temperature_data.xlsx`
  Original temperature dataset. It contains automated and manual records organized by date, sensor, and measurement location.

* `plot_temperature_distribution.R`
  Generates a boxplot comparing temperature distributions between automated and manual measurements for bed and air sensors during the selected analysis period.

* `plot_bed_temperature_dispersion.R`
  Generates a jitter plot comparing bed-level temperature dispersion between the automated and manual methods for a target date.

* `statistical_comparison_anova_ttest.R`
  Performs ANOVA and Student's *t*-tests for equivalent automated and manual sensor pairs.

* `temperatures.pdf`
  Output figure showing the temperature distribution by sensor and monitoring method.

* `bed_temperature_dispersion.pdf`
  Output figure showing the bed-level temperature dispersion for the selected date.

---

## Data Description

The dataset includes two types of temperature records:

1. **Automated monitoring data**
   Collected using digital temperature sensors installed in mushroom beds and air measurement points. The automated system records temperature every 15 minutes, producing up to 96 records per sensor per day.

2. **Manual monitoring data**
   Collected by technical staff using traditional thermometers and physical recording forms. Manual monitoring provides only a few readings per day.

The main sensor pairs compared in the analysis are:

| Automated sensor | Manual sensor | Location |
| ---------------- | ------------- | -------- |
| C1               | S1            | Bed      |
| C2               | S2            | Bed      |
| C3               | S3            | Bed      |
| C4               | S4            | Bed      |
| A1               | S9            | Air      |
| A2               | S10           | Air      |

---

## Analysis Period

The comparison focuses on an uninterrupted 11-day period:

```text
September 8 to September 18, 2024
```

This period was selected because both automated and manual records were available continuously, allowing a direct comparison between monitoring methods.

---

## Methods

The analysis includes:

* **Temperature distribution analysis** using boxplots.
* **Bed-level dispersion analysis** using jitter plots.
* **One-way ANOVA** to evaluate statistical differences between automated and manual measurements.
* **Student's *t*-tests** to compare mean temperatures for equivalent sensor pairs.

The statistical comparison evaluates whether the automated system captures thermal behavior that is not observed through traditional manual monitoring.

---

## Requirements

The scripts were developed in R and require the following packages:

```r
install.packages(c("readxl", "dplyr", "tidyr", "ggplot2"))
```

Required libraries:

```r
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
```

---

## How to Reproduce the Analysis

1. Clone this repository:

```bash
git clone https://github.com/your-username/your-repository-name.git
cd your-repository-name
```

2. Open the project in RStudio or run the scripts directly from R.

3. Make sure `temperature_data.xlsx` is located in the root directory of the repository.

4. Run the scripts in the following order:

```r
source("plot_temperature_distribution.R")
source("plot_bed_temperature_dispersion.R")
source("statistical_comparison_anova_ttest.R")
```

5. The generated figures will be saved as PDF files in the repository directory.

---

## Main Findings

The automated system increases the monitoring frequency from a few manual readings per day to 96 records per sensor per day. This higher temporal resolution allows the detection of microclimatic oscillations and thermal peaks that are not captured by the traditional method.

The statistical analysis showed significant differences in five of the six equivalent sensor pairs, supporting the use of IoT-based monitoring for more detailed thermal characterization in controlled *Agaricus bisporus* cultivation.

---

## Citation

If you use this dataset or code, please cite the associated paper:

```bibtex
@inproceedings{thermal_monitoring_agaricus_2026,
  title     = {IoT-Based Intelligent Thermal Monitoring for Controlled Agaricus bisporus Cultivation},
  author    = {Author names removed for review},
  booktitle = {WITCOM 2026},
  year      = {2026}
}
```

---

## License

This repository is intended for academic and research purposes. Please check the license file before reusing the dataset or code.

```
```
