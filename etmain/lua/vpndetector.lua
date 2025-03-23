-- VPN Detector module for ET Legacy
-- Detects and kicks players using VPNs or proxies via ipqualityscore.com API

-- Load dependencies
local config = require("vpndetector_config")
local http = require("http")

-- Cache for IP check results
local ip_cache = {}

-- Function to log debug messages
local function debugLog(message)
    if config.debug then
        et.G_Print("[VPN Detector] " .. message .. "\n")
    end
end

-- Function to check if an IP is using a VPN/proxy
local function checkIP(ip)
    -- Check cache first
    local now = os.time()
    if ip_cache[ip] and (now - ip_cache[ip].timestamp) < config.cache_duration then
        debugLog("Using cached result for IP: " .. ip)
        return ip_cache[ip].result
    end
    
    -- Build API URL
    local url = config.api_url .. config.api_key .. "/" .. ip
    
    debugLog("Checking IP: " .. ip)
    
    -- Make API request (using existing http module)
    local response = http.request(url, "GET")
    local result = http.parseJSON(response.body)
    
    -- Cache the result
    ip_cache[ip] = {
        timestamp = now,
        result = result
    }
    
    return result
end

-- Function to get client IP from userinfo
local function getClientIP(clientNum)
    -- Get userinfo string
    local userinfo = et.trap_GetUserinfo(clientNum)
    
    -- Extract IP address from userinfo
    local ip = et.Info_ValueForKey(userinfo, "ip")
    
    -- Strip port if present
    ip = string.gsub(ip, ":%d+$", "")
    
    return ip
end

-- ET Legacy callback for client connection
function et_InitGame(levelTime, randomSeed, restart)
    et.G_Print("=======================================================\n")
    et.G_Print("VPN Detector module initialized\n")
    et.G_Print("API: " .. config.api_url .. "\n")
    et.G_Print("=======================================================\n")
    return 0
end

-- ET Legacy callback for client connection
function et_ClientConnect(clientNum, firstTime, isBot)
    -- Don't check bots
    if isBot == 1 then
        debugLog("Client #" .. clientNum .. " is a bot, skipping VPN check")
        return nil
    end
    
    -- Get client IP
    local ip = getClientIP(clientNum)
    debugLog("Client #" .. clientNum .. " connecting with IP: " .. ip)
    
    -- Check if IP is localhost or LAN
    if ip == "localhost" or ip == "127.0.0.1" or string.match(ip, "^192%.168%.") or string.match(ip, "^10%.") or string.match(ip, "^172%.1[6-9]%.") or string.match(ip, "^172%.2[0-9]%.") or string.match(ip, "^172%.3[0-1]%.") then
        debugLog("Client #" .. clientNum .. " is on LAN/localhost, skipping VPN check")
        return nil
    end
    
    -- Check if IP is using VPN/proxy
    local result = checkIP(ip)
    
    if not result.success then
        debugLog("API error for IP: " .. ip .. ", allowing connection")
        return nil
    end
    
    -- Check if IP is a VPN/proxy
    if result.vpn or result.proxy or result.tor or (result.fraud_score and result.fraud_score >= config.min_fraud_score) then
        debugLog("Client #" .. clientNum .. " rejected: VPN/proxy detected")
        return config.kick_message
    end
    
    debugLog("Client #" .. clientNum .. " passed VPN check")
    return nil
end

-- Log module initialization
debugLog("VPN Detector module loaded")
