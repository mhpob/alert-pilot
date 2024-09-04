echo 0c52 a021 > /sys/bus/usb-serial/drivers/ftdi_sio/new_id

# https://superuser.com/questions/685471/how-can-i-run-a-command-after-boot
# change permissions (chmod 755 add_seacom_driver.sh)
# switch to root (sudo su)
# open crontab (crontab -e)
# add reboot command (@reboot /home/secor/alert/add_seacom_driver.sh)