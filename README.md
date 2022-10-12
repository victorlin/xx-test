# xx-test

testing Dockerfile cross-compilation using xx

## Set up emulation

```sh
docker run --rm --privileged tonistiigi/binfmt:latest --install arm64
```

## Build

```sh
docker buildx build --platform linux/arm64 --progress=plain --load .
```
