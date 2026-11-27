#!/bin/sh
# Arranque del contenedor web: espera la base de datos, aplica las migraciones
# y, si se pide, carga los datos de demostración antes de iniciar gunicorn.
set -e

if [ "${DB_ENGINE}" = "django.db.backends.postgresql" ]; then
    echo "Esperando a PostgreSQL en ${DB_HOST}:${DB_PORT:-5432}..."
    python - <<'PY'
import os, sys, time
import psycopg
for intento in range(60):
    try:
        psycopg.connect(
            host=os.environ["DB_HOST"], port=os.environ.get("DB_PORT", "5432"),
            dbname=os.environ["DB_NAME"], user=os.environ["DB_USER"],
            password=os.environ["DB_PASSWORD"], connect_timeout=2,
        ).close()
        sys.exit(0)
    except psycopg.OperationalError:
        time.sleep(1)
print("PostgreSQL no respondió a tiempo.", file=sys.stderr)
sys.exit(1)
PY
fi

python manage.py migrate --noinput
python manage.py asignar_permisos_iniciales

if [ "${CARGAR_DEMO:-0}" = "1" ]; then
    python manage.py cargar_datos_demo
fi

exec "$@"
