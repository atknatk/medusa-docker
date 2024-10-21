#!/usr/bin/expect -f

spawn create-medusa-app medusa --no-browser "yes" --skip-db "yes" --with-nextjs-starter "no"
expect "What's the name of your project?"
send "medusa-app\r"
interact

