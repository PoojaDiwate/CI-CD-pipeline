# ---------- Stage 1: Build ----------
FROM node:18-alpine AS builder

WORKDIR /app

# copy package files first
COPY package*.json ./

# install dependencies
RUN npm install

# copy all source code
COPY . .

# build Strapi admin panel for production
RUN npm run build


# ---------- Stage 2: Production ----------
FROM node:18-alpine AS runner

WORKDIR /app

# copy only necessary files (no dev deps)
COPY package*.json ./

# install only production dependencies
RUN npm install --omit=dev

# copy build output + source (but not node_modules from builder)
COPY --from=builder /app/build ./build
COPY --from=builder /app/config ./config
COPY --from=builder /app/src ./src
COPY --from=builder /app/public ./public

# run in production mode
CMD ["npm", "run", "start"]

