# OSRS Runelite Kasm

A lightweight Docker container for running Runelite (Old School RuneScape client) directly in your browser using KasmVNC. This container provides a minimal, secure environment for running Runelite with all necessary dependencies.

## Features

- **Browser-based Access**: Play OSRS through Runelite from any device with a web browser
- **Pre-installed Runelite**: Latest Runelite client ready to use
- **Minimal Footprint**: Optimized container with only essential dependencies
- **Persistent Storage**: Support for preserving settings and configurations between sessions
- **Automated Updates**: Automatically updated when new Runelite versions are released

## Quick Start

Run the container:

```bash
docker run -d \
  --name osrs-runelite \
  -p 6901:6901 \
  ghcr.io/developmentcats/osrs-runelite-kasm:latest
```

Access Runelite by opening your web browser and navigating to `http://localhost:6901`

## Persistent Storage

To preserve your Runelite settings and configurations between container restarts:

```bash
docker run -d \
  --name osrs-runelite \
  -p 6901:6901 \
  -v ./runelite-config:/config/.runelite \
  ghcr.io/developmentcats/osrs-runelite-kasm:latest
```

## Docker Compose

Create a `docker-compose.yml` file for easier management:

```yaml
version: '3.8'
services:
  osrs-runelite:
    image: ghcr.io/developmentcats/osrs-runelite-kasm:latest
    container_name: osrs-runelite
    ports:
      - "6901:6901"
    volumes:
      - ./runelite-config:/config/.runelite
    restart: unless-stopped
```

Run with: `docker-compose up -d`

## Troubleshooting

If you encounter issues:

1. Check the container logs: `docker logs osrs-runelite`
2. Verify your Docker installation is up to date
3. Ensure sufficient system resources (RAM, CPU)
4. Try pulling the latest image: `docker pull ghcr.io/developmentcats/osrs-runelite-kasm:latest`

### Common Issues

- **Runelite won't start**: Check container logs and ensure Java is properly installed
- **Settings not persisting**: Make sure you're using volume mounts for persistent storage
- **Connection issues**: Verify the container is running with `docker ps` and check port mapping

## Version Information

This container is automatically updated to use the latest version of Runelite. The container image is rebuilt whenever a new Runelite release is detected.

- **Base Image**: kasmweb/core-ubuntu-jammy:1.17.0
- **Java Runtime**: OpenJDK 11 JRE
- **Runelite**: Latest stable release from [Runelite GitHub](https://github.com/runelite/launcher)

## Building from Source

To build the image locally:

```bash
git clone https://github.com/developmentcats/osrs-runelite-kasm.git
cd osrs-runelite-kasm
docker build -t osrs-runelite-kasm .
```

## Legal Notice and Licensing

### Project License

This project is licensed under the MIT License. See the LICENSE file for details.

### Third-Party Software

This workspace includes the following third-party software:

- **Runelite**: Licensed under the BSD 2-Clause License. Runelite is developed and maintained by the Runelite team. Visit [runelite.net](https://runelite.net) for more information.
- **OpenJDK**: Licensed under the GNU General Public License v2 with Classpath Exception.
- **Kasm Workspaces**: Base image provided by Kasm Technologies under their respective licensing terms.

### Disclaimer

- This project is not affiliated with, endorsed by, or connected to Jagex Ltd. or the official Old School RuneScape game.
- Old School RuneScape is a trademark of Jagex Ltd.
- Runelite is an independent third-party client for Old School RuneScape.
- Users are responsible for complying with Jagex's Terms of Service and Rules of Conduct when using this workspace.
- This workspace is provided "as is" without warranty of any kind.

### Usage Responsibility

By using this workspace, you acknowledge that:
- You will use it in compliance with all applicable terms of service
- You understand the risks associated with third-party game clients
- You are responsible for your own account security and actions
- The maintainers of this project are not responsible for any account actions taken by Jagex

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## Support

For support and questions:
- Open an issue on GitHub
- Check the troubleshooting section above
- Review the Runelite documentation at [runelite.net](https://runelite.net)

---

**Note**: Always ensure you're complying with the game's terms of service when using third-party clients like Runelite.