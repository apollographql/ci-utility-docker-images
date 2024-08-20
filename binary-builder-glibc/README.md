# Binary Builder (`glibc`)

The image contained herein is an image that should be used
to _build_ Rust binaries at Apollo.

It contains RockyLinux (https://rockylinux.org/) at version
8.9, which specifically contains `glibc` 2.28.

Using images like this ensures compatability with the broadest
range of Linux distributions that are currently under an LTS policy,
and ensures compliance with our new standards for Rust binary building.