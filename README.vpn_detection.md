# VPN Detection Script for ET:Legacy

This script checks if players are using VPNs when they join the server using the Scamalytics API and kicks them if VPN usage is detected.

## Features

- Checks player IP addresses against the Scamalytics API when they connect
- Caches results to avoid repeated API calls for the same IP
- Skips checks for localhost and local network IPs
- Kicks players using VPNs with a custom message
- Logs connection attempts and VPN detection results

## Installation

1. Place the `vpn_detection.lua` script in your ET:Legacy server's `etmain/lua` directory:
   ```
   /path/to/etlegacy/etmain/lua/vpn_detection.lua
   ```

2. Enable the script by adding it to your `lua_modules` cvar in your server configuration file (typically `etl_server.cfg` or `server.cfg`):
   ```
   set lua_modules "vpn_detection"
   ```
   
   If you already have other Lua modules enabled, add it to the list:
   ```
   set lua_modules "module1 module2 vpn_detection"
   ```

3. Restart your ET:Legacy server for the changes to take effect.

## Configuration

You can modify the following variables at the top of the script to customize its behavior:

- `API_KEY`: Your Scamalytics API key (already set to the provided key)
- `KICK_MESSAGE`: The message shown to players when kicked for using a VPN
- `CACHE_DURATION`: How long to cache results for each IP (in seconds)

## Troubleshooting

- Make sure the `curl` command is available on your server as it's used to make API requests
- Check your server logs for messages from the VPN Detection module
- Ensure your server has internet access to reach the Scamalytics API
- Verify that your API key is valid and has sufficient quota for your server's traffic

## Limitations

ET:Legacy's Lua environment may have restrictions on executing external commands and making HTTP requests. Due to these limitations:

1. The script logs IP addresses of connecting clients but may not be able to directly check them against the Scamalytics API
2. Server administrators should monitor the log files for connection attempts and manually check suspicious IPs

### Alternative Solutions

If direct API checking doesn't work, consider these alternatives:

1. **Manual IP Checking**: Review server logs and manually check suspicious IPs using the Scamalytics website
2. **External Script**: Develop an external script that monitors log files and performs API checks outside of ET:Legacy
3. **Server Plugin**: Create a native C/C++ ET:Legacy module that can make HTTP requests directly

## License

This script is provided under the same license as ET:Legacy.
