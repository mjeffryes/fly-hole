FROM pihole/pihole:latest

# Debug / network tooling (image is Alpine-based as of Pi-hole v6)
RUN apk add --no-cache socat net-tools tcpdump tmux strace htop iperf

# Keep our wrapper off PATH's start.sh so we do not clobber /usr/bin/start.sh
COPY start.sh /fly-start.sh
RUN chmod +x /fly-start.sh

ENTRYPOINT ["/bin/bash", "/fly-start.sh"]
