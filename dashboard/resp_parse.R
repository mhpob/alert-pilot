library(data.table)
raw_db <- fread('/data/db.csv')
setnames(raw_db, c('sys_temp', 'resp', 'server_time'))


## Grab receiver
raw_db[, receiver := sub('\\*(\\d{6}).*', '\\1', resp)]

## Grab receiver time
grab_rec_date <- function(x){
  res <- sub(".*?(.{4}-..-.. ..:..:..),STS.*", '\\1', x)
  ifelse(grepl('^\\*|\\|', res), NA, res)
}
raw_db[, receiver_time := grab_rec_date(resp)]
raw_db[, receiver_time := as.POSIXct(receiver_time, tz = 'UTC')]

## Grab data
grab_numeric_data <- function(data, var_imp) {
  res <- sub(
    paste0('.*', var_imp, '=([^,]*).*'),
    '\\1',
    data
  )
  res <- as.numeric(res)
  
  ifelse(grepl('^\\*', res), NA, res)
}
vars <- c('DC', 'PC', 'LV', 'BV', 'BU', 'I', 'T', 'DU', 'RU')
raw_db[, (vars) := lapply(vars, function(.) grab_numeric_data(resp, .))]


## Handle XYZ
tilt <- sub('.*XYZ=([^,]*).*', '\\1', raw_db$resp)
tilt <- ifelse(grepl("^[\\*\\|]", tilt), NA, tilt)

raw_db[, let(
  X = sub('^([^:]*).*', '\\1', tilt),
  Y = sub('.*:(.*):.*', '\\1', tilt),
  Z = sub('.*:(.*)$', '\\1', tilt)
)]


## Grap RPi temperature and time
raw_db[, cpu_temp := as.numeric(sub(".*temp=(.*)'C", '\\1', sys_temp))]
raw_db[, cpu_time := as.POSIXct(sub(' temp.*', '', sys_temp), tz = 'UTC')]


## Parse detections
raw_db[
  grepl(
    "#..\\d{6},\\d+,\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2},.*-.*,\\d+,#..",
    resp
  ),
  detections :=
    lapply(
      strsplit(resp, "#"),
      function(.) {
        .[ { gregexpr(",", text = .) |> sapply(length) } == 5]
      }
    ) |>
    sapply(function(.) gsub("^..", "", .)) |>
    lapply(function(.) {
      fread(
        text = .,
        col.names = c("receiver", "rec_seq", "datetimeutc",
                      "codespace", "tag", "sensor"),
        colClasses = 'character'
      )
    }
    ) |>
    as.character()
]
fwrite(raw_db, '/data/db_parsed.csv')