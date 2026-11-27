# Proyecto Grupal Capstone · Plataforma de Gestión integrada con SAP Business One

Proyecto de título de Ingeniería en Informática — Duoc UC, Sede Plaza Norte (PTY4614 · Capstone_006V).
Profesor guía: Álvaro Mellado.

**Equipo (grupo 2):** Alexssander López, Millaray Espósito y Matías Orellana.
**Organización:** Grupo Gómez Hermanos.

Este repositorio reúne la **documentación y las evidencias** del proyecto. El código fuente de la
plataforma está en el repositorio [`Proy-Capstone`](https://github.com/matias12rt/Proy-Capstone).

## El proyecto

Plataforma web interna que reemplaza el correo, las planillas Excel y los seguimientos manuales
en los procesos que rodean a SAP Business One: solicitudes de código de producto, cotizaciones y
notas de venta con autorización, y posventa. Lo aprobado se registra directamente en SAP por su
interfaz oficial (Service Layer), y las consultas de productos, stock y clientes se leen de SAP
HANA con una API propia de solo lectura. La interfaz es responsiva: se usa en computador, tablet
y teléfono.

La plataforma no busca eludir el licenciamiento de SAP (decisión D-02). Se conecta al Service Layer
con un usuario técnico de integración y lee HANA con un usuario de base de datos que solo tiene
permiso de consulta. La versión de la empresa opera en producción con el modelo de licencias de
acceso indirecto (decisión D-17): cada usuario nuevo de la plataforma recibe su licencia antes de
usarla. La lectura directa sobre HANA se mantiene sujeta a la validación escrita del partner de SAP
(D-17, restricción X-04, riesgo R-03); si no la aprueba, las consultas de la API se reemplazan por
lecturas del Service Layer sin cambiar las pantallas.

### Despliegue y acceso remoto

La plataforma corre **on-premise** (en contenedores Docker o como servicio directo), en un servidor de aplicaciones de la red interna de
la empresa, junto a SAP Business One: el Service Layer y SAP HANA nunca se publican hacia internet y
la plataforma los usa por la red interna (usuario técnico del Service Layer y usuario de HANA solo
de consulta, D-17). Para entrar desde fuera de la red se usa un **túnel de Cloudflare** (conector
`cloudflared` como servicio, conexión solo saliente: sin puertos de entrada, sin IP pública ni VPN)
protegido con **Cloudflare Access**, que exige la **cuenta corporativa de Microsoft 365** (Microsoft
Entra ID) antes de llegar a la plataforma, que luego pide su propio inicio de sesión (doble capa,
decisión D-17). Dentro de la red se entra por la dirección interna. La dependencia de Cloudflare
para el acceso externo se registra en el riesgo R-18 (falla de correo, contenedores o acceso
remoto). El correo sale por Microsoft 365 en producción y por Mailpit en la demostración (D-16). El
detalle (topología, configuración de Django detrás del túnel y pasos de Cloudflare y Entra ID) está
en la guía `docs/despliegue_on_premise.md` del repositorio del código. Las tablas de SAP que lee o
escribe la plataforma, por Service Layer o por la API de consultas, se documentan en el **Mapa de
tablas SAP - Service Layer y API**.

### Innovación y valor

- **Qué problema resuelve:** solicitudes perdidas entre correos, trámites sin responsable ni
  estado visible, doble digitación en SAP y márgenes o comisiones que se conocían recién después
  de vender.
- **Qué lo hace diferente:** autoriza y registra en SAP en un solo paso, controla el margen antes
  de vender (segunda firma de Gerencia bajo el margen mínimo), valida contra el inventario real al
  enviar, deja trazabilidad de punta a punta y funciona completa en un modo simulado sin tocar la
  base productiva.
- **Qué valor agrega:** un solo lugar para pedir, autorizar y seguir cada trámite, menos errores y
  trabajo manual, control comercial, auditoría de quién hizo qué y cuándo, y uso desde cualquier
  dispositivo.

## Metodología

Scrum, con 6 sprints entre el 31-08-2026 y el 13-11-2026: los Sprints 1 a 5 de dos semanas y el
Sprint 6 (09-11-2026 al 13-11-2026) de una semana. La carga se repartió de forma pareja: 34, 37,
37, 37, 34 y 17 SP por sprint (unos 35 SP por sprint de dos semanas). Las 43 historias forman un
único Product Backlog, priorizado por valor para el negocio, riesgo y esfuerzo (MoSCoW) desde la
planificación (decisión D-14): se comprometieron 35 historias (196 SP) en los 6 sprints, respetando
las dependencias técnicas (primero usuarios, permisos e integración; luego solicitudes y consultas,
ventas, posventa y trazabilidad; en los Sprints 5 y 6, las mejoras comerciales y consolas HU-021 a
HU-035, que dependen de esos módulos), y 8 quedaron no priorizadas como trabajo futuro (HU-036 a
HU-043, 84 SP; decisión D-19): facturación
desde la plataforma, aplicación móvil nativa, reportería avanzada (BI), mesa de ayuda de TI,
creación de clientes en SAP, devoluciones de dinero, avisos por WhatsApp o SMS y seguimiento de
despachos con transportistas. Durante el proyecto se registraron además las decisiones de
integridad y seguridad comercial (D-15), correo y documentos (D-16), infraestructura y licencias
(D-17) y catálogo de consultas de solo lectura (D-18). El Product Backlog queda con 43 historias
(280 SP), y el proyecto cierra con 35 historias y 196 SP terminados y aceptados por el Product
Owner, 123 casos de prueba aprobados (CP-001 a
CP-123) y la versión final v0.6.0 del producto (1.951 pruebas automatizadas de la plataforma y 246
de la API de consultas, sin fallas). Las responsabilidades de Product Owner, Scrum Master y
responsable de integración rotan en cada sprint (ver el Acuerdo de trabajo Scrum).

## Estructura

| Carpeta | Contenido |
|---|---|
| `Fase_1/` | Definición del proyecto (Guía 1.5), presentación y evidencias individuales. |
| `Fase_2/Evidencias Proyecto/` | Todos los documentos del proyecto (producto, gestión, Scrum, pruebas, requisitos, arquitectura e integración con SAP), en una sola carpeta. El índice siguiente los agrupa por responsable. |
| `Fase_2/Evidencias_Grupales/`, `Fase_2/Evidencias_Individuales/` | Guías e informe de avance de la fase y diarios de reflexión. |
| `Fase_3/` | Evidencias de la fase de cierre. |

## Índice de documentos

Todos están en `Fase_2/Evidencias Proyecto/`.

**Matías Orellana (producto, interesados y gestión del proyecto):** Carta de constitución del
proyecto · Registro de interesados · Matriz RACI · Matriz de comunicaciones · Registro de riesgos,
decisiones y restricciones · Product Vision y Product Goal · Alcance funcional detallado · Catálogo
de procesos AS-IS y TO-BE · Product Backlog · Matriz de trazabilidad · Manual de usuario · Acta de
cierre y aceptación.

**Millaray Espósito (Scrum, sprints, calidad y pruebas):** Acuerdo de trabajo Scrum · Definition of
Done · Sprint 1 a Sprint 6 - Sprint Backlog, Review y Retrospectiva (un expediente por sprint) ·
Carta Gantt de sprints · Pruebas - Estrategia de pruebas · Pruebas - Informe final · Prototipos y
diseño de interfaces.

**Alexssander López (requisitos, arquitectura e integración con SAP):** SRS - Especificación de
requisitos · Requisitos no funcionales · Arquitectura · Arquitectura - 4+1 · Diagramas UML · Modelo
de datos · Modelo de datos y arquitectura actualizados · Especificación de integración y API ·
Especificación final de integración con SAP Business One · Mapa de tablas SAP - Service Layer y API
(tablas y campos de SAP que usa la plataforma y por qué vía) · Informe de seguridad, roles y control
de accesos · Manual técnico · Colección Postman-Bruno (carpeta `Coleccion Postman-Bruno/`, con su
`LEEME.md`) · Despliegue Docker (carpeta `Despliegue Docker/`: `Dockerfile`, `docker-compose.yml`,
plantillas `.env` y README de instalación).

## Cómo levantar la plataforma

La plataforma se levanta con Docker desde el repositorio de código
[`Proy-Capstone`](https://github.com/matias12rt/Proy-Capstone), en modo SAP simulado y con datos
ficticios de demostración:

```bash
git clone https://github.com/matias12rt/Proy-Capstone.git
cd Proy-Capstone
cp .env.docker.example .env.docker      # Windows: copy .env.docker.example .env.docker
docker compose --env-file .env.docker up -d --build
```

Luego se abre **http://localhost:8080** (los correos de la demostración se ven en
http://localhost:8025). Los archivos de despliegue (`Dockerfile`, `docker-compose.yml`,
`.env.example`, `.env.docker.example` y la configuración de Nginx) están también en
`Fase_2/Evidencias Proyecto/Despliegue Docker/`, con su README paso a paso, los servicios y los
comandos útiles.

## Tecnologías

| Capa | Tecnologías |
|---|---|
| Lenguajes | Python 3.12 · JavaScript · HTML y CSS · SQL |
| Frameworks | Django 5.2 (plataforma) · FastAPI + Uvicorn (API de consultas de solo lectura) · Bootstrap 5.3 |
| ERP | SAP Business One: Service Layer (escritura) y SAP HANA (lectura, solo consulta) |
| Base de datos | PostgreSQL 16 (contenedores y producción) · SQLite (desarrollo y pruebas) |
| DevOps | Docker y Docker Compose · Nginx (proxy inverso) · gunicorn · WhiteNoise |
| Correo | Microsoft 365 (producción) · Mailpit (demostración) |
| Acceso remoto | Cloudflare Tunnel y Cloudflare Access con Microsoft Entra ID |
| Pruebas | unittest (Django Test Framework) · FastAPI TestClient · Postman y Bruno (colección de la API) |
| Documentos | WeasyPrint y xhtml2pdf (PDF) · openpyxl (Excel) |
| Versionado | Git y GitHub (ramas `main`, `develop` y `feature/HU-xxx`, Pull Requests) |
| Servidor | Windows Server 2016 (on-premise) |

> Todos los datos de ejemplo, capturas y usuarios de demostración son ficticios.
