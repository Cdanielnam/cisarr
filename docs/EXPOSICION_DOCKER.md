# Exposición y documentación de la dockerización — Persona 4

Material para la actividad **#11 de la agenda del Período IV (FWA)**: *"Demostrar mediante exposición la
dockerización de una app React"*. Está escrito para la persona que dockerizó la app, pero el resto del equipo puede
usarlo para la parte de Docker de la exposición.

> El paso a paso con los comandos está en [`GUIA_DOCKER.md`](GUIA_DOCKER.md). Aquí está **qué decir**, **qué
> mostrar** y **qué entregar** para cumplir la rúbrica.

## Índice

1. [Lo que pide la agenda](#1-lo-que-pide-la-agenda)
2. [Guion de la exposición (mi parte, 6-8 minutos)](#2-guion-de-la-exposición-mi-parte-6-8-minutos)
3. [Demostración en vivo: orden exacto](#3-demostración-en-vivo-orden-exacto)
4. [Defensa de la arquitectura (criterio 7)](#4-defensa-de-la-arquitectura-criterio-7)
5. [Problemas encontrados y soluciones (criterios 3 y 4)](#5-problemas-encontrados-y-soluciones-criterios-3-y-4)
6. [Documentación de mi parte (paso 5 de la agenda)](#6-documentación-de-mi-parte-paso-5-de-la-agenda)
7. [Mapa criterio → evidencia](#7-mapa-criterio--evidencia)
8. [Preguntas probables de la profesora](#8-preguntas-probables-de-la-profesora)
9. [Autoevaluación: preguntas de reflexión](#9-autoevaluación-preguntas-de-reflexión)

---

## 1. Lo que pide la agenda

| Dato | Valor |
| --- | --- |
| Actividad | #11 — Demostrar mediante exposición la dockerización de una app React |
| Asignatura | Frameworks o FWA · docente Katherine Abigail Canales de Rivera |
| Fecha | viernes 2 de octubre de 2026, en el colegio |
| Agrupamiento | Equipos medianos (5-6) |
| Ponderación | **35 %** del período |
| Producto entregable | **Proyecto y Exposición — Código y Presentación** |
| Instrumentos | Rúbrica de evaluación (10 pts) y rúbrica de autoevaluación (1 pt) |

**Paso a paso de la agenda** y dónde queda cubierto cada uno:

| Paso | Qué pide | Dónde está |
| --- | --- | --- |
| 1. Investigar Docker | Qué es, para qué sirve, contenedor vs. máquina virtual, ventajas, ejemplos reales | Sección 2 de este documento y sección 2 de `GUIA_DOCKER.md` |
| 2. Desarrollar la aplicación | React con Vite, al menos 5 componentes, `useState`/`useEffect`, API pública opcional | La app tiene **12 componentes**, el hook `useJuego` y consume la API Deck of Cards (`README.md`) |
| 3. Dockerizar la aplicación | Dockerfile, `.dockerignore`, `docker build`, `docker run`, verificar | `Dockerfile`, `.dockerignore` y `GUIA_DOCKER.md` |
| 4. Exponer el proyecto | Proceso, Dockerfile, comandos, configuraciones, ejecutar en vivo, responder preguntas | Secciones 2, 3, 4 y 8 de este documento |
| 5. Documentar | Describir la app, el proceso de Docker, los comandos y evidencias | Sección 6 de este documento + `README.md` + capturas |

**Criterios de la rúbrica (10 puntos):**

| # | Criterio | Peso | Quién lo cubre |
| --- | --- | --- | --- |
| 1 | Estructura la aplicación de manera organizada, identificando la función de sus componentes y justificando las decisiones técnicas | 15 % | Todo el equipo (Persona 1 explica los componentes) |
| 2 | Implementa componentes funcionales con React y Vite, buenas prácticas y organización del código | 25 % | Personas 1 y 2 |
| 3 | **Verifica el funcionamiento de la aplicación dentro del contenedor, identificando y corrigiendo errores** | 10 % | **Persona 4** |
| 4 | **Explica y justifica las decisiones de configuración de Docker, proponiendo soluciones ante problemas** | 10 % | **Persona 4** |
| 5 | Desarrolla una aplicación funcional con React y Vite, integrando componentes y dependencias | 15 % | Personas 2 y 3 |
| 6 | **Integra la app React con la configuración de Docker, documentando estructura y funcionamiento** | 10 % | **Persona 4** |
| 7 | **Defiende la arquitectura (React + Vite + Docker) por escalabilidad, mantenibilidad, costos y requerimientos** | 15 % | **Persona 4** con apoyo del equipo |

La parte de Docker vale **4,5 de los 10 puntos** (criterios 3, 4, 6 y 7). Para el nivel *Sobresaliente* la rúbrica
pide: verificar **de forma autónoma**, explicar con **solvencia técnica** el Dockerfile y el `.dockerignore`,
documentar **estructura, comandos y funcionamiento**, y defender la arquitectura con **argumentos técnicos**.

## 2. Guion de la exposición (mi parte, 6-8 minutos)

Cada bloque tiene lo que se dice y lo que se muestra en pantalla. Habla en primera persona: la rúbrica evalúa que
**tú** sepas explicarlo.

### Bloque 1 — Qué es Docker y por qué lo usamos (1 min) · paso 1 de la agenda

> "Mi parte fue dockerizar la aplicación. Docker es una plataforma que empaqueta una app con todo lo que necesita
> para ejecutarse —en nuestro caso Node, las dependencias de npm y el código— en una unidad llamada **imagen**. Cuando
> esa imagen se ejecuta se llama **contenedor**. La diferencia con una máquina virtual es que el contenedor no trae un
> sistema operativo completo: comparte el kernel del equipo, por eso pesa menos y arranca en segundos.
>
> El problema que nos resolvía era concreto: la app pide Node 22.12 o superior. Sin Docker, cada integrante tenía que
> instalar esa versión y ejecutar `npm install`; con Docker, cualquiera con Docker Desktop ejecuta exactamente lo mismo
> que yo. Es el típico 'en mi máquina sí funciona' resuelto."

**Mostrar:** nada todavía, o la primera diapositiva con el flujo *Dockerfile → `docker build` → imagen → `docker run`
→ contenedor*.

### Bloque 2 — Qué tenía que dockerizar (1 min) · criterios 1 y 6

> "Antes de escribir el Dockerfile tuve que entender qué tipo de app era. Es una **SPA con React 19 y Vite 8**: no
> tiene backend ni base de datos; toda la lógica corre en el navegador y los datos vienen de la API pública Deck of
> Cards. Eso define la arquitectura de Docker: **un solo contenedor**, sin `docker-compose`, sin volúmenes de base de
> datos y sin variables de entorno. Los datos que necesitaba eran: la versión de Node (22.12+), el comando de build
> (`npm run build`), el puerto de Vite (5173) y qué archivos no debían entrar a la imagen."

**Mostrar:** la estructura de carpetas del `README.md` (sección 5) o `docs/GUIA_PARA_DOCKERIZAR.md`.

### Bloque 3 — El Dockerfile, línea por línea (2 min) · criterio 4

> "El Dockerfile es la receta de la imagen. Tiene ocho instrucciones:"

```dockerfile
FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
EXPOSE 5173
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
```

> "- `FROM node:24-alpine`: la imagen base. Elegí Node 24 porque el `package.json` exige `^22.12 || >=24`, y
>   `alpine` porque es una distribución de Linux de unos 5 MB, así la imagen pesa menos.
> - `WORKDIR /app`: crea la carpeta `/app` dentro del contenedor y trabaja ahí.
> - `COPY package*.json ./` y luego `RUN npm install`: copio **solo** los dos archivos de dependencias e instalo.
>   Lo hago antes de copiar el código por la **caché de capas**: si cambio código, Docker reutiliza la capa de
>   `npm install` y el rebuild tarda segundos en vez de minutos.
> - `COPY . .`: copio el resto del proyecto, menos lo que está en `.dockerignore`.
> - `RUN npm run build`: compilo para producción. Sirve de verificación: si el código tiene un error, la imagen no se
>   construye.
> - `EXPOSE 5173`: documenta el puerto. **No lo abre**; el que lo publica es `-p` en `docker run`.
> - `CMD [...]`: el comando que corre cada vez que arranca el contenedor. `--host 0.0.0.0` es obligatorio: Vite por
>   defecto solo escucha en `localhost`, y dentro del contenedor `localhost` es el contenedor mismo, no mi PC."

**Mostrar:** el `Dockerfile` abierto en VS Code.

### Bloque 4 — El `.dockerignore` (30 s) · criterio 4

> "El `.dockerignore` dice qué no copiar a la imagen. Partí del `.gitignore`, como en la guía de clase, y le quité
> `dist/`, `dist-ssr/` y `*.local`. Lo más importante que queda fuera es `node_modules`: pesa cientos de MB y trae
> binarios compilados para Windows; dentro del contenedor, que es Linux, no sirven. Por eso las dependencias se
> instalan **dentro** con `npm install`. También dejé fuera `.git`, `docs/` y `README.md` porque no hacen falta para
> ejecutar la app."

**Mostrar:** el `.dockerignore`.

### Bloque 5 — Demostración en vivo (2 min) · criterios 3 y 6

Seguir la [sección 3](#3-demostración-en-vivo-orden-exacto).

### Bloque 6 — Defensa de la arquitectura (1 min) · criterio 7

Seguir la [sección 4](#4-defensa-de-la-arquitectura-criterio-7).

### Cierre (20 s)

> "En resumen: una imagen, un contenedor, un puerto. Cualquier compañero la ejecuta con `docker pull` y `docker run`
> sin instalar Node, y la documentación completa está en el repositorio."

## 3. Demostración en vivo: orden exacto

Prepara **antes** de la clase: Docker Desktop abierto, la imagen ya construida (para no esperar la descarga de
`node:24-alpine` en vivo), una terminal en la carpeta del proyecto y el navegador cerrado en `localhost:5173`.

| # | Comando / acción | Qué decir mientras se ve |
| --- | --- | --- |
| 1 | `docker images` | "Aquí está la imagen `mayor-o-menor` que construí; pesa X MB." |
| 2 | `docker build -t mayor-o-menor .` | "La reconstruyo para que vean la caché: los pasos dicen `CACHED` y termina en segundos." (Si prefieren verla completa, hacer antes `docker build --no-cache`.) |
| 3 | `docker run -it --rm -p 5173:5173 mayor-o-menor` | "`-p 5173:5173` publica el puerto: izquierda mi PC, derecha el contenedor. `--rm` borra el contenedor al cerrarlo." Señalar en la salida de Vite la línea `Network: http://172.17.0.x:5173` — prueba de que escucha en `0.0.0.0`. |
| 4 | Abrir `http://localhost:5173` | "Pantalla de carga, primera carta: la API responde. Juego una o dos cartas." |
| 5 | Docker Desktop → **Containers** | "El contenedor en ejecución con el puerto 5173:5173." |
| 6 | `Ctrl + C` y luego `docker ps` | "Al detenerlo desaparece porque usé `--rm`." |
| 7 | (opcional) `docker run -it --rm -p 8080:5173 mayor-o-menor` | "Mismo contenedor, otro puerto en mi PC: solo cambia el número de la izquierda." Abrir `localhost:8080`. |

Si falla algo en vivo, **no lo escondas**: la rúbrica premia "identificar y corregir errores". Usa la tabla de la
sección 5 y resuélvelo en voz alta.

## 4. Defensa de la arquitectura (criterio 7)

La rúbrica pide justificar la elección "en función de la escalabilidad, mantenibilidad, costos y requerimientos del
sistema". Argumento por argumento:

| Criterio | Argumento |
| --- | --- |
| **Requerimientos** | La app es un frontend estático sin backend ni base de datos: la única dependencia externa (Deck of Cards) la consume el navegador, no el contenedor. Por eso basta **un contenedor**, sin `docker-compose`, sin redes ni volúmenes. Agregar más piezas sería complejidad sin beneficio. |
| **Mantenibilidad** | Un `Dockerfile` de 8 líneas que cualquiera del equipo entiende; `package-lock.json` fija las versiones exactas; la versión de Node queda escrita en la imagen (`node:24-alpine`), no depende de lo que tenga cada PC. Si la app cambia, solo se reconstruye la imagen. |
| **Escalabilidad** | Una imagen se puede ejecutar N veces en paralelo (varios contenedores, cada uno en un puerto) o subir a Docker Hub con tags `v1`, `v2`... y desplegarla en cualquier servidor con Docker. Si mañana se agrega un backend, se agrega otro contenedor y se orquesta con `docker-compose`, sin tocar este. |
| **Costos** | Docker Desktop y Docker Hub (repositorio público) son gratuitos; Alpine reduce el tamaño de la imagen y por tanto el tiempo de descarga y el espacio. Un contenedor consume mucho menos CPU y RAM que una máquina virtual. |
| **Decisión que tomé y su trade-off** | Elegí el método de la guía de clase (una etapa, Vite en modo `dev`) porque es simple y todo el equipo puede explicarlo. Su costo es que la imagen pesa más de lo necesario (incluye Node y todas las dependencias de desarrollo) y Vite dice que `dev`/`preview` no es para producción. **La mejora para producción** sería un build en dos etapas: Node construye `dist/` y una imagen de **nginx** (~50 MB) sirve esos archivos estáticos. Está documentada como opción 1 en `GUIA_PARA_DOCKERIZAR.md`. |

Decir esa última fila **sin que te la pregunten**: demuestra que conoces las alternativas, que es lo que distingue
*Sobresaliente* de *Satisfactorio* en ese criterio.

## 5. Problemas encontrados y soluciones (criterios 3 y 4)

La rúbrica pide "identificar y corregir errores" y "proponer soluciones ante problemas". Lleva al menos **dos
problemas reales** que te hayan pasado a ti. Esta tabla tiene los que ocurrieron en el proceso de este proyecto y
los que más se repiten; marca cuáles viviste.

| Problema | Causa | Solución aplicada |
| --- | --- | --- |
| Al clonar el repositorio en Windows: `error: unable to open loose object ... Filename too long` | Windows limita las rutas a 260 caracteres y la carpeta estaba muy anidada | `git config core.longpaths true` (o clonar en una ruta corta como `C:\proyectos\`) |
| `docker: command not found` / "docker no se reconoce" | Docker Desktop no estaba instalado o la terminal se abrió antes de instalarlo | Instalar WSL + Ubuntu + Docker Desktop (Guía 1) y abrir una terminal nueva |
| `Cannot connect to the Docker daemon` | Docker Desktop cerrado | Abrirlo y esperar a que diga *Engine running* |
| La app no abría en `localhost:5173` aunque el contenedor corría | Vite solo escuchaba en `localhost` **dentro** del contenedor | Agregar `--host 0.0.0.0` al `CMD` |
| `port is already allocated` | Otro proceso (otro `npm run dev` u otro contenedor) usaba el 5173 | Detenerlo o publicar en otro puerto: `-p 8080:5173` |
| Vite 8 usa binarios nativos (Rolldown) por plataforma | `node_modules` de Windows no sirve en Alpine Linux (`musl`) | Excluir `node_modules` en `.dockerignore` y dejar que `npm install` instale el binario `linux-x64-musl` dentro |
| Cambié código y el contenedor mostraba la versión vieja | La imagen se construye una vez; no se actualiza sola | Volver a ejecutar `docker build` (la caché hace que sea rápido) |
| `denied: requested access to the resource is denied` al hacer `docker push` | No se hizo `docker login` o el nombre de la imagen no empieza con mi usuario | `docker login` y renombrar: `docker tag mayor-o-menor cdaniel0207/mayor-o-menor:v1` |

Cómo verifiqué que funcionaba dentro del contenedor (criterio 3), en orden:

1. `docker build` termina sin errores y `RUN npm run build` compila 45 módulos.
2. `docker run` muestra `Local: http://localhost:5173/` y `Network: http://172.17.0.x:5173/`.
3. En el navegador aparece la pantalla de carga y luego la primera carta (la API responde).
4. `F12` → **Network**: los archivos `.js` y `.css` devuelven `200`.
5. Docker Desktop → Containers muestra el contenedor con `5173:5173`.
6. Prueba de error: `F12` → Network → *Offline* y recargar: la app muestra "No se pudo conectar con la API" con
   **Reintentar**, es decir, el contenedor sirve la app aunque falle la red.

## 6. Documentación de mi parte (paso 5 de la agenda)

Texto base para el documento del equipo (sección "Persona 4" de `DOCUMENTACION_POR_PERSONA.md`) o para la
presentación. Las partes entre corchetes se completan con tus datos.

### 6.1 Descripción de la aplicación

Mayor o Menor es un juego de cartas hecho con React 19 y Vite 8 que consume la API pública Deck of Cards. El jugador
ve una carta y adivina si la siguiente será mayor o menor; tiene puntos, vidas, racha y récord guardado en
`localStorage`. Tiene 12 componentes funcionales, un custom hook (`useJuego`) con `useState` y `useEffect`, un
servicio para la API y 23 pruebas unitarias. Es una aplicación solo frontend: no tiene backend ni base de datos.

### 6.2 Proceso de dockerización

1. **Análisis**: identifiqué el tipo de app (SPA estática), la versión de Node requerida (22.12+), el comando de
   build, el puerto de Vite y los archivos que no debían entrar a la imagen.
2. **Preparación del entorno**: instalé WSL, Ubuntu y Docker Desktop `[fecha]`.
3. **Dockerfile**: escribí las 8 instrucciones (imagen base `node:24-alpine`, `WORKDIR`, copia de dependencias,
   `npm install`, copia del código, `npm run build`, `EXPOSE 5173` y `CMD` con `--host 0.0.0.0`).
4. **`.dockerignore`**: partí del `.gitignore`, quité `dist/`, `dist-ssr/` y `*.local`, y agregué `.git`, `docs/` y
   `README.md`.
5. **Construcción**: `docker build -t mayor-o-menor .` `[tiempo que tardó, tamaño de la imagen]`.
6. **Ejecución y verificación**: `docker run -it --rm -p 5173:5173 mayor-o-menor` y las 6 comprobaciones de la
   sección 5.
7. **Publicación**: `docker build -t cdaniel0207/mayor-o-menor:v1 .`, `docker login`, `docker push`, y prueba con
   `docker pull` en otra computadora `[de quién]`.
8. **Repositorio**: el código con los archivos de Docker y la documentación está en
   <https://github.com/Cdanielnam/cisarr>.

### 6.3 Comandos utilizados

```bash
git clone https://github.com/Cdanielnam/cisarr.git
cd cisarr
docker build -t mayor-o-menor .
docker images
docker run -it --rm -p 5173:5173 mayor-o-menor
docker ps
docker build -t cdaniel0207/mayor-o-menor:v1 .
docker login
docker push cdaniel0207/mayor-o-menor:v1
docker pull cdaniel0207/mayor-o-menor:v1
```

### 6.4 Evidencias (capturas en `docs/capturas/`)

| Archivo sugerido | Qué muestra | Criterio |
| --- | --- | --- |
| `10-docker-version.png` | `docker --version` y Docker Desktop abierto | 3 |
| `11-dockerfile.png` | `Dockerfile` y `.dockerignore` en VS Code | 4, 6 |
| `12-docker-build.png` | `docker build` terminando sin errores | 3, 6 |
| `13-docker-images.png` | `docker images` con la imagen y su tamaño | 6 |
| `14-docker-run.png` | `docker run` con la salida de Vite (`Local` y `Network`) | 3 |
| `15-containers.png` | Docker Desktop → Containers con el puerto `5173:5173` | 3 |
| `16-app-en-contenedor.png` | El juego abierto en `localhost:5173` | 3, 6 |
| `17-network-200.png` | `F12` → Network con `.js`/`.css` en `200` | 3 |
| `18-error-resuelto.png` | Un error real y la terminal después de corregirlo | 3, 4 |
| `19-docker-push.png` | `docker login` + `docker push` | 6 |
| `20-docker-hub.png` | El repositorio en Docker Hub con el tag `v1` | 6 |
| `21-otra-pc.png` | `docker pull` + `docker run` en otra computadora | 3, 7 |
| `22-github.png` | El repositorio con los commits del Dockerfile | 6 |

## 7. Mapa criterio → evidencia

| Criterio | Nivel Sobresaliente exige | Lo que digo | Lo que muestro |
| --- | --- | --- | --- |
| 3. Verifica funcionamiento en el contenedor (10 %) | Verificar **con éxito y de forma autónoma**, corrigiendo errores | Las 6 comprobaciones de la sección 5 y un error que corregí | Demo en vivo, capturas 14-18 |
| 4. Explica y justifica la configuración (10 %) | **Solvencia técnica** en Dockerfile y `.dockerignore`, soluciones **óptimas y viables** | Bloques 3 y 4 del guion: cada línea y su porqué; tabla de problemas | `Dockerfile`, `.dockerignore`, captura 18 |
| 6. Integra la app con Docker y documenta (10 %) | Documentar **estructura, comandos de construcción y funcionamiento** | "Todo está documentado en el repositorio: README sección 13 y `GUIA_DOCKER.md`" | README, `GUIA_DOCKER.md`, capturas 12-13, 19-22 |
| 7. Defiende la arquitectura (15 %) | Argumentos **sólidos y técnicos** sobre escalabilidad, mantenibilidad, costos y requerimientos | La tabla de la sección 4, incluida la alternativa con nginx | Diapositiva con los 4 argumentos |
| 1. Estructura y decisiones técnicas (15 %, compartido) | Justificar cada decisión estructural | "Un solo contenedor porque es solo frontend; `services/`, `utils/` y `hooks/` separados" | Estructura de carpetas |

## 8. Preguntas probables de la profesora

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Qué diferencia hay entre imagen y contenedor? | La imagen es la plantilla inmutable; el contenedor es esa imagen en ejecución. De una imagen puedo arrancar muchos contenedores. |
| ¿Por qué `node:24-alpine` y no `node:24`? | Mismo Node, pero Alpine es una base de ~5 MB frente a ~300 MB de la imagen completa (Debian). Menos tamaño, descarga y superficie de ataque. |
| ¿Por qué copias `package.json` antes que el resto? | Por la caché de capas: si solo cambia el código, `npm install` no se vuelve a ejecutar. |
| ¿`EXPOSE` abre el puerto? | No, solo lo documenta. Lo abre `-p host:contenedor` en `docker run`. |
| ¿Qué pasa si quito `--host 0.0.0.0`? | Vite escucha solo en `localhost` del contenedor y desde mi PC no se puede entrar, aunque el puerto esté publicado. |
| ¿Por qué `npm install` dentro y no copiar `node_modules`? | `node_modules` de Windows trae binarios para Windows; el contenedor es Linux. Además pesa cientos de MB. |
| ¿Para qué sirve `RUN npm run build` si después usas `npm run dev`? | Como verificación: si el código no compila, la imagen no se construye. Y deja listo `dist/` por si se cambia a servirlo con nginx. |
| ¿Es esto producción? | No; Vite dice que `dev` es para desarrollo. Para producción haría dos etapas: Node construye y nginx sirve `dist/`. |
| ¿Por qué no usaste `docker-compose`? | Porque hay un solo servicio. Compose sirve para orquestar varios (app + base de datos + proxy). |
| ¿La app necesita internet dentro del contenedor? | Solo al construir (para `npm install`). Al ejecutarse, quien necesita internet es el navegador del usuario, para la API y las imágenes de cartas. |
| ¿Qué es `--rm`? | Borra el contenedor al detenerlo, para no acumular contenedores parados. |
| ¿Cómo lo ejecuta un compañero? | `docker pull cdaniel0207/mayor-o-menor:v1` y `docker run -it --rm -p 5173:5173 cdaniel0207/mayor-o-menor:v1`. Sin instalar Node. |
| ¿Qué es un tag? | La versión de la imagen (`v1`, `v2`, `latest`). Permite tener varias versiones en Docker Hub. |
| ¿Dónde está documentado? | README sección 13, `docs/GUIA_DOCKER.md` y este documento, en el repositorio de GitHub. |

## 9. Autoevaluación: preguntas de reflexión

La rúbrica de autoevaluación (1 pt) termina con tres preguntas. Borrador para que lo escribas con tus palabras y con
lo que realmente te pasó:

1. **¿Qué aspectos de mi trabajo en el desarrollo y dockerización realicé con mayor éxito y solvencia técnica?**
   Analizar primero qué tipo de app era antes de escribir el Dockerfile; entender el porqué de cada instrucción
   (sobre todo `--host 0.0.0.0` y el orden de los `COPY` por la caché); verificar la app dentro del contenedor con
   pasos concretos; y dejar todo documentado en el repositorio para que el equipo pudiera ejecutarla.

2. **¿En qué partes del proceso de configuración de Docker identifiqué que debo mejorar?**
   `[elige lo que sea cierto]` Por ejemplo: el build en varias etapas con nginx para producción; `docker-compose`
   para apps con backend y base de datos; reducir aún más la imagen; o automatizar la construcción (CI).

3. **¿Qué estrategias de planificación, depuración o investigación implementaré en mi próximo proyecto?**
   Leer primero los requisitos de la app (versión de Node, puertos, variables) antes de tocar Docker; probar el
   proyecto fuera de Docker (`npm run build`, pruebas, lint) antes de construir la imagen; anotar cada error con su
   solución en el momento; y construir la imagen con tag de versión desde el inicio.
