FROM ubuntu:22.10
RUN apt-get update -y && apt-get install -y python3
RUN /usr/sbin/useradd --no-create-home -u 1337 user
COPY FLAG main.py entrypoint.sh /home/user/