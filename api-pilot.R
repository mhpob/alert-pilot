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

#* @apiTitle Plumber Example API
#* @apiDescription Plumber example description.


#* @post /
#* @serializer cat
function(req) {

   payload <- req$argsBody
  
  if (length(payload) > 2) {
    stop("Dont do this.")
  }
  
  if (!all(names(payload) == c("sys_temp", "det_log"))) {
    stop("Dont do this.")
  }
  
  payload <- as.data.table(payload)
  payload[, det_log := gsub("[\r\n]", "|", det_log)]
  payload[, creation_time := Sys.time()]
  
  fwrite(payload, 'result/db.csv', append = TRUE)
  
  paste0('Success at ', payload$creation_time)

  
}

#* @get /mic-check
#* @serializer cat
function(){
  paste0('Mic check, Mic check:', Sys.time())
}

#* @get /mic-check-vr2c
#* @serializer print
function(){
  fread(cmd = 'tail -20 result/db.csv') |>
  print()
}


#* @post /detection_retrieval
#* @serializer cat
function(req) {

   payload <- req$argsBody
  
  if (length(payload) > 1) {
    stop("Dont do this.")
  }
  
  if (!all(names(payload) == c("detections"))) {
    stop("Dont do this.")
  }
  
  payload <- as.data.table(payload)
  payload[, detections := gsub("[\r\n]", "|", detections)]
  
  fwrite(payload, 'result/detections.csv', append = TRUE)
  
  paste0('Success at ', Sys.time())  
}