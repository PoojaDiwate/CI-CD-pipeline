# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app

RUN apk add --no-cache bash git python3 make g++ libc6-compat

# copy package.json only
COPY package*.json ./
RUN npm install

# copy all source code
COPY . ./
RUN npm run build

# Stage 2: Production
FROM node:18-alpine AS runner
WORKDIR /app
RUN apk add --no-cache dumb-init

# copy from builder
COPY --from=builder /app ./

EXPOSE 1337
CMD ["dumb-init", "npm", "run", "start"]
