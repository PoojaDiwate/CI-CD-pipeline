# ============================
# Stage 1 — Build Strapi Admin
# ============================
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build Strapi Admin Panel
ENV NODE_ENV=production
RUN npm run build

# ============================
# Stage 2 — Production Runner
# ============================
FROM node:18-alpine AS prod
WORKDIR /app

# Copy only package files & install production deps
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Copy build output & source from build stage
COPY --from=build /app ./

# Ensure Strapi binds correctly
ENV NODE_ENV=production
EXPOSE 1337

# Start Strapi in production mode
CMD ["npm", "run", "start"]
