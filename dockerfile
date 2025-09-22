# Dockerfile (multi-stage, production-ready)

### Stage 1 — builder: install all deps and build the admin
FROM node:18-alpine AS builder
WORKDIR /app

# copy package files first for layer caching
COPY package*.json ./

# If your package-lock.json is in sync you can use npm ci otherwise use npm install
RUN npm ci || npm install

# copy source
COPY . .

# build the admin panel for production
ENV NODE_ENV=production
RUN npm run build

### Stage 2 — runner: runtime image with only production deps
FROM node:18-alpine AS runner
WORKDIR /app

# copy only package metadata, install production-only deps
COPY package*.json ./
RUN npm ci --only=production || npm install --omit=dev

# copy built app from builder
COPY --from=builder /app ./

# Ensure the Strapi server binds to 0.0.0.0
ENV NODE_ENV=production
EXPOSE 1337

CMD ["npm", "run", "start"]
