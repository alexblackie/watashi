ARG ELIXIR_VERSION=1.15.7
ARG OTP_VERSION=26.1.2
ARG DEBIAN_VERSION=bookworm-20230612-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder
ENV MIX_ENV=prod

RUN apt-get update -y && apt-get install -y build-essential git \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /app
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV

COPY config config

RUN mix deps.compile

COPY priv priv
COPY lib lib
COPY templates templates

RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs.example config/runtime.exs

COPY rel rel
RUN mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}
ENV MIX_ENV=prod

RUN apt-get update && apt-get install -y ca-certificates libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/watashi ./
COPY --chown=nobody:root ./articles ./articles

USER nobody
CMD ["/app/bin/watashi", "start"]
