FROM rocker/r-ver

RUN mkdir app && \
    cd app && \
    mkdir result

RUN R -e "install.packages(c('data.table', 'plumber'))"

EXPOSE 8000

ENTRYPOINT ["R", \
            "-e", \
            "plumber::pr('api.R') |> \
            plumber::pr_hook('exit', function(){print('Bye, bye!')}) |> \
            plumber::pr_run(host = '0.0.0.0', port = 8000)"]