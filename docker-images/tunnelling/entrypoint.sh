#!/bin/bash

# sets the following configurations that make for a pickier, and easier to debug shell:
# * Prints out command arguments during execution.
# * Treats unset or undefined variables as an error when substituting.
# * Instructs a shell to exit if a command fails.
# * Causes shell functions to inherit the ERR trap.
# * The return value of a pipeline is the status of the last command that had a non-zero status upon exit.
set -o xtrace -o nounset -o errexit	-o errtrace -o pipefail
# mount the userspace proc
mount -t proc none /.jailproc/proc
# mount the jail tmpfs we will be using for each jail filesystem
mount -t tmpfs jailtmp /jail/tmp

# use socat to spin up a new, isolated nsjail for each incoming TCP connection
socat TCP-LISTEN:22,reuseaddr,fork EXEC:"/bin/bash /home/user/socat_entrypoint.sh"
