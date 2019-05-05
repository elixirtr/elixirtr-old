
FROM elixir:1.8-alpine as fetcher
ENV MIX_ENV=prod

RUN apk add --no-cache git

COPY . /opt/elixirtr
WORKDIR /opt/elixirtr

RUN mix local.hex --force \
   && mix local.rebar --force \
   && mix deps.get

# FROM node:11.15-alpine as webpacker
FROM node:11.15-slim as webpacker
ENV MIX_ENV=prod

COPY --from=fetcher /opt/elixirtr /opt/elixirtr
# COPY yarn.lock /opt/elixirtr/assets
WORKDIR /opt/elixirtr/assets

RUN yarn && yarn run deploy

FROM elixir:1.8-alpine as builder
ENV MIX_ENV=prod

RUN apk add --no-cache git build-base

COPY --from=webpacker /opt/elixirtr /opt/elixirtr
WORKDIR /opt/elixirtr

RUN rm -rf _build \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix clean \
  && mix deps.get --only ${MIX_ENV} \
  && mix compile \
  && mix phx.digest \
  && mix release --env=${MIX_ENV} --no-tar

FROM alpine:3.9 as runner
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 MIX_ENV=prod REPLACE_OS_VARS=true

COPY --from=builder /opt/elixirtr/_build/prod/rel/extr /opt/elixirtr
COPY --from=builder /opt/elixirtr/container /opt/elixirtr/container

RUN apk add --no-cache bash su-exec

RUN adduser -D -g '' appuser
RUN chown -R appuser /opt/elixirtr

WORKDIR /opt/elixirtr
RUN chmod +x ./container/launch.sh

ENTRYPOINT ["./container/launch.sh"]
CMD ./bin/extr foreground

ARG BUILD_DATE
ARG VCS_REF
ARG VCS_REF_MSG
ARG VCS_URL
ARG VERSION

LABEL vendor="elixirtr" \
  name="elixirtr/elixirtr" \
  maintainer="kakkoyun@gmail.com" \
  description="elixir |> turkiye" \
  com.kakkoyun.component.name="elixirtr" \
  com.kakkoyun.component.build-date="$BUILD_DATE" \
  com.kakkoyun.component.vcs-url="$VCS_URL" \
  com.kakkoyun.component.vcs-ref="$VCS_REF" \
  com.kakkoyun.component.vcs-ref-msg="$VCS_REF_MSG" \
  com.kakkoyun.component.version="$VERSION" \
  com.kakkoyun.component.distribution-scope="public" \
  com.kakkoyun.component.changelog-url="https://github.com/elixirtr/elixirtr/releases" \
  com.kakkoyun.component.url="https://github.com/elixirtr/elixirtr" \
  com.kakkoyun.component.run="docker run -e ENV_NAME=ENV_VALUE IMAGE" \
  com.kakkoyun.component.environment.required="MIX_ENV, ELIXIRTR_SECRET_KEY_BASE" \
  com.kakkoyun.component.environment.optional="ELIXIRTR_EXPOSED_HOST, ELIXIRTR_EXPOSED_PORT, ELIXIRTR_EXPOSED_VIA_SSL, ELIXIRTR_LOG_LEVEL" \
  com.kakkoyun.component.dockerfile="/opt/elixirtr/Dockerfile"
