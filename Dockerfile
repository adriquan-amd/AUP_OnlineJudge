FROM node:18-alpine AS frontend-builder

WORKDIR /frontend

# Set Node.js options for OpenSSL compatibility
ENV NODE_OPTIONS=--openssl-legacy-provider

# Install git for npm dependencies
RUN apk add --no-cache git

COPY frontend/package*.json ./
RUN npm install --include=dev

COPY frontend/ ./
#RUN git init && \
#    git config --global user.email "docker@build.local" && \
#    git config --global user.name "Docker Build" && \
#    git add . && \
#    git commit -m "Initial commit" && \
RUN  npm run build:dll && npm run build


FROM python:3.12-alpine
ARG TARGETARCH
ARG TARGETVARIANT

ENV OJ_ENV=production
WORKDIR /app

COPY backend/deploy/requirements.txt /app/deploy/
# psycopg2: libpg-dev
# pillow: libjpeg-turbo-dev zlib-dev freetype-dev
RUN --mount=type=cache,target=/etc/apk/cache,id=apk-cahce-$TARGETARCH$TARGETVARIANT-final \
    --mount=type=cache,target=/root/.cache/pip,id=pip-cahce-$TARGETARCH$TARGETVARIANT-final \
    <<EOS
set -ex
apk add gcc libc-dev python3-dev libpq libpq-dev libjpeg-turbo libjpeg-turbo-dev zlib zlib-dev freetype freetype-dev supervisor openssl nginx curl unzip
pip install -r /app/deploy/requirements.txt
apk del gcc libc-dev python3-dev libpq-dev libjpeg-turbo-dev zlib-dev freetype-dev
EOS

COPY ./backend /app/
COPY --from=frontend-builder --link /frontend/dist/ /app/dist/
RUN chmod -R u=rwX,go=rX ./ && chmod +x ./deploy/entrypoint.sh

HEALTHCHECK --interval=5s CMD [ "/usr/local/bin/python3", "/app/deploy/health_check.py" ]
ENTRYPOINT [ "/app/deploy/entrypoint.sh" ]

EXPOSE 80 8000 5678
