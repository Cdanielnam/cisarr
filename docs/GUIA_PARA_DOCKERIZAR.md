# Guía para dockerizar "Mayor o Menor"

Documento para la persona del equipo que va a **dockerizar** la app. Aquí está toda la información que necesitas;
**no** se incluye ningún `Dockerfile`, `.dockerignore` ni `docker-compose` a propósito: esas decisiones son tuyas.

> Para entender cómo funciona la app por dentro (componentes, hook, API), lee el [`README.md`](../README.md).

> **Actualización:** la app ya está dockerizada. El `Dockerfile` y el `.dockerignore` están en la raíz del proyecto
> y el paso a paso está en [`GUIA_DOCKER.md`](GUIA_DOCKER.md). Se eligió la **opción 5** de la sección 8 (modo
> desarrollo con `npm run dev -- --host`), que es el método de la guía de clase. Este documento se conserva como
> referencia de los datos que se usaron.

## Resumen rápido

| Dato | Valor |
| --- | --- |
| Tipo de app | **Frontend estático** (React + Vite). **Sin backend y sin base de datos.** |
| Comando de build | `npm run build` |
| Carpeta que genera | `dist/` |
| Versión de Node para construirla | **Node 22** (probado con v22.22.0 y npm 10.9.4; mínimo 22.12) |
| Puerto en desarrollo (`npm run dev`) | **5173** |
| Puerto en preview (`npm run preview`) | **4173** |
| Puerto al servir archivos estáticos | Normalmente **80** (nginx, Apache, Caddy) o **3000** (`serve`) |
| Variables de entorno | **Ninguna** |
| ¿Necesita internet al ejecutarse? | **Sí**, pero lo necesita el **navegador del usuario**, no el contenedor |

---

## 1. Qué tipo de app es

- Es una **SPA (aplicación de una sola página)** hecha con React y Vite en JavaScript.
- **No hay servidor propio ni base de datos.** Toda la lógica corre en el navegador.
- Al ejecutar `npm run build`, Vite convierte el proyecto en **archivos estáticos** (HTML, CSS y JS) dentro de `dist/`.
  Esos archivos se pueden servir con cualquier servidor web.
- **No usa React Router**: hay una sola pantalla y una sola URL (`/`). Por eso **no hace falta** configurar
  redirecciones a `index.html` (el famoso "fallback de SPA").
- Los assets se sirven desde la raíz (`/`). Si algún día se publica en una subruta (por ejemplo `/juego/`), habría
  que configurar la opción `base` en `vite.config.js`.

## 2. Build y carpeta de salida

```bash
npm ci            # instala las dependencias exactas del package-lock.json
npm run build     # genera la carpeta dist/
```

Contenido real de `dist/` después del build:

```text
dist/
├── index.html
├── favicon.svg
└── assets/
    ├── index-<hash>.js     # ~236 kB (≈ 74 kB comprimido)
    └── index-<hash>.css    # ~16 kB (≈ 4 kB comprimido)
```

- Los nombres de `assets/` llevan un *hash* que cambia con cada build. Eso permite configurar caché larga para
  `assets/` y **sin caché** para `index.html`.
- `npm ci` es mejor que `npm install` dentro de una imagen: instala **exactamente** lo que dice
  `package-lock.json` (que ya está en el repositorio) y falla si hay inconsistencias.

## 3. Versión de Node

| Herramienta | Versión probada | Mínimo exigido por las dependencias |
| --- | --- | --- |
| Node.js | v22.22.0 | `^22.12.0` o `>=24` (declarado en `engines` de `package.json`) |
| npm | 10.9.4 | el que trae Node 22 |

- **Usa una imagen base de Node 22** (por ejemplo, la oficial `node:22` o `node:22-alpine`; confirma el nombre exacto
  del *tag* en Docker Hub).
- Con una versión anterior a 22.12 no se garantiza que funcionen las pruebas (Vitest 5 lo exige) ni el lint.
- Node **solo se necesita para construir** la app (y para el modo desarrollo). Para servir `dist/` ya no hace falta.

## 4. Puertos

| Situación | Comando | Puerto |
| --- | --- | --- |
| Desarrollo | `npm run dev` | **5173** |
| Preview del build | `npm run preview` | **4173** |
| Servidor estático en producción | nginx / Apache httpd / Caddy | **80** (lo habitual) |
| Servidor estático con el paquete `serve` | `serve` | **3000** (valor por defecto de esa herramienta) |

Los puertos de Vite (5173 y 4173) vienen de su configuración por defecto y se comprobaron al ejecutar los comandos.
Los de los servidores estáticos son los habituales de cada herramienta: **confírmalos en su documentación**.

> ⚠️ **Importante:** Vite solo escucha en `localhost` por defecto. **Dentro de un contenedor hay que agregar
> `--host`** o no podrás abrir la app desde tu navegador:
> `npm run dev -- --host` o `npm run preview -- --host`. También puedes cambiar el puerto con `--port <número>`.

## 5. Variables de entorno

**La app no usa ninguna variable de entorno.** No existe archivo `.env` y no hace falta definir nada.

- La URL de la API (`https://deckofcardsapi.com/api/deck`) está escrita directamente en `src/services/deckApi.js`.
- Dato útil si algún día se agregan: Vite solo expone las variables que empiezan con `VITE_` y las **inserta en el
  código durante el build**. Por eso tendrían que pasarse **al construir** la imagen, no al ejecutar el contenedor.

## 6. Qué NO copiar a la imagen

| Archivo / carpeta | Por qué no copiarlo |
| --- | --- |
| `node_modules/` | Pesa cientos de MB y puede contener binarios del sistema operativo de tu equipo (Windows/Mac) que no sirven en Linux. Dentro del contenedor se reinstala con `npm ci`. |
| `dist/` | Es el resultado del build. Si construyes **dentro** de Docker, la carpeta local es innecesaria y podría quedar desactualizada. (En la etapa final de la imagen sí va, pero tomada de la etapa de build.) |
| `.git/` | Historial del repositorio: pesa y no sirve para ejecutar la app. |
| `coverage/`, `*.log`, `npm-debug.log*` | Reportes y registros generados al desarrollar. |
| `.env`, `.env.*` | Por seguridad (aunque hoy no existen). Nunca deben terminar dentro de una imagen. |
| `.vscode/`, `.idea/`, `.DS_Store`, `Thumbs.db` | Archivos del editor y del sistema operativo. |
| `docs/` y `README.md` | No se usan en ejecución. No hacen daño, pero agrandan el contexto de build. |
| Archivos de Docker (`Dockerfile`, `.dockerignore`, `docker-compose*.yml`) | No hace falta que estén dentro de la imagen. |

**Sí necesitas copiar** (en la etapa de build): `package.json`, `package-lock.json` (¡no lo excluyas!),
`index.html`, `vite.config.js`, `public/` y `src/`. Los archivos `eslint.config.js` y `src/utils/cartas.test.js`
solo hacen falta si quieres ejecutar `npm run lint` o `npm test` dentro de la imagen.

## 7. La app necesita internet al ejecutarse

La app consume una API pública y descarga imágenes desde internet:

| Qué | Host | Quién lo pide |
| --- | --- | --- |
| API del mazo y las cartas | `https://deckofcardsapi.com` | El **navegador del usuario** |
| Imágenes de las cartas | `https://deckofcardsapi.com/static/img/...` | El **navegador del usuario** |
| Tipografías (opcional) | `https://fonts.googleapis.com` y `https://fonts.gstatic.com` | El **navegador del usuario** |

Qué implica para Docker:

- Las peticiones las hace **el navegador**, no el contenedor. El contenedor solo entrega archivos estáticos, así que
  **no necesita salida a internet en ejecución** (sí durante el build, para `npm ci`).
- La **máquina de quien juega** debe tener internet. Sin conexión, la app muestra
  "No se pudo conectar con la API. Revisa tu internet." con el botón **Reintentar**. Las tipografías son opcionales:
  si no cargan se usan fuentes de respaldo.
- Si agregas cabeceras de seguridad (*Content-Security-Policy*) en el servidor, debes permitir esos hosts: `connect-src`
  e `img-src` hacia `https://deckofcardsapi.com`, `style-src` hacia `https://fonts.googleapis.com` y `font-src` hacia
  `https://fonts.gstatic.com`. Si no, la app dejará de funcionar aunque el contenedor esté bien.
- Servir la app por HTTP o por HTTPS no afecta, porque la API se pide por HTTPS.

## 8. Opciones para servir la app en un contenedor

Todas funcionan; cambia el equilibrio entre **simplicidad**, **tamaño** y **adecuación a producción**.

| # | Opción | Ventajas | Desventajas |
| --- | --- | --- | --- |
| 1 | **Build en varias etapas + nginx** (etapa 1: Node construye `dist/`; etapa 2: nginx sirve `dist/`) | Imagen final **pequeña** (sin Node ni `node_modules`). Servidor pensado para producción: rápido, caché y compresión configurables. Es el patrón más usado. | Hay que entender las etapas (multi-stage). Si quieres caché o cabeceras propias, hay que escribir un archivo de configuración de nginx. |
| 2 | **Build en varias etapas + otro servidor estático** (Caddy o Apache httpd) | Mismas ventajas que nginx. Caddy trae buenos valores por defecto (compresión, HTTPS automático) con poca configuración. | Menos ejemplos en tutoriales (sobre todo Apache en Docker). Igual que la opción 1, requiere multi-stage. |
| 3 | **Build en varias etapas + `serve` en una imagen de Node** | No hay que configurar nginx; muy poco texto. | La imagen final **incluye Node** (más pesada). Es un paquete extra que habría que instalar solo para esto. Menos control que nginx. |
| 4 | **Una sola etapa con `npm run preview -- --host`** | La más **simple**: instalar, construir y ejecutar. Útil para una demo rápida. | Vite indica que `preview` es para **probar** el build, **no para producción**. La imagen es **grande** (Node + todas las dependencias de desarrollo). |
| 5 | **Modo desarrollo con `npm run dev -- --host`** (normalmente con *volumen* para ver cambios en vivo) | Ideal para **desarrollar** dentro de Docker: recarga automática. | **No es para producción.** Imagen grande y arranque más lento. En Windows/Mac, detectar cambios en carpetas montadas puede ser lento o fallar. |

Pistas para decidir:

- Para una entrega o demo que se vea **profesional**, lo más habitual es la **opción 1** (o la 2).
- Si lo que importa es **tener algo corriendo rápido** para la exposición, la opción 4 funciona, sabiendo que es un
  compromiso.
- Las opciones 1 a 3 necesitan **dos etapas**: una con Node para construir y otra solo para servir `dist/`.
- Como la app no tiene rutas, **no** necesitas la regla de "devolver `index.html` si la ruta no existe".

## 9. Checklist para comprobar que funciona dentro del contenedor

Primero, **fuera de Docker**, asegúrate de que el proyecto está sano:

- [ ] `npm ci` termina sin errores.
- [ ] `npm run lint` termina sin errores ni advertencias.
- [ ] `npm test` muestra las 23 pruebas en verde.
- [ ] `npm run build` termina sin errores y se crea `dist/` con `index.html` y `assets/`.
- [ ] `npm run preview` abre el juego en <http://localhost:4173> y se puede jugar.

Después, **ya dentro del contenedor**:

- [ ] La **imagen se construye sin errores** (`docker build`).
- [ ] El **contenedor arranca** y se queda en ejecución (`docker ps` lo muestra; `docker logs` no tiene errores).
- [ ] El **puerto está publicado** y se abre en el navegador del equipo anfitrión (p. ej. <http://localhost:8080>).
- [ ] Se ve la **pantalla de carga** y luego aparece la **primera carta** (significa que la API responde).
- [ ] Se ve el **diseño completo**: mesa verde, tipografía y estilos (si se ve sin estilos, los archivos de `assets/`
      no se están sirviendo bien).
- [ ] Las **imágenes de las cartas** se ven (si aparecen dibujadas con texto, el navegador no alcanza
      `deckofcardsapi.com`).
- [ ] Se puede **jugar**: Mayor / Menor con el mouse y con las teclas `↑` y `↓`. Cambian puntos, vidas y racha.
- [ ] Al perder las 3 vidas aparece **Game over** y **Jugar de nuevo** (o `Enter`) reinicia la partida.
- [ ] Al **recargar la página** el **récord** se mantiene.
- [ ] En las herramientas del navegador (`F12`) la pestaña **Console** no muestra errores y en **Network** los archivos
      `.js` y `.css` devuelven código **200**.
- [ ] **Recargar la página** en `/` funciona (no hay otras rutas que probar).
- [ ] Prueba del error: desconecta internet (F12 → Network → *Offline*) y recarga: debe verse
      "No se pudo conectar con la API. Revisa tu internet." con **Reintentar**.
- [ ] La **imagen final es razonablemente pequeña** (con nginx u otro servidor estático debería ser de decenas de MB,
      no cientos).
- [ ] Revisa con `docker history` o `docker image inspect` que **no entraron** `node_modules`, `.git` ni archivos
      `.env`.

## 10. Datos útiles para decidir

| Dato | Valor |
| --- | --- |
| Peso de `dist/` | ~254 kB en total (253 704 bytes) |
| Tiempo de build (referencia) | menos de 1 segundo con Vite |
| Dependencias de ejecución | `react` y `react-dom` (se empaquetan dentro de `dist/`, no hacen falta en el servidor) |
| Dependencias de desarrollo | Vite, `@vitejs/plugin-react`, Vitest, ESLint y sus plugins |
| Lockfile | `package-lock.json` (`lockfileVersion` 3) |
| Ruta de comprobación de salud | `GET /` debe responder **200** con el HTML de la app |
