ARG CHALLENGE_IMAGE
FROM $CHALLENGE_IMAGE as chal

FROM ubuntu:22.10
ARG CPU_LIMIT
ARG MEM_LIMIT
ARG PID_LIMIT
RUN apt update && apt install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
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

# copy the challenge over as a chroot environment
COPY --from=chal / /chroot

# copy over the config and entrypoint
COPY nsjail.cfg entrypoint.sh /home/user/
# set nsjail limits according to build args
RUN printf '\n%s' \
    "cgroup_mem_max: $MEM_LIMIT" \
    "cgroup_pids_max: $PID_LIMIT" \
    "time_limit: $CPU_LIMIT" \
    >> nsjail.cfg

EXPOSE 1337
ENTRYPOINT ["/home/user/entrypoint.sh"]