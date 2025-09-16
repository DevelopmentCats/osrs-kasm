# Old School RuneScape - Kasm App

Launch Old School RuneScape directly through your browser via Bolt Launcher. Clean, app-like experience with automatic authentication and fullscreen gaming.

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

**Workflow:**
1. Container launches directly into Bolt Launcher
2. Login with your Jagex account credentials
3. Select your preferred client (RuneLite, OSRS, HDOS, etc.)
4. Game automatically goes fullscreen

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
      - ./bolt-config:/home/kasm-user/.var/app/com.adamcake.Bolt
    mem_limit: 5g
    shm_size: 1g
    restart: unless-stopped
```

## Performance Mode

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

- App-like experience launching directly into OSRS
- Native Linux launcher via Bolt
- Official Jagex account compatibility
- Multi-client support (RuneLite, OSRS, HDOS)
- Smart fullscreen detection
- Gaming performance optimizations
- Persistent settings

## Memory Usage

- Basic usage: ~1-2GB (vanilla client)
- With plugins: ~2-4GB (GPU, HD, utilities)
- Heavy plugins: ~4-5GB (multiple HD plugins)

## System Requirements

- RAM: 5GB container limit (uses 1-4GB dynamically)
- CPU: 2+ cores recommended
- GPU: Modern GPU with OpenGL 4.3+ for GPU plugin
- Internet: Required for authentication

## Volume Mounts

```bash
-v ./runelite-config:/home/kasm-user/.runelite
-v ./jagex-config:/home/kasm-user/.jagex
-v ./bolt-config:/home/kasm-user/.var/app/com.adamcake.Bolt
```

## Troubleshooting

**Container not loading**: Ensure port 6901 is accessible  
**Bolt Launcher issues**: Verify internet connectivity  
**Game not fullscreen**: Wait a few seconds for auto-detection  
**Performance**: Increase memory to 6GB for heavy plugins  
**Logs**: `docker logs osrs-kasm`

## Supported Clients

- RuneLite
- Official OSRS
- HDOS
- Other Jagex-compatible clients

## Disclaimer

Uses Bolt Launcher (third-party software by [Adamcake](https://github.com/Adamcake/Bolt)) and RuneLite. Not affiliated with Jagex Ltd. Users responsible for ToS compliance.