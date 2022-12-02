FROM rust as builder
RUN rustup toolchain add nightly
RUN rustup default nightly
RUN cargo +nightly install -f cargo-fuzz

ADD . /vm-virtio
WORKDIR /vm-virtio/fuzz

RUN cargo fuzz build 

# Package Stage
FROM ubuntu:20.04

COPY --from=builder /vm-virtio/fuzz/target/x86_64-unknown-linux-gnu/release/virtio_queue /
COPY --from=builder /vm-virtio/fuzz/target/x86_64-unknown-linux-gnu/release/vsock /
COPY --from=builder /vm-virtio/fuzz/target/x86_64-unknown-linux-gnu/release/virtio_queue_ser /