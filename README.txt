
docker build -t alert-pilot .


## run the image

docker run --name alert-pilot --rm -p 20619:8000 -w /app  \
    -v `pwd`/result:/app/result -v `pwd`/api.R:/app/api-pilot.R \
    alert-pilot 

# docker comes first, then run, then options
# then comes the image ("plumber")
# then commands.
# In this image, the "command" is the file in the container that should be plumbed.
# Since the wd in the container was specified to be /app via -w /app, the file to be plumbed is api.R


docker run -it --rm --entrypoint /bin/bash -w /app plumber_db 

curl -w '\n' http://localhost:20619/fls
curl -w '\n' http://localhost:20619/db
curl -w '\n' http://localhost:20619/ -d "fish=boi_pool"


# Copy a file from a docker container
https://docs.docker.com/reference/cli/docker/container/cp/