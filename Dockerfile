# Use the official Node.js 20 image based on Alpine for a lightweight base
FROM node:20-alpine

# Define build arguments for N8N and Puppeteer versions, and necessary dependencies for Puppeteer
ARG N8N_VERSION
ARG PUPPETEER_VERSION
ARG PUPPETEER_DEPS="chromium nss freetype harfbuzz ttf-freefont yarn libstdc++ bash tini"

# Install system dependencies required by Puppeteer (e.g., Chromium and fonts)
RUN apk add --no-cache ${PUPPETEER_DEPS}

# Install tini (used to handle the init process and ensure that the container keeps running)
RUN apk add --no-cache tini

# Install n8n globally with the specified version and without development dependencies
RUN npm install -g --omit=dev n8n@${N8N_VERSION}

# Install Puppeteer (core version without Chromium, since we’re using the installed version of Chromium)
RUN npm install puppeteer-core@${PUPPETEER_VERSION} --prefix /usr/local/lib/node_modules/n8n \
    && npm install -g --omit=dev cheerio n8n-workflow

# Set environment variables for Puppeteer to use the installed Chromium instead of downloading it
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Create the directory for n8n's configuration and set the appropriate ownership for the 'node' user
RUN mkdir -p /home/node/.n8n && chown node:node /home/node/.n8n

# Switch to the 'node' user to run the application with least privilege
USER node

# Set default shell to /bin/sh (could be useful for scripts that use shell commands)
ENV SHELL=/bin/sh

# Use tini as the init system to ensure proper shutdown of n8n and to handle signals correctly
# The entrypoint executes n8n using tini
ENTRYPOINT ["/sbin/tini", "--", "n8n"]