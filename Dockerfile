# Build stage
FROM node:20 AS build

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy the rest of the application
COPY . .
RUN npm run build

# Production stage
FROM nginx:stable-alpine

# Copy custom Nginx config to serve SPA correctly on port 3000
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build artifacts from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
