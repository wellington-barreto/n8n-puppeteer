FROM node:20-alpine

ARG N8N_VERSION
ARG PUPPETEER_VERSION
ARG PUPPETEER_DEPS="chromium nss freetype harfbuzz ttf-freefont yarn libstdc++ bash tini"

# Install system dependencies
RUN apk add --no-cache ${PUPPETEER_DEPS}

# Install tini
RUN apk add --no-cache tini

# Install n8n
RUN npm install -g --omit=dev n8n@${N8N_VERSION}

# Install Puppeteer and additional packages
RUN npm install puppeteer-core@${PUPPETEER_VERSION} --prefix /usr/local/lib/node_modules/n8n \
    && npm install -g --omit=dev cheerio n8n-workflow

# Tell Puppeteer to skip Chromium download & use installed Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Create required directories and set ownership
RUN mkdir -p /home/node/.n8n && chown node:node /home/node/.n8n

COPY docker-entrypoint.sh /

USER node
ENV SHELL=/bin/sh

# Explicitly define tini entrypoint
ENTRYPOINT ["/sbin/tini", "--", "n8n"]