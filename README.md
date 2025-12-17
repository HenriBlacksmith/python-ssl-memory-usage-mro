# MRE for ssl memory issues in Python 3.14

## Requirements

This MRE requires `uv` and `docker` (CLI/API).

## Build and run the MRE app in Docker and produce reports

```shell
make all-docker
```

## Run the MRE app without Docker and produce reports

```shell
make all
```

## Changing Python version when running outside of Docker

Update `.python-version` file, suggested values:

- `3.14.2+debug` (shows unexpected memory pattern)
- `3.13.11+debug` (shows "nice" memory pattern)

Run `uv sync` to refresh the virtual environment.
