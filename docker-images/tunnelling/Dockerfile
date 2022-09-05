# in this jail, we have to make some modifications to the vanilla challenge image,
# so there are some additional assumptions about its structure.
# See README for more details.
ARG CHALLENGE_IMAGE
FROM $CHALLENGE_IMAGE as chal
RUN apt update && apt install -y --no-install-recommends socat openssh-server && rm -rf /var/lib/apt/lists/*

# configure sshd for running in usermode
RUN mkdir /opt/ssh
RUN ssh-keygen -q -N "" -t rsa -b 4096 -f /opt/ssh/ssh_host_rsa_key &&\
    ssh-keygen -q -N "" -t ecdsa -f /opt/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t ed25519 -f /opt/ssh/ssh_host_ed25519_key
COPY sshd_config sshd_banner /opt/ssh/

# make sure the user account owns the ssh server and the home directory
RUN chown -R user:user /opt/ssh/
RUN chown -R user:user /home/user/

# this seems very scetch but unfortunately its required so that sshd can access /etc/shadow despite being in user mode
# there should be no risk since there's no logins allowed anyways
RUN chown user:user /etc/shadow && chmod o+r /etc/shadow

# we allow passwordless authentication via ssh, but don't allow the user to call a shell
# along with other config, in practice, this limits the user to port forwarding
RUN chsh --shell /usr/sbin/nologin user
RUN passwd -d user

# we hook the original entrypoint with our own that boots sshd and
# exposes it as the primary service
RUN mv /home/user/entrypoint.sh /home/user/orig_entrypoint.sh
COPY jail_entrypoint.sh /home/user/entrypoint.sh

FROM ubuntu:22.10
ARG CPU_LIMIT
ARG MEM_LIMIT
ARG PID_LIMIT
RUN apt update && apt install -y --no-install-recommends socat uidmap && rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/useradd --no-create-home -u 1337 user

# copy over nsjail and its runtime dependencies
COPY --from=nsjail:latest /usr/bin/nsjail /usr/bin/nsjail
COPY --from=nsjail:latest \
    /usr/lib/*-linux-gnu/libprotobuf.so.23 \
    /usr/lib/*-linux-gnu/libnl-3.so.200 \
    /usr/lib/*-linux-gnu/libnl-route-3.so.200 \
    /lib/

# future path for a new proc to mount into the user namespace later
RUN mkdir -p /.jailproc/proc
RUN chmod 0700 /.jailproc
RUN mkdir -p /jail/tmp

# copy the challenge over as a chroot environment
COPY --from=chal / /chroot

# copy over the config and entrypoint
COPY nsjail.cfg entrypoint.sh socat_entrypoint.sh /home/user/
# set nsjail limits according to build args
RUN printf '\n%s' \
    "cgroup_mem_max: $MEM_LIMIT" \
    "cgroup_pids_max: $PID_LIMIT" \
    "time_limit: $CPU_LIMIT" \
    >> nsjail.cfg

EXPOSE 1337
ENTRYPOINT ["/home/user/entrypoint.sh"]