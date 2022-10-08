FROM golang:1.19
ENV CGO_ENABLED 0
ADD . /src
WORKDIR /src
RUN go build -a --installsuffix cgo --ldflags="-s" -o watashi

FROM scratch
ENV GIN_MODE=release
COPY --from=0 /src/watashi /watashi
COPY --from=0 /src/articles /articles
COPY --from=0 /src/pages /pages
COPY --from=0 /src/static/images /images
EXPOSE 3000
ENTRYPOINT ["/watashi", "-port=3000", "-articles=/articles", "-pages=/pages", "-images=/images"]
