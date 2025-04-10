# Build stage
FROM node:18-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY Server.js .  

# Runtime stage
FROM node:18-slim
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/Server.js ./
RUN npm install --production --no-optional && npm cache clean --force
EXPOSE 3000
CMD ["node", "Server.js"]