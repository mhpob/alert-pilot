# adapted from: https://hosting.analythium.io/how-to-set-up-quarto-with-docker-part-1-static-content/

# This image installs R (https://github.com/rocker-org/r2u/blob/master/noble/Dockerfile)
FROM rocker/r2u

# Install some dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    gdebi-core

# Install quarto
RUN wget https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb
RUN rm quarto-linux-amd64.deb

# Install needed packages
RUN R -e "install.packages(c('data.table', 'ggplot2', 'quarto', 'knitr', 'rmarkdown', 'plotly'))"

# RUN useradd obrien && \
#     adduser obrien users && \
#     usermod -aG sudo obrien

RUN mkdir input
# RUN chown obrien input
# RUN cd input && \
#     mkdir -m 777 html && \
#     cd ..
RUN mkdir -m 777 data

# USER obrien

# cd dashboard
# docker build -t dash .
# docker run --rm \
#   -v $PWD:/input \
#   -v $PWD/../result:/data \
#   -w /input \
#   dash \
#   quarto render index.qmd --output-dir html 

# docker run -it -v $PWD:/input -w /input dash
