FROM nginx:latest

# Copy custom nginx config if needed
COPY nginx.conf /etc/nginx/nginx.conf

# Create directory for storing persistent data
RUN mkdir -p /var/www/html

# Expose ports
EXPOSE 80
EXPOSE 443

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]