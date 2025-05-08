#!/usr/bin/env python3
"""
Wine Quality Analysis
---------------------

A comprehensive Python script to fetch, analyze, and visualize the UCI Wine Quality
datasets (red & white) from the UCI Machine Learning Repository.

Features:
  1. Downloads both red and white wine CSVs via URL
  2. Merges into a single DataFrame with a “type” column
  3. Exploratory plots:
       • Distribution of quality by wine type
       • Scatter of alcohol vs. quality
       • Boxplots of key chemical attributes by quality
       • Correlation heatmap of numeric variables
  4. PCA on standardized predictors
       • Scree plot + biplot
  5. Linear regression model predicting quality
       • Prints summary & residuals vs fitted
       • Scatter of fitted vs. actual

Usage:
  $ python3 wine_quality_analysis.py

Dependencies:
  - pandas
  - numpy
  - matplotlib
  - seaborn
  - scikit-learn
  - statsmodels
"""

import os
import urllib.request
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
import statsmodels.api as sm

# 0. Ensure output directory exists
OUTDIR = "figures"
os.makedirs(OUTDIR, exist_ok=True)

# 1. URLs for the datasets
URL_RED   = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-red.csv"
URL_WHITE = "https://archive.ics.uci.edu/ml/machine-learning-databases/wine-quality/winequality-white.csv"

# 2. Read CSVs (semicolon-delimited)
red = pd.read_csv(URL_RED, sep=';', decimal='.')
red['type'] = 'red'

white = pd.read_csv(URL_WHITE, sep=';', decimal='.')
white['type'] = 'white'

# 3. Combine & basic cleaning
wine = pd.concat([red, white], ignore_index=True)
wine['quality'] = wine['quality'].astype(int)

print(f"Total observations: {len(wine)}")
print("Counts by type:\n", wine['type'].value_counts())

# 4. Distribution of quality by type
plt.figure(figsize=(8,5))
sns.countplot(data=wine, x='quality', hue='type')
plt.title("Wine Quality Counts by Type")
plt.xlabel("Quality Score")
plt.ylabel("Count")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/wine_quality_counts.png")
plt.show()

# 5. Alcohol vs. Quality scatter
plt.figure(figsize=(8,5))
sns.stripplot(data=wine, x='quality', y='alcohol', hue='type', jitter=True, alpha=0.5)
plt.title("Alcohol Content vs. Quality")
plt.xlabel("Quality Score")
plt.ylabel("Alcohol (%)")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/alcohol_vs_quality.png")
plt.show()

# 6. Boxplots of key chemical attributes by quality
attrs = ['pH','residual sugar','citric acid','sulphates']
wine_melt = wine.melt(id_vars=['quality'], value_vars=attrs,
                     var_name='attribute', value_name='value')
g = sns.catplot(data=wine_melt, x='quality', y='value',
                col='attribute', kind='box', col_wrap=2, sharey=False,
                height=4, aspect=1.2)
g.fig.subplots_adjust(top=0.9)
g.fig.suptitle("Chemical Attributes by Wine Quality")
for i, ax in enumerate(g.axes.flatten(), 1):
    ax.set_xlabel("Quality")
    ax.set_ylabel(attrs[i-1].title())
plt.savefig(f"{OUTDIR}/attributes_by_quality.png")
plt.show()

# 7. Correlation heatmap (numeric vars only)
numeric = wine.select_dtypes(include=np.number).drop(columns=['quality'])
corr = numeric.corr()
plt.figure(figsize=(10,8))
sns.heatmap(corr, annot=True, fmt=".2f", cmap='coolwarm', square=True)
plt.title("Correlation Matrix of Wine Attributes")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/correlation_heatmap.png")
plt.show()

# 8. PCA on scaled numeric predictors
scaler = StandardScaler()
X_scaled = scaler.fit_transform(numeric)
pca = PCA()
pca.fit(X_scaled)

# Scree plot
plt.figure(figsize=(6,4))
plt.plot(np.cumsum(pca.explained_variance_ratio_)*100, marker='o')
plt.xlabel('Number of Components')
plt.ylabel('Cumulative Explained Variance (%)')
plt.title("PCA Scree Plot")
plt.grid(True)
plt.tight_layout()
plt.savefig(f"{OUTDIR}/pca_scree.png")
plt.show()

# Biplot (first two PCs)
pcs = pca.transform(X_scaled)
plt.figure(figsize=(8,6))
plt.scatter(pcs[:,0], pcs[:,1], c=wine['quality'], cmap='viridis', alpha=0.5)
for i, feature in enumerate(numeric.columns):
    plt.arrow(0, 0, 
              pca.components_[0,i]*5,  # scale arrows
              pca.components_[1,i]*5,
              color='r', alpha=0.7)
    plt.text(pca.components_[0,i]*5.2, pca.components_[1,i]*5.2,
             feature, color='r', fontsize=8)
plt.xlabel('PC1')
plt.ylabel('PC2')
plt.title("PCA Biplot")
plt.grid(True)
plt.tight_layout()
plt.savefig(f"{OUTDIR}/pca_biplot.png")
plt.show()

# 9. Linear regression: Predicting quality
# Treat quality as numeric
wine['quality_num'] = wine['quality']
X = wine[['alcohol','sulphates','pH']]
X = pd.get_dummies(wine['type']).join(X)  # include type dummies
X = sm.add_constant(X)
y = wine['quality_num']

model = sm.OLS(y, X).fit()
print("\n=== Regression Summary ===\n")
print(model.summary())

# Residuals vs Fitted
plt.figure(figsize=(6,4))
plt.scatter(model.fittedvalues, model.resid, alpha=0.5)
plt.axhline(0, color='red', linestyle='--')
plt.xlabel("Fitted Values")
plt.ylabel("Residuals")
plt.title("Residuals vs Fitted")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/residuals_vs_fitted.png")
plt.show()

# 10. Fitted vs Actual
plt.figure(figsize=(6,4))
plt.scatter(model.fittedvalues, wine['quality_num'], alpha=0.5)
plt.plot([wine['quality_num'].min(), wine['quality_num'].max()],
         [wine['quality_num'].min(), wine['quality_num'].max()],
         'k--', lw=2)
plt.xlabel("Fitted Quality")
plt.ylabel("Actual Quality")
plt.title("Fitted vs Actual Quality")
plt.tight_layout()
plt.savefig(f"{OUTDIR}/fitted_vs_actual.png")
plt.show()
