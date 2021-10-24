# Storyline: Send an email

# Body of the email

# Variable can have an underscore or any alphanumeric value
$msg = "Hello There."

#echoing to the screen
write-host -BackgroundColor Red -ForegroundColor White $msg

# Email from address
$email = "richard.dennis@mymail.champlain.edu"

# To address
$toemail = "deployer@csi-web"

# Send the email
Send-MailMessage -From $email -To $toemail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71
