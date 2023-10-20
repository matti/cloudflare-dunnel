FROM ubuntu:22.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl gettext-base

RUN mkdir /ghjk && cd /ghjk \
  && [ "$(uname -m)" = "aarch64" ] && arch="arm64" || arch="amd64" \
  && curl -Lfso "cloudflared" "https://github.com/cloudflare/cloudflared/releases/download/2023.8.2/cloudflared-linux-${arch}" \
  && chmod +x cloudflared \
  && mv cloudflared /usr/local/bin \
  && rm -rf /ghjk

WORKDIR /app
COPY app .

ENV PROMPT_COMMAND="history -a"
ENV NO_AUTOUPDATE=1
ENTRYPOINT [ "/app/entrypoint.sh" ]
