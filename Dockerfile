FROM mcr.microsoft.com/devcontainers/javascript-node:22

RUN . /etc/os-release \
  && wget -q "https://packages.microsoft.com/config/debian/${VERSION_ID}/packages-microsoft-prod.deb" \
  && dpkg -i packages-microsoft-prod.deb && rm packages-microsoft-prod.deb \
  && apt-get update && apt-get install -y --no-install-recommends powershell \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 python3-pip python3-venv pandoc ghostscript \
  && rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --no-cache-dir sentence-transformers numpy

RUN npm install -g pnpm@11.20.0
WORKDIR /workspaces/ai-triad-research
# Copy just the lockfile so this layer only rebuilds when deps change
COPY pnpm-lock.yaml ./
RUN pnpm fetch --store-dir /pnpm/store && chown -R node:node /pnpm/store
