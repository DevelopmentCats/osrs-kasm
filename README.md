# Old School RuneScape - Kasm App

Launch Old School RuneScape directly through your browser via Jagex Launcher. Clean, app-like experience with automatic authentication and fullscreen gaming.

## Quick Start

```bash
docker run -d \
  --name osrs-kasm \
  -p 6901:6901 \
  --shm-size=1g \
  --memory=5g \
  ghcr.io/developmentcats/osrs-kasm:latest
```

Access at: `http://localhost:6901`

**Simple Workflow:**
1. Container launches directly into Jagex Launcher
2. Login with your Jagex account credentials
3. Select your preferred client (RuneLite/OSRS)
4. Game automatically goes fullscreen - start playing!

## Docker Compose

```yaml
version: '3.8'
services:
  osrs-kasm:
    image: ghcr.io/developmentcats/osrs-kasm:latest
    container_name: osrs-kasm
    ports:
      - "6901:6901"
    volumes:
      - ./runelite-config:/home/kasm-user/.runelite
      - ./jagex-config:/home/kasm-user/.jagex
    mem_limit: 5g
    shm_size: 1g
    restart: unless-stopped
```

## Performance Mode (Optional)

For enhanced performance with network/I/O optimizations:

```bash
docker run -d \
  --name osrs-kasm \
  -p 6901:6901 \
  --shm-size=1g \
  --memory=6g \
  --privileged \
  ghcr.io/developmentcats/osrs-kasm:latest
```

## Features

- **🎮 App-Like Experience** - Launches directly into OSRS, not a desktop environment
- **🚀 Official Authentication** - Uses Jagex Launcher for secure account access
- **🔄 Multi-Client Support** - Choose RuneLite, official OSRS client, or others
- **🖥️ Smart Fullscreen** - Automatically maximizes game (ignores small patcher windows)
- **⚡ Gaming Optimized** - GPU acceleration, performance tuning, clean interface
- **💾 Persistent Settings** - Your game settings and launcher preferences are saved

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

## How It Works

This container provides a clean, app-focused OSRS experience:

1. **Direct Launch** - Container starts immediately with Jagex Launcher (no desktop clutter)
2. **Authentication** - Login with your Jagex account for official access
3. **Client Selection** - Choose your preferred OSRS client in the launcher
4. **Auto-Gaming Mode** - Game windows automatically go fullscreen for immersive play
5. **Background Management** - System handles technical details (window sizing, performance) automatically

## Troubleshooting

**Container not loading**: Ensure port 6901 is accessible
**Jagex Launcher issues**: Verify internet connectivity
**Game not fullscreen**: Wait a few seconds for auto-detection
**Performance**: Increase memory to 6GB for heavy plugin usage
**Logs**: `docker logs osrs-kasm`

## Disclaimer

Not affiliated with Jagex Ltd. RuneLite is a third-party client. Users responsible for ToS compliance.