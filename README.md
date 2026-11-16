# Proyecto Grupal Capstone · Plataforma de Gestión integrada con SAP Business One

Proyecto de título de Ingeniería en Informática — Duoc UC, Sede Plaza Norte (PTY4614 · Capstone_006V).
Profesor guía: Álvaro Mellado.

**Equipo (grupo 2):** Alexssander López, Millaray Espósito y Matías Orellana.
**Organización:** Grupo Gómez Hermanos.

Este repositorio reúne la **documentación y las evidencias** del proyecto. El código fuente de la
plataforma está en el repositorio `Proy-Capstone`.

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
acceso indirecto (D-25): cada usuario nuevo de la plataforma recibe su licencia antes de usarla. La
lectura directa sobre HANA se mantiene sujeta a la validación escrita del partner de SAP (D-26,
restricción X-04); si no la aprueba, las consultas de la API se reemplazan por lecturas del Service
Layer sin cambiar las pantallas.

### Despliegue y acceso remoto

La plataforma corre **on-premise**, en un servidor de aplicaciones de la red interna de la empresa,
junto a SAP Business One: el Service Layer y SAP HANA nunca se publican hacia internet y la
plataforma los usa por la red interna (usuario técnico del Service Layer, D-25, y usuario de HANA
solo de consulta, D-26). Para entrar desde fuera de la red se usa un **túnel de Cloudflare**
(conector `cloudflared` como servicio, conexión solo saliente: sin puertos de entrada, sin IP
pública ni VPN) protegido con **Cloudflare Access**, que exige la **cuenta corporativa de
Microsoft 365** (Microsoft Entra ID) antes de llegar a la plataforma, que luego pide su propio
inicio de sesión (doble capa, decisión D-29). Dentro de la red se entra por la dirección interna.
La dependencia de Cloudflare para el acceso externo se registra como riesgo R-19. El detalle
(topología, configuración de Django detrás del túnel y pasos de Cloudflare y Entra ID) está en la
guía `docs/despliegue_on_premise.md` del repositorio del código. Las tablas de SAP que lee o escribe la
plataforma, por Service Layer o por la API de consultas, se documentan en el **Mapa de tablas SAP -
Service Layer y API**.

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

Scrum, con 6 sprints entre el 31-08-2026 y el 13-11-2026, más un Sprint 7 de extensión propuesto
(16-11-2026 al 04-12-2026) para las solicitudes de cambio surgidas en la operación (decisión D-19), pendiente de
aprobación del docente. El código de sus 12 historias se preparó el 10 y 11-11-2026 desde la versión en producción y se
integra por etapas (18 a 40) durante el sprint (decisión D-24), junto con las funciones de la versión en producción
agregadas tras validarla contra ella (D-27) y sus correcciones de integridad y seguridad (D-28). Las responsabilidades de Product Owner,
Scrum Master y responsable de integración rotan en cada sprint (ver el Acuerdo de trabajo Scrum).

## Estructura

| Carpeta | Contenido |
|---|---|
| `Fase_1/` | Definición del proyecto (Guía 1.5), presentación y evidencias individuales. |
| `Fase_2/Evidencias Proyecto/Mati/` | Producto, interesados y gestión del proyecto. |
| `Fase_2/Evidencias Proyecto/Milla/` | Scrum, sprints, calidad y pruebas. |
| `Fase_2/Evidencias Proyecto/Ale/` | Requisitos, arquitectura e integración con SAP. |
| `Fase_2/Evidencias_Grupales/`, `Fase_2/Evidencias_Individuales/` | Guías de la fase y diarios de reflexión. |
| `Fase_3/` | Evidencias de la fase de cierre. |

## Índice de documentos

**Mati:** Carta de constitución del proyecto · Registro de interesados · Matriz RACI · Matriz de
comunicaciones · Registro de riesgos, decisiones y restricciones · Product Vision y Product Goal ·
Alcance funcional detallado · Catálogo de procesos AS-IS y TO-BE · Product Backlog · Matriz de
trazabilidad · Manual de usuario · Acta de cierre y aceptación.

**Milla:** Acuerdo de trabajo Scrum · Definition of Done · Sprint 1 a Sprint 7 (Sprint Backlog,
Review y Retrospectiva; el Sprint 7 es una extensión propuesta) · Carta Gantt de sprints · Pruebas - Estrategia de pruebas · Pruebas -
Informe final · Prototipos y diseño de interfaces.

**Ale:** SRS - Especificación de requisitos · Requisitos no funcionales · Arquitectura ·
Arquitectura - 4+1 · Diagramas UML · Modelo de datos · Modelo de datos y arquitectura actualizados ·
Especificación de integración y API · Especificación final de integración con SAP Business One ·
Mapa de tablas SAP - Service Layer y API (tablas y campos de SAP que usa la plataforma y por qué vía) ·
Informe de seguridad, roles y control de accesos · Manual técnico · Colección Postman-Bruno.

## Tecnologías

Python 3.12 · Django 5.2 · FastAPI · SAP Business One Service Layer · SAP HANA · PostgreSQL ·
Bootstrap 5 · Docker · Cloudflare Tunnel y Cloudflare Access con Microsoft Entra ID (acceso remoto) ·
Windows Server 2016.

> Todos los datos de ejemplo, capturas y usuarios de demostración son ficticios.
