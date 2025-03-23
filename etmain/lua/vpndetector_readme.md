# VPN Detector Module for ET Legacy

This module integrates with the ipqualityscore.com API to detect and automatically kick players who are using VPNs or proxies.

## Installation

1. Place the following files in your `etmain/lua/` directory:
   - `vpndetector.lua`
   - `vpndetector_config.lua`
   - `http.lua`

2. Edit `vpndetector_config.lua` and replace "YOUR_API_KEY_HERE" with your actual ipqualityscore.com API key.

3. Make sure Lua scripting is enabled in your server configuration. Add or modify the following line in your server config:
   ```
   set lua_modules "vpndetector"
   ```

## Configuration

You can customize the module's behavior by editing `vpndetector_config.lua`:

- `api_key`: Your ipqualityscore.com API key
- `kick_message`: Message displayed when kicking a player for using VPN/proxy
- `strictness`: How strict the API should be (0-3, recommended: 1)
- `cache_duration`: How long to cache IP check results in seconds
- `debug`: Whether to enable detailed logging
- `allow_public_access_points`: Whether to allow connections from public access points like schools or libraries
- `min_fraud_score`: Minimum fraud score to consider an IP suspicious (0-100)

## Implementation Notes

This module uses a simulated HTTP client since ET Legacy's Lua environment doesn't support real HTTP requests. In a production environment, you would need to implement a socket-based solution or use an external tool to make the actual API requests.

## Troubleshooting

- If players are incorrectly identified as using VPNs, try decreasing the `strictness` or increasing the `min_fraud_score` threshold.
- Enable `debug` to see detailed logs about the module's operation.
- For API errors or questions, consult the ipqualityscore.com documentation.
