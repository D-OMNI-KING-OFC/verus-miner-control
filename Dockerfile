FROM node:18-bullseye-slim

# Install system dependencies, including libjansson for the miner
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    bash \
    procps \
    build-essential \
    git \
    screen \
    libjansson4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Node.js project files and install dependencies
COPY package.json .
RUN npm install

# Copy server + miner
COPY server.js .
COPY run_verus.sh .
COPY ccminer-v3.8.3a-oink_Ubuntu_18.04 .

RUN chmod +x run_verus.sh ccminer-v3.8.3a-oink_Ubuntu_18.04

# Expose the port Fly provides via environment variable
EXPOSE 8080

# Start the Node server
CMD ["node", "server.js"]
