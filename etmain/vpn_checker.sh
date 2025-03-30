
REQUESTS_DIR="etmain/vpn_requests"
SLEEP_INTERVAL=5
MAX_AGE=3600 # 1 hour in seconds

echo "VPN Checker companion script started"
echo "Monitoring directory: $REQUESTS_DIR"

mkdir -p $REQUESTS_DIR

while true; do
    for request_file in $REQUESTS_DIR/request_*; do
        if [ -f "$request_file" ]; then
            ip=$(basename "$request_file" | sed 's/request_//')
            
            if [ -f "$REQUESTS_DIR/response_$ip" ]; then
                continue
            fi
            
            echo "Processing request for IP: $ip"
            
            api_url=$(cat "$request_file")
            
            response=$(curl -s "$api_url")
            
            echo "$response" > "$REQUESTS_DIR/response_$ip"
            
            echo "Response saved for IP: $ip"
        fi
    done
    
    find $REQUESTS_DIR -type f -name "request_*" -mmin +$((MAX_AGE/60)) -delete
    find $REQUESTS_DIR -type f -name "response_*" -mmin +$((MAX_AGE/60)) -delete
    
    sleep $SLEEP_INTERVAL
done
