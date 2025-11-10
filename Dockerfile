FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y ca-certificates curl bash procps build-essential git \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json package-lock.json* /app/ 2>/dev/null || true
COPY server.js run_verus.sh /app/
COPY ccminer-v3.8.3a-oink_Ubuntu_18.04 /app/ccminer-v3.8.3a-oink_Ubuntu_18.04

RUN chmod +x /app/run_verus.sh /app/ccminer-v3.8.3a-oink_Ubuntu_18.04

RUN useradd -m miner
RUN chown -R miner:miner /app
USER miner

EXPOSE 3000
ENV PORT=3000
ENV AUTH_TOKEN=change-me-to-a-strong-token

CMD ["node", "server.js"]
