FROM debian:bookworm-slim@sha256:7c7b2c966bc9ee8cedfeef67e0e279108992c77681fa595db4a9d65c06ccc587

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV REVIEWDOG_VERSION=v0.21.2
ENV MISSPELL_VERSION=v0.8.0

# Download reviewdog install script (pinned to commit fd59714416d6d9a1c0692d872e38e7f8448df4fc) to a file and execute it
RUN wget -q -O /tmp/install-reviewdog.sh \
        https://raw.githubusercontent.com/reviewdog/reviewdog/fd59714416d6d9a1c0692d872e38e7f8448df4fc/install.sh \
    && sh /tmp/install-reviewdog.sh -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && rm /tmp/install-reviewdog.sh

# Download misspell install script pinned to v0.8.0 tag commit (b565578a5ec9b815331bdae8f588021f7696ec6f)
# instead of the mutable 'master' branch, to a file and execute it
RUN wget -q -O /tmp/install-misspell.sh \
        https://raw.githubusercontent.com/golangci/misspell/b565578a5ec9b815331bdae8f588021f7696ec6f/install-misspell.sh \
    && sh /tmp/install-misspell.sh -b /usr/local/bin/ "${MISSPELL_VERSION}" \
    && rm /tmp/install-misspell.sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
