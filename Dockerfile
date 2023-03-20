FROM node:lts-bullseye as assets
WORKDIR /usr/src/watashi
COPY . .
RUN npm install && npm run build

FROM rust:1.67.1-bullseye as program
ARG HEAD_COMMIT
WORKDIR /usr/src/watashi
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
COPY --from=program /usr/src/watashi/target/release/watashi /watashi
COPY --from=assets /usr/src/watashi/public /public
ADD ./articles /articles
ADD ./icons /icons
CMD ["/watashi"]
