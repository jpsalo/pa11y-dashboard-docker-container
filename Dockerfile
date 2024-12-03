# Forked from: https://github.com/mandrasch/pa11y-dashboard-docker-container
# pa11y-dashboard issue: https://github.com/pa11y/pa11y-dashboard/issues/253
# Some necessary fixes:
# - https://gist.github.com/mandrasch/a0bc5cdfc6b213f5264885120b25bbaf
# - https://stackoverflow.com/questions/71452265/how-to-run-puppeteer-on-a-docker-container-on-a-macos-apple-silicon-m1-arm64-hos

FROM node:16-bullseye-slim
# Dependencies are required to run puppeteer: https://github.com/mandrasch/pa11y-dashboard-docker-container
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        chromium \
        libnss3 \
        libgconf-2-4 \
        gconf-service \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgbm1 \
        libgcc1 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        ca-certificates \
        fonts-liberation \
        libappindicator1 \
        lsb-release \
        xdg-utils \
        wget \
        net-tools \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/pa11y/pa11y-dashboard.git && \
    chown -R node:node /pa11y-dashboard

# this is required because it loads the correct configuration file
ENV NODE_ENV ${NODE_ENV:-production}

WORKDIR /pa11y-dashboard

# Switch to non-root user after setting up permissions
USER node

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

RUN npm install

COPY production.json /pa11y-dashboard/config/production.json

CMD PORT=4000 node index.js
