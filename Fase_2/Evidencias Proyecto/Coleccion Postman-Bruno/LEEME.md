# Colección Postman / Bruno — Integración SAP B1

## Archivos
| Archivo | Contenido |
|---|---|
| `Proy-Capstone.postman_collection.json` | Colección completa (Service Layer + API de consultas). |
| `SAP-Test.postman_environment.json` | Entorno para el Service Layer sobre las bases Test. |
| `API-de-consultas.postman_environment.json` | Entorno para la API de consultas (`api2`). |

## Importar
- **Postman:** Import → arrastrar los tres archivos. Elegir el entorno arriba a la derecha.
- **Bruno:** Import Collection → *Postman Collection* → elegir el `.json` de la colección.
  Crear los entornos con las mismas variables (o importarlos si la versión lo permite).

## Configurar
1. Completar `sap_user`, `sap_pass` e `item_series` en **SAP Test**, y `api_key_secret` en
   **API de consultas** (el mismo `API_KEY_SECRET` del `.env`). No guardar credenciales en el
   repositorio.
2. En el Service Layer desactivar la verificación SSL si el certificado es autofirmado
   (Settings → SSL certificate verification) solo en el ambiente de pruebas.

## Ejecutar
- **Service Layer:** ejecutar `01 Login` y luego las carpetas en orden (Maestros → Solicitud de
  código → Cotizaciones → Órdenes de venta → Trazabilidad). Las pruebas guardan `DocEntry`/`DocNum`
  para las peticiones siguientes. **Solo contra bases Test**.
- **API de consultas:** la firma HMAC se calcula sola (pre-request de la carpeta).
- **Runner:** Postman *Run collection* / Bruno *Run* genera el reporte de resultados que sirve
  como evidencia de pruebas.

## Firma HMAC versión 2
La pre-request de la carpeta «API de consultas» calcula la **firma v2** que exige la versión final
de la API (`api2/app/firma.py`):

```
HMAC-SHA256(secret, '<KeyId>.<Timestamp>.<MÉTODO>.<ruta>?<query ordenada>')
```

- La query se ordena por clave y valor y se codifica igual que `urlencode` de Python (espacio
  como `+`; se codifican también `! ' ( ) *`).
- Se envía además la cabecera `X-API-Signature-Version: 2`.
- La firma antigua (`'<KeyId>.<Timestamp>'`) se rechaza con 401, salvo que en `api2/.env` se
  active temporalmente `HMAC_ACEPTAR_FIRMA_V1=true`.
- El cálculo del script se verificó contra el de la API con el mismo mensaje: ambas firmas son
  idénticas, incluidos acentos, espacios, paréntesis y parámetros repetidos.

Los listados `/api/productos` y `/api/socios` aceptan además `page` y `page_size` (máximo 200) y
devuelven el total en la cabecera `X-Total-Count`.
