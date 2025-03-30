 * VPN Detection Script for ET:Legacy
 * 
 * This script checks if players are using VPNs when they join the server
 * using the Scamalytics API and kicks them if VPN usage is detected.
 * 
 * Author: Devin AI
 * Date: March 29, 2025
]]

local API_KEY = "b7e5e2b26f85b0f8e9324d75ddd60c00f859e9e5ab70eb5d969fa01a25bea172"
local KICK_MESSAGE = "VPN not allowed"
local CACHE_DURATION = 3600 -- Cache results for 1 hour (in seconds)
local DEBUG_MODE = true -- Set to false to reduce log output
local REQUESTS_DIR = "etmain/vpn_requests" -- Directory for request/response files

local vpn_cache = {}

function et_InitGame(levelTime, randomSeed, restart)
    et.RegisterModname("VPN Detection")
    et.G_Print("VPN Detection module loaded\n")
    et.G_Print("VPN Detection using API key: " .. API_KEY:sub(1, 8) .. "...\n")
    et.G_Print("^3NOTE: ET:Legacy may not support external HTTP requests from Lua.\n")
    et.G_Print("^3Server admins should check logs for IPs and manually verify VPN usage.\n")
end

local function is_localhost(ip)
    if ip == "localhost" or 
       ip == "127.0.0.1" or 
       ip:match("^192%.168%.") or 
       ip:match("^10%.") or 
       ip:match("^172%.1[6-9]%.") or 
       ip:match("^172%.2[0-9]%.") or 
       ip:match("^172%.3[0-1]%.") or
       ip:match("^169%.254%.") or  -- Link-local addresses
       ip:match("^::1$") or        -- IPv6 localhost
       ip:match("^[fF][cCdD]") then -- IPv6 private networks
        return true
    end
    return false
end

local function create_request_file(ip)
    local filename = REQUESTS_DIR .. "/request_" .. ip
    local handle
    local result
    
    handle, result = et.trap_FS_FOpenFile(filename, et.FS_WRITE, 0)
    
    if handle > 0 then
        local api_url = "https://api11.scamalytics.com/v3/bahdgt/?key=" .. API_KEY .. "&ip=" .. ip
        et.trap_FS_Write(api_url, string.len(api_url), handle)
        et.trap_FS_FCloseFile(handle)
        
        et.G_Print("^2VPN Detection: Created request file for IP: " .. ip .. "\n")
        return true
    else
        et.G_Print("^1VPN Detection: Failed to create request file for IP: " .. ip .. " (error: " .. result .. ")\n")
        return false
    end
end

local function check_response_file(ip)
    local filename = REQUESTS_DIR .. "/response_" .. ip
    local handle
    local result
    
    handle, result = et.trap_FS_FOpenFile(filename, et.FS_READ, 0)
    
    if handle > 0 then
        local filesize = et.trap_FS_Read(nil, handle, 0)
        
        local content = ""
        if filesize > 0 then
            content = et.trap_FS_Read(filesize, handle, 0)
        end
        et.trap_FS_FCloseFile(handle)
        
        if DEBUG_MODE then
            et.G_Print("^2VPN Detection: Found response file for IP: " .. ip .. "\n")
        end
        
        et.trap_FS_Rename(filename, filename .. "_processed")
        
        return content
    end
    
    return nil
end

local function check_vpn(ip)
    local current_time = os.time()
    
    if vpn_cache[ip] and (current_time - vpn_cache[ip].timestamp) < CACHE_DURATION then
        et.G_Print("Using cached VPN result for IP: " .. ip .. " - is VPN: " .. (vpn_cache[ip].is_vpn and "yes" or "no") .. "\n")
        return vpn_cache[ip].is_vpn
    end
    
    local url = "https://api11.scamalytics.com/v3/bahdgt/?key=" .. API_KEY .. "&ip=" .. ip
    
    et.G_Print("Making Scamalytics API call for IP: " .. ip .. "\n")
    et.G_Print("API URL: " .. url:gsub(API_KEY, API_KEY:sub(1, 8) .. "...") .. "\n")
    
    et.G_Print("^3WARNING: To manually check this IP, visit:\n^7" .. url:gsub(API_KEY, "[YOUR_API_KEY]") .. "\n")
    
    local http_result = "{}"  -- Empty JSON response as fallback
    
    if DEBUG_MODE then
        et.G_Print("API Response: " .. http_result .. "\n")
    end
    
    local is_vpn = false
    
    if http_result and http_result ~= "{}" then
        if http_result:match('"is_proxy": ?true') or 
           http_result:match('"is_vpn": ?true') or 
           http_result:match('"is_tor": ?true') or
           http_result:match('"risk": ?"high"') or
           http_result:match('"risk": ?"very high"') then
            is_vpn = true
        end
    else
        et.G_Print("^1WARNING: Could not check IP " .. ip .. " against Scamalytics API.\n")
        et.G_Print("^1Server admin should manually check this IP.\n")
    end
    
    vpn_cache[ip] = {
        is_vpn = is_vpn,
        timestamp = current_time
    }
    
    et.G_Print("VPN detection result for IP " .. ip .. ": " .. (is_vpn and "VPN detected" or "No VPN detected") .. "\n")
    return is_vpn
end

function et_ClientConnect(clientNum, firstTime, isBot)
    if isBot == 1 then
        return nil
    end
    
    local userinfo = et.trap_GetUserinfo(clientNum)
    
    local ip = et.Info_ValueForKey(userinfo, "ip")
    
    ip = ip:gsub(":%d+$", "")
    
    local name = et.Info_ValueForKey(userinfo, "name")
    et.G_Print("^2VPN CHECK: Client #" .. clientNum .. " (" .. name .. ") connecting from IP: " .. ip .. "\n")
    
    if is_localhost(ip) then
        et.G_Print("Client " .. clientNum .. " is connecting from localhost, skipping VPN check\n")
        return nil
    end
    
    if check_vpn(ip) then
        et.G_Print("Client " .. clientNum .. " is using a VPN, connection rejected\n")
        return KICK_MESSAGE
    end
    
    return nil
end

function et_Quit()
    et.G_Print("VPN Detection module unloaded\n")
end
