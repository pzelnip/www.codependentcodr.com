FROM python:3.10-slim

COPY --from=ghcr.io/astral-sh/uv:0.13.6 /uv /usr/local/bin/uv

RUN apt-get update \
    && apt-get install -y --no-install-recommends make git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Install dependencies from the lockfile first so this layer is cached
# across content-only changes. --locked fails if uv.lock is out of date.
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --group deploy
ENV PATH="/build/.venv/bin:$PATH"

COPY . /build

# Use the venv on PATH directly rather than `uv run`, which would re-sync
RUN make publish PELICAN=pelican
