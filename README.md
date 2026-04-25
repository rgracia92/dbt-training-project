# dbt Training Project

Proyecto base para una demo de dbt con una estructura sencilla de `staging` y `marts`.

## Estructura

```text
dbt-training-project/
├── dbt_project.yml
├── profiles.yml
├── README.md
├── models/
│   ├── staging/
│   │   ├── stg_orders.sql
│   │   ├── stg_customers.sql
│   │   └── schema.yml
│   └── marts/
│       ├── dim_customers.sql
│       ├── fct_orders.sql
│       └── schema.yml
├── seeds/
│   ├── orders.csv
│   └── customers.csv
└── analyses/
```

## Ejecución rápida

1. Instala `dbt-duckdb`.
2. Ejecuta `dbt seed --profiles-dir .`
3. Ejecuta `dbt run --profiles-dir .`
4. Ejecuta `dbt test --profiles-dir .`
