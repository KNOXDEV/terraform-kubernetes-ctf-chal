FROM ubuntu:22.10

RUN apt update &&\
    apt install -y --no-install-recommends python3 python3-pip &&\
    rm -rf /var/lib/apt/lists/*

RUN /usr/sbin/useradd --no-create-home -u 1337 user
COPY entrypoint.sh healthcheck_server.py requirements.txt /home/user/
RUN python3 -m pip install -r /home/user/requirements.txt

# ensure pwntools does not try to update
RUN mkdir -p /home/user/.pwntools-cache && echo never > /home/user/.pwntools-cache/update

EXPOSE 21337
ENTRYPOINT ["/home/user/entrypoint.sh"]