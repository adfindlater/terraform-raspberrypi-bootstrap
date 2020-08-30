# Terraform Variables
# Customize parameters in this file specific to your deployment.
# Current & new passwords can be supplied here, but safer to supply variables inline when applying config:
# terraform apply -var 'password=PASSWORD' -var 'new_password=NEWPASS'

# CONNECTION PARAMETERS
username = "ubuntu"
password = "password"

# Validate timezone correctness against 'timedatectl list-timezones' 
timezone = "America/New_York"
