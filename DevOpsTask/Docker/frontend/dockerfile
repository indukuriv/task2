# Use Node.js 16 to build the app
FROM node:16 AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# Use a lightweight web server to serve the built app
FROM node:16

WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy build output from previous stage
COPY --from=builder /app/build ./build

# Expose frontend port
EXPOSE 3000

# Serve the app
CMD ["serve", "-s", "build", "-l", "3000"]
