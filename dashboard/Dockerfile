# adapted from: https://hosting.analythium.io/how-to-set-up-quarto-with-docker-part-1-static-content/

# This image installs R (https://github.com/rocker-org/r2u/blob/master/noble/Dockerfile)
FROM rhub/r-minimal

# Install some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    gdebi-core

# Install quarto
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN dpkg quarto-linux-amd64.deb
RUN rm quarto-linux-amd64.deb

# Install needed packages
RUN R -e "install.packages(c('data.table', 'ggplot2', 'quarto', 'knitr', 'rmarkdown'))"

# docker build -t dashboard .
# docker run --rm -v $PWD/dash_files:/input \
#   -w /input \
#   dash \
#   quarto render sturgeon-alert-dashboard.qmd