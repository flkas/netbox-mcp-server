FROM python:3.13-alpine AS builder

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

WORKDIR /app

COPY pyproject.toml ./

RUN uv pip install --system .

FROM python:3.13-alpine AS production

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONPATH=/app

RUN addgroup -S netbox && adduser -S -G netbox -h /app -s /bin/sh netbox

WORKDIR /app

COPY --from=builder /usr/local/lib/python3.13/site-packages /usr/local/lib/python3.13/site-packages

COPY server.py netbox_client.py ./

RUN chown -R netbox:netbox /app

USER netbox

CMD ["python", "server.py"]
