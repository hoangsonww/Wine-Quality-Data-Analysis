# Use the official R image as base
FROM r-base:4.2.2

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libxml2-dev libssl-dev libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('tidyverse','GGally','corrplot','factoextra','rmarkdown'), repos='https://cloud.r-project.org/')"

# Copy project files
WORKDIR /home/wine_analysis
COPY . .

# Expose a volume for results
VOLUME /home/wine_analysis/output

# Default command: run the Makefile default target
CMD ["make", "all"]
