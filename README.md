# OSRS RuneLite Kasm

Performance-optimized RuneLite container with automatic fullscreen mode and gaming optimizations.

## Quick Start

```bash
docker run -d \
  --name osrs-runelite \
  -p 6901:6901 \
  --shm-size=1g \
  --memory=5g \
  ghcr.io/developmentcats/osrs-runelite-kasm:latest
```

Access at: `http://localhost:6901`

RuneLite launches automatically in fullscreen mode after ~8 seconds.

## Docker Compose

```yaml
version: '3.8'
services:
  osrs-runelite:
    image: ghcr.io/developmentcats/osrs-runelite-kasm:latest
    container_name: osrs-runelite
    ports:
      - "6901:6901"
    volumes:
      - ./runelite-config:/home/kasm-user/.runelite
    mem_limit: 5g
    shm_size: 1g
    restart: unless-stopped
```

## Performance Mode (Optional)

For enhanced performance with network/I/O optimizations:

```bash
docker run -d \
  --name osrs-runelite \
  -p 6901:6901 \
  --shm-size=1g \
  --memory=6g \
  --privileged \
  ghcr.io/developmentcats/osrs-runelite-kasm:latest
```

## Features

- **Automatic fullscreen** - No desktop distractions
- **Smart memory usage** - Starts low, scales up for plugins
- **Plugin ready** - Supports GPU, HD, and other popular plugins
- **Persistent storage** - Mount volume to preserve settings
- **Mouse auto-hide** - Cursor disappears when inactive

## Memory Usage

RuneLite uses **dynamic memory allocation**:
- **Basic usage**: ~1-2GB (vanilla client)
- **With plugins**: ~2-4GB (GPU, HD, utilities)
- **Heavy plugins**: ~4-5GB (multiple HD plugins)

The container allocates memory as needed rather than consuming it all upfront.

## System Requirements

- **RAM**: 5GB container limit (uses 1-4GB dynamically)
- **CPU**: 2+ cores recommended for smooth plugin performance
- **GPU**: Modern GPU with OpenGL 4.3+ for GPU plugin

## Troubleshooting

**Not fullscreen**: Wait 10-15 seconds after container start
**Plugin performance**: Ensure adequate memory limit (5-6GB)
**Logs**: `docker logs osrs-runelite`

## Disclaimer

Not affiliated with Jagex Ltd. RuneLite is a third-party client. Users responsible for ToS compliance.