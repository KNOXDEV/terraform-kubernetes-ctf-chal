#!/bin/sh

# run the original entrypoint.sh
/home/user/orig_entrypoint.sh &

# kick off sshd running in usermode
/usr/sbin/sshd -f /opt/ssh/sshd_config -E /tmp/sshd.log
# sleeping for just a second is usually enough for sshd to be ready
sleep 1s

# connect to the sshd daemon running on an unprivileged port
socat STDIO TCP:127.0.0.1:2022,forever