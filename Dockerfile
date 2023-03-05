FROM rust:1.67.1-alpine
WORKDIR /usr/src/watashi
COPY . .
RUN cargo build --release

FROM alpine:3.17
COPY --from=0 /usr/src/watashi/target/release/watashi /watashi
ADD ./static /static
ADD ./articles /articles
ADD ./icons /icons
CMD ["/watashi"]
