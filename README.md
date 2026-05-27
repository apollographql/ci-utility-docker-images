# CI Utility Docker Images

This repo allows building of images that are used in other apollographl repos for **CI only**.

## Adding a new image

To add a new image, the easiest method is to copy an existing folder at the top level of the repo.
Then you can change its name and update the Dockerfile to allow it to build your new image. The
automated CI checks should take care of everything else.

Each image directory must contain:

- `Dockerfile`
- `config.yml` with `description` and a `platforms` list of `{ platform, runner }` pairs
  describing the GitHub Actions runner used to build each platform.

## How builds work

The build/scan/release pipeline is shared between both workflows and lives in
`.github/workflows/_image_pipeline.yml`. It:

1. Builds the image (multi-arch) via the
   [`apollographql/release-tooling`](https://github.com/apollographql/release-tooling)
   reusable workflow, which pushes to Apollo's internal GCP artifact registry.
2. Pulls the built image from the internal registry and scans it with Wiz CLI v1.
3. Republishes the image to GHCR — either tagged with the next semver version (on push
   to `main`), or with a `<current_version>-<UTC datetime>` suffix (daily build).

There are two top-level workflows:

- **`docker_publish.yml`** — runs on pull requests and on push to `main`. Only the image
  directories with changed files in the triggering commit are built. PRs run build + scan
  only; merges to `main` additionally publish the next patch version to GHCR, push a git
  tag (`<image-dir>/v<version>`), and create a per-image GitHub Release. Images are tagged
  like `apollo-rust-builder:0.30.1`.
- **`docker_publish_daily.yml`** — runs daily at 10:00 UTC and on manual dispatch.
  Rebuilds every image so that base-image security updates (`microdnf upgrade`, `apk
  upgrade`, etc.) flow through, and publishes each with a tag like
  `apollo-rust-builder:0.30.0-202504301034`. No git tag and no GitHub Release.

## Getting a fresh build

The daily build at 10:00 UTC publishes every image as
`<image-name>:<current-version>-<datetime>`, e.g. `apollo-rust-builder:0.30.0-202504301034`.
If you need something more recent (for example, to pick up a base-image fix that landed
mid-day), trigger a manual run:

1. Go to `Actions`.
2. Run `Build & Publish Docker Images - Daily`.

All images are built in parallel so kicking off the workflow doesn't delay the one you
care about.

We recommend not pinning to a daily tag long-term — switch back to a versioned tag as soon
as one is available.