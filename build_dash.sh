# Currently run it this way since nginx can't use (copy?) files that are root
# Copy the files created by Docker in ./html (root) to ./_html (obrien)

docker compose -f /users/obrien/alert-pilot/dashboard/docker-compose.yaml up

cp -rf /users/obrien/alert-pilot/dashboard/html/. /users/obrien/alert-pilot/dashboard/_html

dc_now=$(tail -n 1 result/db.csv | sed -n 's/.*DC=\(.*\),PC.*/\1/p')
dc_then=$(tail -n 2 result/db.csv | head -n 1 | sed -n 's/.*DC=\(.*\),PC.*/\1/p')

if [ "$dc_now" -gt "$dc_then" ]; then
  curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"Sturgeon detected! Current count: '"$dc_now"'"}' \
  $(cat secrets)
fi