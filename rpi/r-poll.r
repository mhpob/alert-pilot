suppressPackageStartupMessages(
    suppressWarnings(
        library(serial)
    )
)

vr2c_con <- serialConnection(
    port = 'seacom',
    mode = '9600,n,8,1',
    buffering = 'line',
    newline = 1,
    handshake = 'none',
    translation = 'crlf'
)
open(vr2c_con)

write.serialConnection(vr2c_con, '*450281.0#20')
Sys.sleep(0.5)
flush(vr2c_con)


write.serialConnection(vr2c_con, '*450281.0#20,RTMNOW')
Sys.sleep(0.5)
resp <- read.serialConnection(vr2c_con)
iter <- 1

while(!grepl('>$', resp)){
  resp <- paste(resp, read.serialConnection(vr2c_con), sep = '\n')
  
  if (iter >= 15) break
  
  iter <- iter + 1
}

write.serialConnection(vr2c_con, '*450281.0#20,QUIT')

close(vr2c_con)

cat(
  resp,
  file = "detection.log",
  append = TRUE
)

# System temperature
sys_temp <- paste(
    as.POSIXlt(Sys.time(), tz = 'UTC'),
    system2(
        'vcgencmd',
        'measure_temp',
        stdout = TRUE
    )
)

cat(
    paste0(sys_temp, "\n"),
    file = "sys_temp.log",
    append = TRUE
)

cat(
    paste(
        sys_temp,
        resp,
        sep = ';'
    ),
    file = "export.log",
    append  = TRUE
)



## POST ###
library(httr2)

req <- request('https://alert-pilot.obrien.page/') |> 
    req_headers("Accept" = "application/json") |> 
    req_body_json(
       list(
        sys_temp = sys_temp,
        det_log = resp
       ) 
    ) |> 
    req_retry(max_tries = 5) |> 
    req_method('POST')

api_resp <- req_perform(req)

cat(paste(api_resp |> resp_status_desc(), '\n'))
