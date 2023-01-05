FROM ubuntu:20.04

WORKDIR /root/

RUN apt update && apt -y upgrade
RUN apt install -y curl tmux sudo python3 python3-pip git locales
RUN rm -rf /var/lib/apt/lists/*

COPY md2_mod.sh /root/
RUN chmod +x /root/md2_mod.sh

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

ENTRYPOINT ["bash","/root/md2_mod.sh"]
