
# Stage 1: Build the Nuxt.js app in SPA mode
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

ARG NUXT_PUBLIC_API_URL
ARG API_SECRET 

ENV NUXT_PUBLIC_API_URL=${NUXT_PUBLIC_API_URL}
ENV API_SECRET=${API_SECRET}
# Copy package.json and package-lock.json (if you use it)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application code
COPY . .

# Build the application in SPA mode
RUN npm run build:spa

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

ARG NUXT_PUBLIC_API_URL
ARG API_SECRET 

ENV NUXT_PUBLIC_API_URL=${NUXT_PUBLIC_API_URL}
ENV API_SECRET=${API_SECRET}
# Copy built Nuxt.js app from the builder stage
COPY --from=builder /app/.output/public /usr/share/nginx/html

# Copy custom Nginx configuration (if you have any)
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose the default Nginx port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
