#bin/bash
set password ''
set user ''
set host ''
set answer ''

openconnect

expect 'Password'
send'$password\n'
interace
