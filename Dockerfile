FROM astral/uv:0.9.17-python3.14-bookworm AS builder
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy UV_PYTHON_DOWNLOADS=0

# Create and set the working directory
WORKDIR /mro-app

# Install runtime dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

# Copy the application code (excluding files in .dockerignore)
COPY . .
RUN --mount=type=cache,target=/root/.cache/uv \
        uv sync --frozen --no-dev

# Use an official lightweight Python image with slim variant
FROM python:3.14.2-slim

# Set environment variables
# See: https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUNBUFFERED
ENV PYTHONUNBUFFERED=1

# Create and set the working directory
WORKDIR /mro-app

# Expose the port the app runs on
EXPOSE 8000

# Copy the application from the builder
COPY --from=builder /mro-app /mro-app

# Place executables in the environment at the front of the path
ENV PATH="/mro-app/.venv/bin:$PATH"

# Define the default command to run when the container starts
CMD ["memray", "run", "--native", "--output", "/tmp/capture.bin", "main.py"]
