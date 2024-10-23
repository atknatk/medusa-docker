#!/usr/bin/expect -f

npm i -g create-medusa-app@2.0.0 
spawn create-medusa-app --no-browser "yes" --skip-db "yes"
expect "What's the name of your project?"
send "medusa-app\r"
interact

