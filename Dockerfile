FROM docker.io/n8nio/n8n:1.122.5

USER root

# Instalar Chromium e dependências
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
    dumb-init

# Configurar Puppeteer
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium \
    PUPPETEER_PRODUCT=chrome \
    NODE_ENV=production

# Criar diretórios necessários
RUN mkdir -p /home/node/.cache \
    && mkdir -p /home/node/.config \
    && mkdir -p /home/node/.n8n/custom \
    && chown -R node:node /home/node

# Instalar puppeteer node na pasta que o n8n realmente lê
RUN cd /home/node/.n8n/custom \
    && npm install n8n-nodes-puppeteer \
    && chown -R node:node /home/node/.n8n

USER node

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
