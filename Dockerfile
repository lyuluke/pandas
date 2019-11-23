ARG ALPINE_VERSION=3.9
ARG PYTHON_VERSION=3.6

FROM python:${PYTHON_VERSION}-alpine AS builder
WORKDIR /install/
COPY Pipfile* /install/
RUN pip install pipenv==2018.11.26 && \
    pipenv lock -r > requirements.txt && \
    pipenv lock -r -d > requirements-dev.txt && \
    apk add --no-cache python3-dev libstdc++ libpq && \
    apk add --no-cache --virtual .build-deps g++ libffi-dev postgresql-dev musl-dev make && \
    ln -s /usr/include/locale.h /usr/include/xlocale.h && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt && \
    apk del .build-deps

FROM alpine:${ALPINE_VERSION} as alpine
COPY --from=builder /install /usr/local
RUN apk add --no-cache python3-dev libstdc++ libpq
