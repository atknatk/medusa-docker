
# Medusa E-commerce Docker Image with Plugin Management

This is the official Docker image for the Medusa e-commerce application, enhanced to include plugin management. It provides a streamlined setup for developers and businesses who want to deploy a flexible and powerful e-commerce backend. The image allows you to configure plugins via environment variables, install missing plugins during runtime, and ensure they are tracked and skipped for future runs if already installed.

## Overview

Medusa is a headless commerce engine designed to provide flexibility and scalability. This Docker image includes the basic Medusa setup, ready to run out of the box. Additionally, it now supports plugin management through the `PLUGINS` environment variable. You can pass a comma-separated list of plugins, and the image will install any missing plugins during runtime, tracking them in a file to ensure they are only installed once.

### Exposed Port

- **9000**: The Medusa admin API is available on port 9000.

## Environment Variables

You can configure the following environment variables while running this image. If any are not provided, the default values will be used:

- `MEDUSA_ADMIN_ONBOARDING_TYPE`: (default: `default`)
- `STORE_CORS`: (default: `http://localhost:8000,https://docs.medusajs.com`)
- `ADMIN_CORS`: (default: `http://localhost:5173,http://localhost:9000,https://docs.medusajs.com`)
- `AUTH_CORS`: (default: `http://localhost:5173,http://localhost:9000,https://docs.medusajs.com`)
- `REDIS_URL`: (default: `redis://localhost:6379`)
- `JWT_SECRET`: (default: `supersecret`)
- `COOKIE_SECRET`: (default: `supersecret`)
- `DB_NAME`: (default: `medusa-app`)
- `DATABASE_URL`: (default: `postgres://postgres:postgres@localhost/$DB_NAME`)
- `ADMIN_USER`: (default: `admin@medusa-test.com`)
- `ADMIN_PASSWORD`: (default: `supersecret`)
- `PLUGINS`: Comma-separated list of plugins to install during runtime (e.g., `plugin1,plugin2,plugin3`)

## Plugin Installation

The image will automatically install missing plugins during runtime. It tracks the installed plugins in a file (`/usr/src/app/.installed_plugins`). If a plugin is already installed, it will be skipped. If not, it will be installed and added to the list.

## Configuration Volume

You can provide a custom configuration file for Medusa by mounting a volume to `/usr/src/app/medusa-config.ts`.

Example:

```bash
-v /path/to/your/medusa-config.ts:/usr/src/app/medusa-config.ts
```

This will override the default configuration and allow you to customize the Medusa setup as needed.

## Quick Start

To run the Medusa e-commerce application with plugins:

```bash
docker run -d -p 9000:9000 \
  -e REDIS_URL=redis://localhost:6379 \
  -e DATABASE_URL=postgres://postgres:password@localhost/medusa-app \
  -e ADMIN_USER=admin@medusa-test.com \
  -e ADMIN_PASSWORD=supersecret \
  -e PLUGINS="plugin1,plugin2,plugin3" \
  atknatk/medusa "start:prod"
```

If you need to customize the configuration, mount the `medusa-config.ts` file and override the environment variables as needed.

## License

This image is licensed under the [MIT License](https://github.com/medusajs/medusa/blob/master/LICENSE).
