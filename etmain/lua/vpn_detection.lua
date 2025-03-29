--[[
 * VPN Detection Script for ET:Legacy
 * 
 * This script checks if players are using VPNs when they join the server
 * using the Scamalytics API and kicks them if VPN usage is detected.
 * 
 * Author: Devin AI
 * Date: March 29, 2025
]]

-- Configuration
local KICK_MESSAGE = "VPN not allowed"
local CACHE_DURATION = 3600 -- Cache results for 1 hour (in seconds)

-- Cache to store IP check results and avoid repeated API calls
local vpn_cache = {}

-- Register the module name
function et_InitGame(levelTime, randomSeed, restart)
    et.RegisterModname("VPN Detection")
    et.G_Print("VPN Detection module loaded\n")
    
    -- Load API key from cvar
    local api_key = et.trap_Cvar_Get("vpn_api_key")
    if not api_key or api_key == "" then
        et.G_Print("^1ERROR: vpn_api_key cvar not set. VPN detection will not work!\n")
        et.G_Print("^1Please set vpn_api_key in your server config: set vpn_api_key \"your_api_key_here\"\n")
    end
end

-- Function to check if an IP is a localhost address
local function is_localhost(ip)
    return ip == "localhost" or ip == "127.0.0.1" or ip:match("^192%.168%.") or ip:match("^10%.") or ip:match("^172%.1[6-9]%.") or ip:match("^172%.2[0-9]%.") or ip:match("^172%.3[0-1]%.")
end

-- Function to make HTTP request to Scamalytics API
local function check_vpn(ip)
    -- Get API key from cvar
    local api_key = et.trap_Cvar_Get("vpn_api_key")
    if not api_key or api_key == "" then
        et.G_Print("^1ERROR: Cannot check VPN - vpn_api_key cvar not set\n")
        return false
    end
    
    -- Check cache first to avoid repeated API calls
    local current_time = os.time()
    
    -- If we have a cached result that hasn't expired
    if vpn_cache[ip] and (current_time - vpn_cache[ip].timestamp) < CACHE_DURATION then
        return vpn_cache[ip].is_vpn
    end
    
    -- Construct API URL
    local url = "https://api.scamalytics.com/v2/ip/" .. ip .. "?key=" .. api_key
    
    -- Use Lua's HTTP capabilities to make the request
    local http_result = ""
    local file = io.popen("curl -s '" .. url .. "'")
    if file then
        http_result = file:read("*a")
        file:close()
    end
    
    -- Parse the JSON response
    local is_vpn = false
    
    -- Look for proxy or VPN indicators in the response
    if http_result:match('"is_proxy": ?true') or 
       http_result:match('"is_vpn": ?true') or 
       http_result:match('"is_tor": ?true') or
       http_result:match('"risk": ?"high"') or
       http_result:match('"risk": ?"very high"') then
        is_vpn = true
    end
    
    -- Cache the result
    vpn_cache[ip] = {
        is_vpn = is_vpn,
        timestamp = current_time
    }
    
    return is_vpn
end

-- Called when a client attempts to connect
function et_ClientConnect(clientNum, firstTime, isBot)
    -- Skip bots
    if isBot == 1 then
        return nil
    end
    
    -- Get client's userinfo
    local userinfo = et.trap_GetUserinfo(clientNum)
    
    -- Extract IP address from userinfo
    local ip = et.Info_ValueForKey(userinfo, "ip")
    
    -- Remove port number if present
    ip = ip:gsub(":%d+$", "")
    
    -- Log connection attempt
    et.G_Print("Client " .. clientNum .. " connecting from IP: " .. ip .. "\n")
    
    -- Skip check for localhost connections
    if is_localhost(ip) then
        et.G_Print("Client " .. clientNum .. " is connecting from localhost, skipping VPN check\n")
        return nil
    end
    
    -- Check if the API key is set
    local api_key = et.trap_Cvar_Get("vpn_api_key")
    if not api_key or api_key == "" then
        et.G_Print("^1WARNING: Cannot check if client " .. clientNum .. " is using a VPN - vpn_api_key cvar not set\n")
        return nil
    end
    
    -- Check if the IP is from a VPN
    if check_vpn(ip) then
        et.G_Print("Client " .. clientNum .. " is using a VPN, connection rejected\n")
        return KICK_MESSAGE
    end
    
    -- Allow connection
    return nil
end

-- Called when the game shuts down
function et_Quit()
    et.G_Print("VPN Detection module unloaded\n")
end
