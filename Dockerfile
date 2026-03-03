FROM docker.io/n8nio/n8n:1.122.5

USER root

# Instalar Chromium + dependências completas
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    ttf-liberation \
    font-noto-emoji \
    udev \
    dumb-init \
    curl

# Variáveis obrigatórias para Puppeteer no Alpine
    ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    N8N_CUSTOM_EXTENSIONS=/opt/n8n-custom-nodes

# Criar diretórios necessários para o Chromium funcionar
RUN mkdir -p /home/node/.cache \
    && mkdir -p /home/node/.config \
    && chown -R node:node /home/node

# Instalar node Puppeteer de forma persistente
RUN mkdir -p /opt/n8n-custom-nodes \
    && cd /opt/n8n-custom-nodes \
    && npm install n8n-nodes-puppeteer \
    && chown -R node:node /opt/n8n-custom-nodes

USER node

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
