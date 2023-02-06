FROM golang:1.19.4-alpine3.17 as builder

RUN apk --update add ca-certificates
RUN echo 'foo:*:65532:' > /tmp/group && \
    echo 'foo:*:65532:65532:foo:/:/foo' > /tmp/passwd

WORKDIR /workspace
COPY go.* ./
RUN go mod download

COPY . /workspace

RUN CGO_ENABLED=0 go build -a -o foo .

FROM scratch

WORKDIR /

COPY --from=builder /tmp/passwd /tmp/group /etc/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /workspace/foo .

USER 65532:65532

ENTRYPOINT ["/foo"]
