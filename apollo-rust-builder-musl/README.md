# Apollo Rust Builder (`musl`)

The image contained herein is an image that should be used
to _build_ Rust binaries at Apollo, where `musl` rather `glibc` is needed.

It's based on the `rust-1:alpine` image and so will move as that image moves.

Using images like this ensures compatability with the broadest
range of Linux distributions that are currently under an LTS policy,
and ensures compliance with our new standards for Rust binary building.