# Step 1: Use a tiny, high-performance web server
FROM nginx:alpine

# Step 2: Copy your kiosk files into the server's display folder
COPY ./src /usr/share/nginx/html

# Step 3: Expose port 80 for web traffic
EXPOSE 80