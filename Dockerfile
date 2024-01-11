FROM rocker/r-ver:4
RUN R -e "install.packages(c('dplyr','stringr','rvest'))"
WORKDIR /home/stg4_scraper_r
COPY rtma_scraper.R rtma_scraper.R
CMD Rscript rtma_scraper.R