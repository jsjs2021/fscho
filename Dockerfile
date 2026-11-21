
FROM node:20-bookworm

WORKDIR /home/choreouser

ENV PORT=3000

EXPOSE 3000

# Install required system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    iproute2 \
    vim \
    netcat-openbsd \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Create Choreo-compatible non-root user
RUN groupadd --gid 10008 choreo && \
    useradd --uid 10008 \
    --gid 10008 \
    --no-create-home \
    --shell /usr/sbin/nologin \
    choreouser

# Copy application files
COPY files/ ./

# Install dependencies and set permissions
RUN npm install --omit=dev && \
    chmod +x ./swith ./web ./server && \
    chown -R 10008:10008 /home/choreouser

# Run as non-root user
USER 10008

CMD ["node", "index.js"]
