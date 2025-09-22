# Stage 1 — Builder
FROM node:18-alpine AS builder
WORKDIR /app

# copy package files from my-strapi-app folder
COPY my-strapi-app/package*.json ./

RUN npm ci || npm install

# copy source code
COPY my-strapi-app/ ./

# build
ENV NODE_ENV=production
RUN npm run build

# Stage 2 — Runner
FROM node:18-alpine AS runner
WORKDIR /app

COPY my-strapi-app/package*.json ./
RUN npm ci --only=production || npm install --omit=dev

COPY --from=builder /app ./  

ENV NODE_ENV=production
EXPOSE 1337
CMD ["npm", "run", "start"]
