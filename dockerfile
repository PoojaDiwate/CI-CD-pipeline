# =========================
# Stage 1 - Build Strapi
# =========================
FROM node:18-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files first (better caching)
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

# Copy all project files
COPY . .

# Build Strapi for production
RUN yarn build

# =========================
# Stage 2 - Production Image
# =========================
FROM node:18-alpine AS production

# Set working directory
WORKDIR /app

# Copy only necessary files from build stage
COPY --from=build /app/package.json ./
COPY --from=build /app/yarn.lock ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/build ./build
COPY --from=build /app/.cache ./.cache
COPY --from=build /app/config ./config
COPY --from=build /app/src ./src
COPY --from=build /app/public ./public

# Expose Strapi port
EXPOSE 1337

# Set environment variables for production
ENV NODE_ENV=production

# Start Strapi
CMD ["yarn", "start"]