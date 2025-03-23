-- VPN Detector Configuration
local config = {
    -- API key for ipqualityscore.com (replace with your actual key)
    api_key = "YOUR_API_KEY_HERE",
    
    -- API URL for ipqualityscore.com
    api_url = "https://ipqualityscore.com/api/json/ip/",
    
    -- Message displayed when kicking a player for using VPN/proxy
    kick_message = "VPN not allowed",
    
    -- Strictness level (0-3, recommended: 1)
    strictness = 1,
    
    -- Cache duration in seconds (how long to remember IP check results)
    cache_duration = 3600, -- 1 hour
    
    -- Whether to enable debug logging
    debug = true,
    
    -- Whether to allow public access points (recommended: true)
    allow_public_access_points = true,
    
    -- Minimum fraud score to block (0-100, recommended: 75)
    min_fraud_score = 75
}

return config
