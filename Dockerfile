FROM rocker/r-ver:4.2.2
RUN R -e "install.packages(c('dplyr','stringr','rvest'))"
WORKDIR /home/stg4_scraper_r
COPY stg4_scraper.R stg4_scraper.R
CMD Rscript stg4_scraper.R