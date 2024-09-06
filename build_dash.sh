# Currently run it this way since nginx can't use (copy?) files that are root
# Copy the files created by Docker in ./html (root) to ./_html (obrien)

docker compose -f /users/obrien/alert-pilot/dashboard/docker-compose.yaml up
cp -r /users/obrien/alert-pilot/dashboard/html/. /users/obrien/alert-pilot/dashboard/_html
