# Wine Quality Analysis

A comprehensive R script that downloads, cleans, and analyzes the UCI Wine Quality datasets (red & white) and produces a suite of exploratory visualizations, principal component analysis, and a predictive regression model.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Script Breakdown](#script-breakdown)
7. [Key Visualizations](#key-visualizations)
8. [Principal Component Analysis](#principal-component-analysis)
9. [Regression Modeling](#regression-modeling)
10. [Extending & Customizing](#extending--customizing)
11. [Data Sources & Citations](#data-sources--citations)
12. [License](#license)

---

## Project Overview

This project provides a single, self-contained R script (`Wine_Quality_Analysis.R`) that:

* **Automatically installs** and loads required packages
* **Downloads** red and white wine quality data from the UCI repository
* **Parses** semicolon-delimited files with explicit decimal handling
* **Merges** into one tidy data frame with a `type` factor
* **Creates** multiple exploratory plots to uncover chemical and quality patterns
* **Performs** Principal Component Analysis (PCA) on standardized attributes
* **Fits** a linear regression predicting wine quality from key predictors
* **Outputs** summary statistics, diagnostic plots, and fitted vs. actual comparisons

Ideal for data scientists, statisticians, and wine enthusiasts seeking a reproducible pipeline for exploring chemical correlates of perceived wine quality.

---

## Features

1. **Data Ingestion & Cleaning**

   * Downloads CSVs for red & white wines
   * Enforces consistent numeric types via `read_delim()` with explicit `locale`

2. **Exploratory Visualizations**

   * Bar chart of quality counts by type
   * Jittered scatter of alcohol content vs. quality
   * Faceted boxplots for key chemical attributes by quality
   * Correlation heatmap of all numeric variables

3. **Dimensionality Reduction (PCA)**

   * Scree plot of variance explained
   * Biplot illustrating attribute loadings

4. **Predictive Modeling**

   * Linear regression of numeric quality on alcohol, sulphates, pH, and type
   * Model summary and residuals vs. fitted diagnostic
   * Scatter of fitted vs. actual quality

---

## Prerequisites

* **R** (version ≥ 4.0)
* Internet connection (to download data)

### R Packages

* **tidyverse** (`ggplot2`, `dplyr`, `tidyr`, `readr`)
* **GGally**
* **corrplot**
* **factoextra**

All missing packages will be installed automatically by the script.

---

## Installation

1. **Clone or download** this repository:

   ```bash
   git clone https://github.com/yourusername/wine-quality-analysis.git
   cd wine-quality-analysis
   ```
2. **Ensure** R (≥4.0) is on your `PATH`.

*No additional build steps required.*

---

## Usage

Open an R console or RStudio in the project directory and run:

```r
source("Wine_Quality_Analysis.R")
```

The script will:

* Print basic counts of red vs. white wines
* Render each plot in sequence
* Display PCA diagnostics
* Print regression summary
* Show diagnostic plots and final fitted vs. actual chart

---

## Script Breakdown

1. **Setup**

   * Defines package list, installs missing ones
   * Loads libraries

2. **Data Loading**

   * Uses `read_delim()` with `locale(decimal_mark=".")`
   * Applies a `col_types` spec to ensure all measurement columns are `double()`

3. **Data Wrangling**

   * Adds a `type` factor (red/white)
   * Converts `quality` to an ordered factor

4. **Exploratory Plots**

   * **p1:** Bar chart of quality counts
   * **p2:** Jitter scatter of alcohol vs. quality
   * **p3:** Faceted boxplots for pH, residual sugar, citric acid, sulphates

5. **Correlation Analysis**

   * Correlation matrix heatmap of all numeric variables

6. **PCA**

   * Scree plot of variance explained
   * Biplot of the first two principal components

7. **Regression**

   * Linear model: `quality ~ alcohol + sulphates + pH + type`
   * Summary printed to console
   * Residuals vs. fitted plot
   * Fitted vs. actual scatter

---

## Key Visualizations

<p align="center">
  <img src="img/quality-by-type.png" width="60%" />
</p>

<p align="center">
  <img src="img/alcohol-vs-quality.png" width="60%" />
</p>

<p align="center">
  <img src="img/boxplots-attributes.png" width="60%" />
</p>

<p align="center">
  <img src="img/corr-heatmap.png" width="60%" />
</p>

---

## Principal Component Analysis

<p align="center">
  <img src="img/pca-scree.png" width="60%" />
</p>

<p align="center">
  <img src="img/pca-biplot.png" width="60%" />
</p>

---

## Regression Modeling

<p align="center">
  <img src="img/fitted-vs-actual.png" width="60%" />
</p>

Interpretation:

* **R²**, **coefficients**, and **p-values** printed in console
* Diagnostic plot (`Residuals vs Fitted`) helps assess homoscedasticity

---

## Extending & Customizing

* **Add predictors** (e.g., `residual sugar`, `free sulfur dioxide`) to the regression
* **Try nonlinear models** (e.g., random forest, gradient boosting)
* **Tune PCA** by selecting different scaling or component count
* **Export plots** by inserting `ggsave()` calls after each `print()`

---

## Data Sources & Citations

* **Wine Quality Data**
  UCI Machine Learning Repository:

  * Red wine:
    `https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv`
  * White wine:
    `https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv`

* **R & Packages**

  * R Core Team (2023). R: A language and environment for statistical computing.
  * Hadley Wickham et al., for **tidyverse**, **GGally**, **corrplot**, **factoextra**.

---

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for details.
