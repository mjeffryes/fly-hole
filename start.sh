#!/bin/bash
set -exuo pipefail

# Persist Pi-hole state on the Fly volume. Official image entrypoint lives at
# /usr/bin/start.sh (v6+); we only own volume wiring, then hand off.
VOLUMIZED_DIRS=("/etc/pihole" "/etc/dnsmasq.d")

for dir in "${VOLUMIZED_DIRS[@]}"; do
    target_in_volume="$PH_VOLUME$dir"

    if [ ! -d "$target_in_volume" ]; then
        mkdir -p "$(dirname "$target_in_volume")"
        # move existing dir if present, otherwise create an empty directory
        if [ -e "$dir" ]; then
          mv "$dir" "$target_in_volume"
        else
          mkdir -p "$target_in_volume"
        fi
    else
        rm -rf "$dir"
    fi

    ln -s "$target_in_volume" "$dir"
done

# Pi-hole v6 no longer uses s6; run the image's real entrypoint and keep it as PID 1.
exec /usr/bin/start.sh
