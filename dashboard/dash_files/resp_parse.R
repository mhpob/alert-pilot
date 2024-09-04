library(data.table)
raw_db <- fread('db.csv')
setnames(raw_db, c('sys_temp', 'resp', 'server_time'))


## Grab receiver
raw_db[, receiver := sub('\\*(\\d{6}).*', '\\1', resp)]

## Grab receiver time
grab_rec_date <- function(x){
  res <- sub(".*?(.{4}-..-.. ..:..:..).*", '\\1', x)
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
raw_db[, let(
  X = sub('.*XYZ=([^:]*).*', '\\1', resp),
  Y = sub('.*:(.*):.*', '\\1', resp),
  Z = sub('.*:.*:([^,]*).*', '\\1', resp)
)]
raw_db[, let(
  X = ifelse(grepl('^\\*', X), NA, X),
  Y = ifelse(grepl('^\\*', Y), NA, Y),
  Z = ifelse(grepl('^\\*', Z), NA, Z)
)]

raw_db[, cpu_temp := as.numeric(sub(".*temp=(.*)'C", '\\1', sys_temp))]
raw_db[, cpu_time := as.POSIXct(sub(' temp.*', '', sys_temp), tz = 'UTC')]

# fwrite(raw_db, 'dash/db_parsed.csv')