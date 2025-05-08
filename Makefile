# Makefile for Wine Quality Analysis

.PHONY: all data analysis report clean

all: data analysis report

# Download and prepare data
data:
	Rscript -e "source('Wine_Quality_Analysis.R')" 

# Run the R analysis script (generates plots and prints summary)
analysis: data
	Rscript -e "source('Wine_Quality_Analysis.R')"

# Knit the RMarkdown report
report:
	Rscript -e "rmarkdown::render('Wine_Quality_Analysis.Rmd')"

# Clean up generated files
clean:
	rm -f *.pdf *.html *.png
