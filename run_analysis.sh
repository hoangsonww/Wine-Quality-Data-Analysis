#!/usr/bin/env bash
# run_analysis.sh — downloads data, runs analysis and builds report

set -euo pipefail

echo "1. Running data download & analysis..."
Rscript -e "source('Wine_Quality_Analysis.R')"

echo "2. Rendering RMarkdown report..."
Rscript -e "rmarkdown::render('Wine_Quality_Analysis.Rmd', output_dir='output')"

echo "Done. All outputs are in the ./output directory."
