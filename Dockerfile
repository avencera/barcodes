# STEP 1 - RELEASE BUILDER
FROM elixir:1.8.1-alpine AS builder

# setup up variables
ARG APP_NAME
ARG APP_VSN
ARG PHOENIX_SUBDIR=.

ENV APP_NAME=${APP_NAME} \
    APP_VSN=${APP_VSN} 

# make directory
RUN mkdir /app
WORKDIR /app

# This step installs all the build tools we'll need
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git \
    nodejs \
    yarn \
    build-base && \
    mix local.rebar --force && \
    mix local.hex --force

# install rebar and hex
RUN mix local.rebar --force
RUN mix local.hex --force

# elixir copy mix
ENV MIX_ENV=prod
RUN mkdir /app/_build/ /app/config/ /app/lib/ /app/priv/ /app/deps/ /app/rel/ /app/assets

COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock

# install deps
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY config /app/config
COPY lib /app/lib
COPY priv /app/priv
COPY rel /app/rel

RUN mix compile

COPY assets /app/assets
RUN cd ${PHOENIX_SUBDIR}/assets && \
    yarn install && \
    yarn deploy && \
    cd - && \
    mix phx.digest

# create release
RUN mkdir -p /opt/built &&\
    mix release --verbose &&\
    cp _build/prod/rel/${APP_NAME}/releases/${APP_VSN}/${APP_NAME}.tar.gz /opt/built &&\
    cd /opt/built &&\ 
    tar -xzf ${APP_NAME}.tar.gz &&\
    rm ${APP_NAME}.tar.gz

################################################################################
## STEP 2 - FINAL
FROM alpine:3.9

ENV MIX_ENV=prod

RUN apk update && \
    apk add --no-cache \
    bash \
    openssl-dev

COPY --from=builder /opt/built /app
WORKDIR /app
