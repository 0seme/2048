# Stage 1: Build stage (optional, for future asset pipelines)
FROM nginx:alpine AS base

# Set maintainer label
LABEL maintainer="Joyce O <devops@example.com>"
LABEL description="Static HTML/JS Game — nginx:alpine production image"

# Remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx configuration for better caching, security, and SPA support
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy all project files into the nginx web root
COPY . /usr/share/nginx/html

# Set correct ownership and permissions
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Use non-root nginx worker processes (master still needs root for port binding)
# nginx:alpine already handles this via the default nginx user config

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost/ || exit 1

# Start nginx in the foreground (required for Docker)
CMD ["nginx", "-g", "daemon off;"]