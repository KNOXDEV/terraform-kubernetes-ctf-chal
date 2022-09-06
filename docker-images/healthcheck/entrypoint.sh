#!/bin/bash

# drop privs and execute the healthcheck webserver
exec setpriv --init-groups --reset-env --reuid user --regid user --inh-caps=-all -- \
python3 /home/user/healthcheck_server.py