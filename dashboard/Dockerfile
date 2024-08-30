# adapted from: https://hosting.analythium.io/how-to-set-up-quarto-with-docker-part-1-static-content/

# This image installs R (https://github.com/rocker-org/r2u/blob/master/noble/Dockerfile)
FROM rocker/r2u

# Install needed packages
RUN R -e "install.packages(c('data.table', 'ggplot2'))"

# Install some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    gdebi-core

# Install quarto
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb
RUN rm quarto-linux-amd64.deb

# Copy in DB
RUN mkdir files && \
    cd files && \
    R -e "source('resp_parse.R')"

# need to write to /html (link this volume!)
RUN mkdir html
RUN quarto render dashboard/index.qmd --output-dir html