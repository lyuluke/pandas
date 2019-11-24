ARG ALPINE_VERSION=3.9
ARG PYTHON_VERSION=3.6

FROM python:${PYTHON_VERSION}-alpine AS builder
WORKDIR /install
COPY requirements.txt /requirements.txt
RUN apk update && \
    apk add --no-cache python3-dev libstdc++ libpq && \
    apk add --no-cache --virtual .build-deps g++ libffi-dev postgresql-dev musl-dev make && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --install-option="--prefix=/install" -r /requirements.txt && \
    apk del .build-deps

FROM alpine:${ALPINE_VERSION} as alpine
COPY --from=builder /install /usr/local
RUN apk add --no-cache python3-dev libstdc++ libpq
