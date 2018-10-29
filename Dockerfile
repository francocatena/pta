ARG APP_HOME=/app

# --- Builder ---
FROM elixir:alpine AS build

LABEL stage=intermediate

ARG APP_HOME
ENV MIX_ENV=prod

RUN apk add --update --no-cache build-base

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

RUN mix local.hex --force && mix local.rebar --force

ADD . $APP_HOME
RUN mix deps.get && mix release --no-tar

# --- Release image ---
FROM alpine:latest

ARG APP_HOME

RUN apk add --update --no-cache bash openssl
RUN mkdir $APP_HOME && chown -R nobody: $APP_HOME

WORKDIR $APP_HOME

USER nobody

COPY --from=build $APP_HOME/_build/prod/rel/pta ./

ENV REPLACE_OS_VARS=true
ENV HTTP_PORT=4000 BEAM_PORT=14000 ERL_EPMD_PORT=24000
EXPOSE $HTTP_PORT $BEAM_PORT $ERL_EPMD_PORT

ENTRYPOINT [ "/app/bin/pta" ]
CMD [ "foreground" ]
