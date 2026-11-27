# Cómo levantar la plataforma con Docker

Esta carpeta trae los archivos de despliegue de la plataforma, copiados tal cual desde la raíz
del repositorio de código [`Proy-Capstone`](https://github.com/matias12rt/Proy-Capstone), para
revisarlos sin entrar a ese repositorio. Para levantar la plataforma se usan desde el repositorio
de código, porque la imagen se construye con todo el proyecto.

| Archivo | Para qué sirve |
|---|---|
| `Dockerfile` | Imagen de la plataforma: Python 3.12, Django 5.2 y gunicorn. Instala las librerías del PDF (WeasyPrint) y prepara los estáticos con WhiteNoise. Corre con un usuario sin privilegios. |
| `docker-compose.yml` | Levanta los servicios: PostgreSQL 16, la plataforma, Nginx y Mailpit (y la API de consultas solo con SAP real). |
| `.env.docker.example` | Plantilla de las variables de los contenedores. Se copia a `.env.docker`, que no se sube al repositorio. |
| `.env.example` | Plantilla de variables para correr sin Docker (desarrollo local). Se copia a `.env`. |
| `docker/entrypoint.sh` | Arranque del contenedor web: espera a PostgreSQL, aplica las migraciones, asigna los permisos iniciales y, si se pide, carga los datos de demostración. |
| `docker/nginx/default.conf` | Proxy inverso delante de gunicorn. No publica `/media/`: los adjuntos solo se entregan a quien tiene permiso. |
| `.dockerignore` | Deja fuera de la imagen el entorno virtual, las bases locales y los archivos `.env`. |

## Requisitos

- Docker Desktop (Windows o macOS) o Docker Engine con Compose v2 (Linux).
- Git.
- No se necesita acceso a SAP: por defecto la plataforma funciona en **modo simulado**, con datos ficticios.

## Pasos

1. Clonar el repositorio de código y entrar a la carpeta:

   ```bash
   git clone https://github.com/matias12rt/Proy-Capstone.git
   cd Proy-Capstone
   ```

2. Crear el archivo de variables a partir de la plantilla:

   ```bash
   cp .env.docker.example .env.docker      # Windows: copy .env.docker.example .env.docker
   ```

   Editar `.env.docker` y cambiar `DJANGO_SECRET_KEY` y las dos contraseñas de PostgreSQL
   (`POSTGRES_PASSWORD` y `DB_PASSWORD`, con el mismo valor).

3. Construir y levantar los servicios:

   ```bash
   docker compose --env-file .env.docker up -d --build
   ```

   La primera vez tarda unos minutos. El contenedor web aplica las migraciones y, con
   `CARGAR_DEMO=1`, carga los datos ficticios de demostración.

4. Abrir la plataforma en **http://localhost:8080**. Los usuarios de demostración y su contraseña
   están en el README del repositorio de código (sección «Usuarios de demostración»).

5. Los correos que envía la plataforma (avisos, documentos, recuperación de contraseña) se ven en
   Mailpit, en **http://localhost:8025**. No se entrega nada a direcciones reales.

## Servicios

| Servicio | Imagen | Puerto | Función |
|---|---|---|---|
| `db` | `postgres:16-alpine` | interno | Base de datos de la plataforma (volumen `pgdata`). |
| `web` | `plataforma-ggh` (este `Dockerfile`) | interno 8000 | Django con gunicorn. |
| `nginx` | `nginx:1.27-alpine` | **8080** | Proxy inverso: es la dirección por la que se entra. |
| `mailpit` | `axllent/mailpit` | **8025** | Buzón de prueba para los correos de la demostración. |
| `api2` | `./api2` | interno 8001 | API de consultas de solo lectura sobre SAP HANA. Solo con SAP real (perfil `sap-real`). |

## Comandos útiles

```bash
docker compose ps                                            # estado de los servicios
docker compose logs -f web                                   # registro de la plataforma
docker compose exec web python manage.py cargar_datos_demo --reset   # recargar la demostración
docker compose exec db pg_dump -U plataforma plataforma > respaldo.sql   # respaldo de la base
docker compose down                                          # detener (conserva los datos)
docker compose down -v                                       # detener y borrar la base
```

## Sin Docker (desarrollo)

```bash
python -m venv venv
venv\Scripts\activate                 # Linux / macOS: source venv/bin/activate
pip install -r requirements.txt
copy .env.example .env                # Linux / macOS: cp .env.example .env
python manage.py migrate
python manage.py asignar_permisos_iniciales
python manage.py cargar_datos_demo
python manage.py runserver            # http://127.0.0.1:8000
```

Así se usa SQLite y SAP en modo simulado. El despliegue en el servidor de la empresa
(on-premise, con túnel de Cloudflare y Microsoft 365) está en el Manual técnico y en
`docs/despliegue_on_premise.md` del repositorio de código.

> Todos los datos de la demostración son ficticios. Las plantillas `.env*.example` no contienen
> claves reales: cada instalación define las suyas.
