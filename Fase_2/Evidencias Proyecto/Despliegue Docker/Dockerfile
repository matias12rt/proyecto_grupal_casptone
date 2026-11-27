# Imagen de la plataforma (Django + gunicorn).
# Construir desde la raíz del proyecto:  docker compose build
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Librerías de sistema que necesita WeasyPrint para el PDF de las cotizaciones
# (Pango, HarfBuzz y fuentes). psycopg[binary] trae su propio libpq.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpango-1.0-0 libpangoft2-1.0-0 libharfbuzz0b libharfbuzz-subset0 \
        fonts-dejavu-core \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

# Estáticos comprimidos y con huella (WhiteNoise). La clave solo se usa en
# este paso de construcción; en ejecución viene de las variables de entorno.
RUN DJANGO_SECRET_KEY=solo-para-collectstatic DEBUG=False \
    python manage.py collectstatic --noinput \
    && mkdir -p /app/media /app/logs \
    && useradd --create-home --uid 1000 plataforma \
    && chown -R plataforma:plataforma /app/media /app/logs \
    && chmod +x docker/entrypoint.sh

USER plataforma

EXPOSE 8000
ENTRYPOINT ["docker/entrypoint.sh"]
CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "120", "--access-logfile", "-"]
