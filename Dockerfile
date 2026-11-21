FROM python:3.15-slim

COPY --from=ghcr.io/astral-sh/uv:0.13.6 /uv /usr/local/bin/uv

RUN apt-get update \
    && apt-get install -y --no-install-recommends make git \
    && rm -rf /var/lib/apt/lists/*

# AWS CLI for the S3 upload (s3_push.sh), installed as a uv tool so it gets its
# own environment, separate from Pelican's: awscli's docutils requirement
# conflicts with Pelican's, so they can't share uv.lock. Bump the version here.
ARG AWSCLI_VERSION=1.46.3
ENV UV_TOOL_DIR=/opt/uv-tools UV_TOOL_BIN_DIR=/usr/local/bin
RUN uv tool install "awscli==${AWSCLI_VERSION}"

WORKDIR /build

# Install the site's dependencies from the lockfile first so this layer is
# cached across content-only changes. --locked fails if uv.lock is out of date.
COPY pyproject.toml uv.lock ./
RUN uv sync --locked
ENV PATH="/build/.venv/bin:$PATH"

COPY . /build

# Use the venv on PATH directly rather than `uv run`, which would re-sync
RUN make publish PELICAN=pelican
