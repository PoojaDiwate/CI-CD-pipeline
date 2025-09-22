# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

# Install build tools for Alpine
RUN apk add --no-cache python3 make g++

# Copy package files
COPY my-strapi-app/package*.json ./

# Install all dependencies
RUN npm install

# Copy project files
COPY my-strapi-app/ ./

# Build Strapi admin panel
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:18-alpine AS runner

WORKDIR /app

# Copy only required files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

# Expose Strapi port
EXPOSE 1337

# Start Strapi
CMD ["npm", "run", "start"]
