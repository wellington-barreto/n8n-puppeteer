FROM docker.io/n8nio/n8n:1.122.5

USER root

# Instalar Chromium
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    ttf-liberation \
    font-noto-emoji \
    udev

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_PRODUCT=chrome

# Criar pasta correta de custom nodes
RUN mkdir -p /home/node/.n8n/custom \
    && cd /home/node/.n8n/custom \
    && npm install n8n-nodes-puppeteer \
    && chown -R node:node /home/node/.n8n

USER node
