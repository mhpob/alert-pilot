#
# This is a Plumber API. You can run the API by clicking
# the 'Run API' button above.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(data.table)
library(duckdb)
library(pool)

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.

pool <- dbPool(
  duckdb(),
  dbdir = "result/sturg-alert.duckdb",
  read_only = FALSE
)

#* @get /db
#* @serializer print
function() {
  con <- localCheckout(pool)
  res <- dbGetQuery(con, "SELECT * FROM alerts")
  
  res
}

#* @post /
#* @serializer cat
function(fish = 'unknown') {
  payload <- as.data.table(fish)
  payload[, let(
    time = Sys.time(),
    lat = rnorm(1, 38.52816),
    lon = rnorm(1, -75.75469)
  )]

  con <- localCheckout(pool)
  dbAppendTable(con, "alerts", payload)
  
  # # add something to send email? Or maybe use GHA to send digest?
  # system("curl --ssl-reqd \
  # --url 'smtps://smtp.gmail.com:465' \
  # --user 'username@gmail.com:password' \
  # --mail-from 'username@gmail.com' \
  # --mail-rcpt 'john@example.com' \
  # --upload-file mail.txt")



  paste0('Detection of ', payload$fish, ' logged at ', payload$time)
  
}


#* @get /fls
function() {
  list(
    fls = list.files(),
    res = list.files("result")
  )
}