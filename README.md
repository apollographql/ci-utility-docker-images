# CI Utility Docker Images

This repo allows building of images that are used in other apollographl repos for **CI only**

## Adding a new image

To add a new image, the easiest method is to copy an existing folder at the top level of the repo.
Then you can change its name and update the Dockerfile to allow it to build your new image. The automated
CI checks should take care of everything else.

## How Do Builds Work

There are three kinds of build configured on the repo:

- A daily build - This build simply builds the repo as it currently is, however because each Docker Image _should_ run a
  command to update dependencies that arise from the operating system i.e. (`yum update`, `dnf upgrade` etc.) this will
  update base dependencies. Builds like this have docker tags like `apollo-rust-builder:0.2.0-202504301034`
- A monthly build - These builds wrap up all the daily builds and publish a new patch version of each image. These
  should have tags like `apollo-rust-builder:0.2.5`
- On Demand builds - These builds run on each PR, and on each subsequent merge to main.

The first two builds will build all images in the repo, and the second only for files that have actually changed.

## Getting a fresh build

At present this repo is set to build all images at 10am UTC every day. These are published to the in-repo image
repositories with tags like `<<IMAGE_NAME>>:<<CURRENT_VERSION>>-<<DATE>>` e.g. `apollo-rust-builder:0.2.0-202504301034`,
as such if you need something to satisfy a recent security fix, just use that tag.

If you require a build because a new version of a dependency has become available very recently. Then you can follow the
following steps:

1. Go to `Actions`
2. Kick off a run of `Build & Publish Docker Images - Daily`

_This will rebuild the entire repo but as all builds happen in parallel this will not adversely affect when the image
you want will become available_

We would also recommend that you don't rely on a daily build for a long period of time, and as soon as a fixed version
is available update to that.