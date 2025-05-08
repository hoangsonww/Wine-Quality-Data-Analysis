# =================================================================================
# Wine_Quality_Analysis.R
#
# A comprehensive R script to fetch, analyze, and visualize the UCI Wine Quality
# datasets (red & white) from the UCI Machine Learning Repository.
#
# Features:
#   1. Downloads both red and white wine CSVs via URL
#   2. Merges into a single dataframe with a “type” factor
#   3. Exploratory plots:
#        • Distribution of quality by wine type
#        • Boxplots of key chemical attributes by quality
#        • Scatter plot of alcohol vs. quality
#        • Correlation heatmap of numeric variables
#   4. Principal Component Analysis (PCA) on standardized predictors
#        • Scree plot + biplot
#   5. Linear regression model predicting quality
#        • Prints summary & diagnostic plot
#        • Scatter of fitted vs. actual
#   6. Saves each plot to PNG files wine-1.png … wine-8.png
#
# Dependencies:
#   - tidyverse (ggplot2, dplyr, tidyr, readr)
#   - GGally
#   - corrplot
#   - factoextra
#
# Usage:
#   1. Ensure R ≥ 4.0 is installed.
#   2. Run: source("Wine_Quality_Analysis.R")
# =================================================================================

# 0. Install & load packages
pkgs <- c("tidyverse","GGally","corrplot","factoextra")
for(pkg in pkgs){
  if(!requireNamespace(pkg, quietly=TRUE)) install.packages(pkg)
  library(pkg, character.only=TRUE)
}

# 1. URLs for the datasets
url_red   <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
url_white <- "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"

# 2. Read CSVs with explicit locale so decimals parse as “.”
wine_spec <- cols(
  `fixed acidity`        = col_double(),
  `volatile acidity`     = col_double(),
  `citric acid`          = col_double(),
  `residual sugar`       = col_double(),
  chlorides               = col_double(),
  `free sulfur dioxide`  = col_double(),
  `total sulfur dioxide` = col_double(),
  density                 = col_double(),
  pH                      = col_double(),
  sulphates               = col_double(),
  alcohol                 = col_double(),
  quality                 = col_integer()
)

red   <- read_delim(url_red,   delim=";", col_types=wine_spec, locale=locale(decimal_mark=".")) %>% mutate(type="red")
white <- read_delim(url_white, delim=";", col_types=wine_spec, locale=locale(decimal_mark=".")) %>% mutate(type="white")

# 3. Combine & basic cleaning
wine <- bind_rows(red, white) %>%
  mutate(
    type    = factor(type),
    quality = factor(quality, ordered=TRUE)
  )

cat("Total observations:", nrow(wine), "\n")
cat("Red / White counts:\n"); print(table(wine$type))

# 4. Distribution of quality by type
p1 <- ggplot(wine, aes(quality, fill=type)) +
  geom_bar(position="dodge") +
  labs(title="Wine Quality Counts by Type", x="Quality (score)", y="Count") +
  theme_minimal()
print(p1)
ggsave("wine-1.png", plot=p1, width=8, height=6)

# 5. Alcohol vs. Quality scatter
p2 <- ggplot(wine, aes(alcohol, quality, colour=type)) +
  geom_jitter(width=0, height=0.2, alpha=0.5) +
  labs(title="Alcohol Content vs. Quality", x="Alcohol (%)", y="Quality") +
  theme_minimal()
print(p2)
ggsave("wine-2.png", plot=p2, width=8, height=6)

# 6. Boxplots of key acids by quality
attrs <- c("pH","residual sugar","citric acid","sulphates")
p3 <- wine %>%
  pivot_longer(all_of(attrs), names_to="attribute", values_to="value") %>%
  ggplot(aes(quality, value, fill=quality)) +
  geom_boxplot() +
  facet_wrap(~attribute, scales="free_y") +
  labs(title="Chemical Attributes by Wine Quality") +
  theme_minimal() +
  theme(legend.position="none")
print(p3)
ggsave("wine-3.png", plot=p3, width=10, height=6)

# 7. Correlation heatmap (numeric vars only)
nums <- wine %>% select_if(is.numeric)
corr <- cor(nums, use="pairwise.complete.obs")
png("wine-4.png", width=800, height=600)
corrplot(corr, method="color", type="upper", tl.col="black", tl.cex=0.8,
         title="Correlation Matrix of Wine Attributes")
dev.off()

# 8. PCA on scaled numeric predictors
scaled <- scale(nums)
res.pca <- prcomp(scaled, center=TRUE, scale.=FALSE)

p5 <- fviz_screeplot(res.pca, addlabels=TRUE, title="PCA: Variance Explained")
print(p5)
ggsave("wine-5.png", plot=p5, width=8, height=6)

p6 <- fviz_pca_biplot(res.pca, repel=TRUE, title="PCA Biplot: Wines")
print(p6)
ggsave("wine-6.png", plot=p6, width=8, height=6)

# 9. Linear regression: Predicting quality (as numeric)
wine$num_quality <- as.numeric(as.character(wine$quality))
mod <- lm(num_quality ~ alcohol + sulphates + pH + type, data=wine)
cat("\n=== Regression Summary ===\n")
print(summary(mod))

png("wine-7.png", width=800, height=600)
plot(mod, which=1)  # Residuals vs Fitted
dev.off()

# 10. Fitted vs. actual plot
wine$fitted <- fitted(mod)
p4 <- ggplot(wine, aes(fitted, num_quality, colour=type)) +
  geom_jitter(alpha=0.4, height=0.1) +
  geom_abline(slope=1, intercept=0, linetype="dashed") +
  labs(title="Fitted vs. Actual Quality", x="Fitted quality", y="Actual quality") +
  theme_minimal()
print(p4)
ggsave("wine-8.png", plot=p4, width=8, height=6)

# =================================================================================
# End of Wine_Quality_Analysis.R
# =================================================================================
