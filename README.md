# CI Utility Docker Images

This repo allows building of images that are used in other apollographl repos for **CI only**

## Adding a new image

To add a new image, the easiest method is to copy an existing folder at the top level of the repo.
Then you can change its name and update the Dockerfile to allow it to build your new image. The automated
CI checks should take care of everything else.