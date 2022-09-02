#!/bin/bash

# on each connection, we need to create an overlayfs for nsjail to mount to
TEMP_DIR=$(mktemp -d -p "/jail/tmp")
mkdir "$TEMP_DIR/upper" "$TEMP_DIR/work" "$TEMP_DIR/fs"
# this step is necessary to allow nsjail to mount the overlay once we drop privs
chmod -R o+x "$TEMP_DIR"
mount -t overlay overlay -o "lowerdir=/chroot,upperdir=$TEMP_DIR/upper,workdir=$TEMP_DIR/work" "$TEMP_DIR/fs"

# do not allow the child process to inherit any privileges and set uid and gid
# we also mount an overlayfs on chroot to allow for some filesystem shenanigans
setpriv --init-groups --reset-env --reuid 1337 --regid 1337 --inh-caps="-all" -- \
nsjail --config /home/user/nsjail.cfg --chroot "$TEMP_DIR/fs" --rw -- /bin/bash /home/user/entrypoint.sh

# delete when done
umount "$TEMP_DIR/fs"
rm -rf "$TEMP_DIR"