#!/usr/bin/expect -f

set timeout -1

# Fetch the environment variable using exec getenv
set db_url [exec sh -c {echo $DATABASE_URL}]

# Use the full path to the globally installed create-medusa-app binary
set create_medusa_path "/usr/local/bin/create-medusa-app"

# Run create-medusa-app and automate the prompts
spawn $create_medusa_path medusa-app --no-browser --db-url $db_url --with-nextjs-starter no

# Provide the project name when prompted
expect "What's the name of your project?"
send "medusa-app\r"

# Provide the email for the admin dashboard when prompted
expect "Enter an email for your admin dashboard user"
send "admin@medusa-test.com\r"

# Allow the process to continue and finish
interact
