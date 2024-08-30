#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
n_det=as.numeric(args[1])

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

write.serialConnection(vr2c_con, '')
Sys.sleep(0.1)

write.serialConnection(vr2c_con, '*450281.0#20,READBEG')
Sys.sleep(0.3)
read.serialConnection(vr2c_con)
Sys.sleep(0.3)

resp=NULL

for(i in 1:n_det){
  write.serialConnection(vr2c_con, '*450281.0#20,READREC')
  Sys.sleep(0.3)
  resp[i]=read.serialConnection(vr2c_con)
  Sys.sleep(0.3)
  write.serialConnection(vr2c_con, '*450281.0#20,READACK')
  Sys.sleep(0.3)
  read.serialConnection(vr2c_con)
  Sys.sleep(0.3)
}

write.serialConnection(vr2c_con, '*450281.0#20,READEND')
Sys.sleep(0.3)
write.serialConnection(vr2c_con, '*450281.0#20,QUIT')
close(vr2c_con)

cat(resp,file="retrieved.log",sep='\n')


## POST ###
library(httr2)

req <- request('https://alert-pilot.obrien.page/detection_retrieval') |> 
    req_headers("Accept" = "application/json") |> 
    req_body_json(
       list(
        detections = resp
       ) 
    ) |> 
    req_retry(max_tries = 5) |> 
    req_method('POST')

api_resp <- req_perform(req)

cat(paste(api_resp |> resp_status_desc(), '\n'))
