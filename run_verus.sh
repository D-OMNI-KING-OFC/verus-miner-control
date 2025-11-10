#!/bin/bash

WALLET="RFSeD6KQiGTN9RDnVZWWqgxTsxqhjpujDb"
POOL="stratum+tcp://eu.luckpool.net:3956"
PASSWORD="x"
WORKER="$(hostname | cut -c1-10)"
BINARY="./ccminer-v3.8.3a-oink_Ubuntu_18.04"
LOGFILE="verusminer.log"

THREADS="$(nproc --all 2>/dev/null || echo 2)"

echo "$(date -u) Starting miner (threads=$THREADS)" | tee -a "$LOGFILE"
$BINARY -a verus -o "$POOL" -u "$WALLET.$WORKER" -p "$PASSWORD" -t "$THREADS" 2>&1 | tee -a "$LOGFILE"
