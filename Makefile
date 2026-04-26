DBT_VERSION ?= 1.10.0
DBT_PROFILES_DIR ?= .

.PHONY: venv postgres-up postgres-down postgres-reset postgres-logs dbt-run dbt-test dbt-build dbt-debug

venv:
	python3 -m venv .venv
	./.venv/bin/pip install --upgrade pip
	./.venv/bin/pip install dbt-core==$(DBT_VERSION) dbt-postgres==$(DBT_VERSION)

postgres-up:
	docker compose up -d

postgres-down:
	docker compose down

postgres-reset:
	docker compose down -v
	docker compose up -d

postgres-logs:
	docker compose logs -f postgres

dbt-run:
	./.venv/bin/dbt run --profiles-dir $(DBT_PROFILES_DIR)

dbt-test:
	./.venv/bin/dbt test --profiles-dir $(DBT_PROFILES_DIR)

dbt-build:
	./.venv/bin/dbt build --profiles-dir $(DBT_PROFILES_DIR)

dbt-debug:
	./.venv/bin/dbt debug --profiles-dir $(DBT_PROFILES_DIR)
