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

### dbt_project.yml

Es el archivo principal del proyecto `dbt`.

Aquí se define:

- el nombre del proyecto
- el `profile` que debe usar `dbt`
- las rutas de carpetas como `models`, `macros` o `analyses`
- la configuración de materialización de los modelos
- los directorios que se limpian con `dbt clean`

### profiles.yml

Define cómo se conecta `dbt` a la base de datos en cada entorno.

En este proyecto incluye perfiles como `dev` y `pre`, con datos como:

- host
- puerto
- usuario
- contraseña
- base de datos
- esquema por defecto

### models

Es la carpeta donde viven los modelos SQL de `dbt`.

En este proyecto está separada en dos capas:

- `staging/`: modelos intermedios que leen de `raw`, tipan columnas, renombran campos y normalizan datos.
- `marts/`: modelos finales orientados a análisis, como dimensiones y tablas de hechos.

Dentro de esta carpeta también se incluyen archivos `schema.yml`, donde se documentan modelos, `sources` y tests.

### macros

Contiene macros Jinja reutilizables de `dbt`.

En este proyecto se usa para personalizar cómo se resuelve el esquema de destino al materializar modelos, mediante `generate_schema_name.sql`.

### docker

Agrupa los recursos necesarios para inicializar la base de datos local.

En `docker/postgres/init/01_init_raw.sql` se crean los esquemas y tablas de ejemplo, y se cargan datos iniciales en `raw` cuando arranca el contenedor por primera vez.

### docker-compose.yml

Define el servicio local de `Postgres` que usa el proyecto.

Se utiliza para:

- levantar la base de datos con Docker
- exponer el puerto `5432`
- configurar usuario, contraseña y base de datos mediante variables de entorno
- montar el script de inicialización SQL
- persistir los datos en un volumen Docker

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

3. Verificar la conexión de `dbt` con la base:

```bash
dbt debug --profiles-dir .
```

## Cómo funciona dbt en este proyecto

Los datos de entrada ya existen en `Postgres` dentro del esquema `raw`.

- `dbt` lee esas tablas declaradas como `sources`
- ejecuta los modelos SQL de `staging` y `marts`
- materializa vistas y tablas en los esquemas `staging` y `analytics`
- ejecuta tests definidos en los ficheros `schema.yml`

En este proyecto:

- `source('raw', 'customers')` y `source('raw', 'orders')` leen tablas ya existentes en la base
- los modelos de `staging` limpian y tipan los datos
- los modelos de `marts` construyen las tablas finales de análisis

## Ejecutar dbt con comandos separados

Si quieres ver el flujo paso a paso, primero ejecuta los modelos:

```bash
dbt run --profiles-dir .
```

Después ejecuta los tests:

```bash
dbt test --profiles-dir .
```

Si prefieres usar `make`:

```bash
make dbt-run
make dbt-test
```

## Ejecutar dbt con un solo comando

Si quieres ejecutar el flujo completo de una vez, puedes usar:

```bash
make dbt-build
```

o directamente:

```bash
dbt build --profiles-dir .
```

`dbt build` ejecuta en orden los modelos y sus tests, por lo que es la forma más cómoda de correr el proyecto completo.

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

## Generar documentación

Para generar la documentación del proyecto:

```bash
dbt docs generate --profiles-dir .
```

Para servirla en local:

```bash
dbt docs serve --profiles-dir .
```

Por defecto, la documentación queda disponible en `http://localhost:8080`.

## Notas

- El adapter necesario ahora es `dbt-postgres`.
- El target `make venv` fija `dbt-core` y `dbt-postgres` a `1.10.0` para mantener ambas versiones alineadas con el índice disponible en este entorno.
- El script de inicialización de Docker crea las tablas `raw.customers` y `raw.orders`.
- Los modelos de `staging` siguen consumiendo `source('raw', ...)`, pero ahora contra la base local de `Postgres`.
