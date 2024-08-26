library(duckdb)
library(data.table)
library(pool)


con <- dbPool(
    drv = duckdb(),
    dbdir = "api_duckdb/result/sturg-alert.duckdb",
    read_only = FALSE
)

poolClose(con)
#dbExecute(con, "DROP TABLE alerts")
#dbExecute(con,
#   "CREATE TABLE alerts (fish VARCHAR, time TIMESTAMP,
#       lat DECIMAL(7, 5), lon DECIMAL(7, 5))")

dbExecute(con, "INSERT INTO alerts VALUES (?, ?)",
    list("serge", Sys.time())
)

dbAppendTable(con, "alerts", data.table(fish = 'serge2', time = Sys.time(), lat = 38.12345, lon = -75.123))

dbGetQuery(con, "SELECT * FROM alerts")
