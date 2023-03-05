FROM rust:1.67.1-bullseye
WORKDIR /usr/src/watashi
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim
COPY --from=0 /usr/src/watashi/target/release/watashi /watashi
ADD ./static /static
ADD ./articles /articles
ADD ./icons /icons
CMD ["/watashi"]
