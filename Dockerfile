FROM node:18-bullseye-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    bash \
    procps \
    build-essential \
    git \
    screen \
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

EXPOSE 3000

# Start both the miner and the server
# Option 1: Run miner in background, then start server
CMD ["bash", "-c", "./run_verus.sh & node server.js"]
