# dbt Training Project

Proyecto base para una demo de `dbt` con `Postgres` local levantado con Docker.

El proyecto usa una base `Postgres` local y un flujo sencillo de `sources`, `staging` y `marts`.

- `docker compose` levanta la base de datos.
- El contenedor inicializa los datos de entrada en el esquema `raw`.
- `dbt` materializa los modelos en el esquema `analytics`.

## Estructura

```text
dbt-training-project/
├── dbt_project.yml
├── profiles.yml
├── docker-compose.yml
├── Makefile
├── docker/
│   └── postgres/
│       └── init/
│           └── 01_init_raw.sql
├── models/
│   ├── staging/
│   └── marts/
```

## Requisitos

- Docker con `docker compose`
- Python 3

## Setup local

1. Crear o reutilizar el entorno virtual:

```bash
make venv
source .venv/bin/activate
```

2. Levantar `Postgres` local con los `sources` precargados:

```bash
make postgres-up
```

3. Ejecutar el pipeline de `dbt`:

```bash
dbt build --profiles-dir .
```

Si prefieres usar `make` también para `dbt`:

```bash
make dbt-build
```

## Configuración por defecto

`profiles.yml` apunta a estos valores por defecto:

- host: `localhost`
- port: `5432`
- user: `dbt`
- password: `dbt`
- database: `dbt_training`
- source schema: `raw`
- target schema base de dbt: `dbt`

Con la configuración actual de `dbt`, los modelos se materializan en:

- `staging` para la capa `staging`
- `analytics` para la capa `marts`

El proyecto incluye un macro `generate_schema_name` para que el `+schema` definido en `dbt_project.yml` se use como nombre final del schema, sin concatenarlo con el schema base del profile.

Si quieres cambiarlos, crea un fichero `.env` a partir de `.env.example` y exporta las variables `DBT_*` antes de ejecutar `dbt`.

## Comandos útiles

```bash
make postgres-up
make postgres-down
make postgres-reset
make postgres-logs
make dbt-run
make dbt-test
make dbt-build
```

`make postgres-reset` elimina el volumen y vuelve a crear la base con los datos iniciales.

## Verificación rápida

Con la base levantada:

```bash
dbt debug --profiles-dir .
dbt build --profiles-dir .
```

## Notas

- El adapter necesario ahora es `dbt-postgres`.
- El target `make venv` fija `dbt-core` y `dbt-postgres` a `1.10.0` para mantener ambas versiones alineadas con el índice disponible en este entorno.
- El script de inicialización de Docker crea las tablas `raw.customers` y `raw.orders`.
- Los modelos de `staging` siguen consumiendo `source('raw', ...)`, pero ahora contra la base local de `Postgres`.
