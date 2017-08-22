#!/bin/bash

echo '1. There are top 10 IP addresses making the most requests, which are displayed in the next form "IP address": "Number of made requests":'

   awk '{print $1": "}' /root/access_log | sort | uniq -c | sort -rn | head -n 10 | awk '{print $2" "$1}'

echo '2. The owners of these IP addresses are:'

   awk '{print $1}' /root/access_log | sort | uniq -c | sort -rn | head -n 3 | while read COUNT IP_ADDRESS; do whois $IP_ADDRESS; done;

echo '3. Top 10 requested pages and the number of requests made for each, which are displayed in the next form "Requested pages": "Number of made requests":'

   awk '{print $7}' /root/access_log | sort | uniq -c | sort -nr | head -10 | awk '{print $2": "$1}'

# Variables for subtask #4 and #5:
# Number of successful requests:
   SUCCESS_REQ="$(awk '{print $9}' /root/access_log | grep 200 | uniq -c | awk '{print $1}')"

# Number of unsuccessful requests:
   UNSUCCESS_REQ="$(awk '{print $9}' /root/access_log | grep 404 | uniq -c | awk '{print $1}')"

# Total number of requests:
   TOTAL_REQ="$(awk '{print $9}' /root/access_log | grep -E '200|404' | wc -l)"

echo '4. Percentage of successful requests, %:'

   awk 'BEGIN { a = "'"$SUCCESS_REQ"'"; b = "'"$TOTAL_REQ"'"; print (a * 100 / b)" %"}'

echo '5. Percentage of unsuccessful requests, %:'

   awk 'BEGIN { a = "'"$UNSUCCESS_REQ"'"; b = "'"$TOTAL_REQ"'"; print (a * 100 / b)" %"}'

echo '6. Top 10 unsuccessful page requests:'

   awk '{print $7" "$9}' /root/access_log | grep 404 | sort | uniq -c | sort -rn | head -n 10 | awk '{print $2}'

echo '7. The total number of requests made every minute in the time period covered:'

   TIME=(11:15 11:16 11:17 11:18 11:19 11:20)

   for time in ${TIME[@]}; do echo -n "$time: "; grep -c $time /root/access_log; done

echo '8. For each of the top 10 IPs, show the top 5 pages requested and the number of requests for each:'

   awk '{print $1}' /root/access_log | sort -n | uniq -c | sort -nr | head -n 10 | awk '{print $2}' | while read IP_ADDRESS; do echo "$IP_ADDRESS"; grep $IP_ADDRESS /root/access_log | awk '{print $7}' | sort | uniq -c | sort -rn | head -n 5; echo; done

echo '9. Please explain what you think is going on in this log-file.'
echo "This is an example of Apache Web Server log file, which contains aceess records to the Web server.
Let's try to explain the fields of access records in this file.
46.182.3.34 - Client's IP address, which want to get access to the Web server;
'- -' - 'two hyphens': first hyphen is a user's identity, and the second hyphen is username, which is assigned to user after authentication;  
[21/Mar/2011:20:47:54 +0900] - date and time, when the Web server got request;
"GET /%22osCsid=%22%20+download HTTP/1.1" - this line means, that client sent request to the Web server;
   - GET - is HTTP method for retrieving of information from the Web server;
   - /%22osCsid=%22%20+download - is a resource, which client requested;
   - HTTP/1.1 - version of HTTP protocol;
200 / 404 - there are the status codes, which server sends to client as response on request
   - 200 - status 'OK';
   - 404 - error message "Not Found", which means that client can communicate with server but server cannot find resource;
244 - object size of requested resource."

echo '10. Generate an ASCII bar-chart showing the number of requests per minute.'

   for time in ${TIME[@]}; do echo -n "$time: "; grep -c $time /root/access_log; done
