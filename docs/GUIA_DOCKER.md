# Guía de Docker — "Mayor o Menor"

Paso a paso para **construir, ejecutar y publicar** la app con Docker. Sigue el mismo orden que las guías de clase
(**Guía 1 – Instalación de Docker** y **Guía 2 – Utilización de Docker Hub**), pero aplicado a este proyecto.

> Los datos técnicos de la app (puertos, versión de Node, qué no copiar) están en
> [`GUIA_PARA_DOCKERIZAR.md`](GUIA_PARA_DOCKERIZAR.md). Aquí está **cómo se hizo** y **cómo explicarlo**.

## Índice

1. [Resumen rápido](#1-resumen-rápido)
2. [Parte teórica (lo mínimo para explicar)](#2-parte-teórica-lo-mínimo-para-explicar)
3. [Requisitos (una vez por computadora)](#3-requisitos-una-vez-por-computadora)
4. [El Dockerfile, línea por línea](#4-el-dockerfile-línea-por-línea)
5. [El archivo .dockerignore](#5-el-archivo-dockerignore)
6. [Construir la imagen](#6-construir-la-imagen)
7. [Ejecutar el contenedor](#7-ejecutar-el-contenedor)
8. [Subir la imagen a Docker Hub](#8-subir-la-imagen-a-docker-hub)
9. [Probar en otra computadora](#9-probar-en-otra-computadora)
10. [Crear una versión nueva (v2)](#10-crear-una-versión-nueva-v2)
11. [Capturas para la entrega](#11-capturas-para-la-entrega)
12. [Problemas comunes](#12-problemas-comunes)
13. [Preguntas que pueden hacernos](#13-preguntas-que-pueden-hacernos)

---

## 1. Resumen rápido

| Dato | Valor |
| --- | --- |
| Imagen base | `node:24-alpine` (la misma de la Guía 1) |
| Nombre de la imagen | `mayor-o-menor` |
| Puerto | **5173** (contenedor) → **5173** (tu computadora) |
| Archivos de Docker | [`Dockerfile`](../Dockerfile) y [`.dockerignore`](../.dockerignore), en la raíz del proyecto |
| Variables de entorno | Ninguna |
| Base de datos / backend | No hay: es solo frontend |

Los tres comandos que más se usan:

```bash
git clone https://github.com/Cdanielnam/cisarr.git
```

```bash
docker build -t mayor-o-menor .
```

```bash
docker run -it --rm -p 5173:5173 mayor-o-menor
```

Después se abre <http://localhost:5173> en el navegador.

## 2. Parte teórica (lo mínimo para explicar)

| Concepto | Explicación corta |
| --- | --- |
| **Docker** | Plataforma para empaquetar una aplicación con todo lo que necesita y ejecutarla igual en cualquier computadora. |
| **Dockerfile** | Archivo de texto con las instrucciones (la "receta") para construir una imagen. |
| **Imagen** | Plantilla ya construida: el sistema, Node, las dependencias y nuestro código. No cambia. |
| **Contenedor** | Una imagen **en ejecución**. Es la "cajita" aislada donde corre la app. |
| **Docker Hub** | Repositorio en la nube para imágenes: "como GitHub, pero para imágenes de Docker". |

El flujo completo es: **Dockerfile** → (`docker build`) → **Imagen** → (`docker run`) → **Contenedor**.

¿Qué problema resuelve en este proyecto? Sin Docker, cada integrante necesita instalar Node 22.12 o superior y
ejecutar `npm install`. Con Docker solo se necesita tener Docker: la versión de Node y las dependencias ya van dentro
de la imagen. Se acaba el "en mi máquina sí funciona".

## 3. Requisitos (una vez por computadora)

Es el mismo proceso de la Guía 1:

1. Abrir la terminal de Windows **como administrador** y ejecutar:

   ```bash
   wsl --install
   ```

2. Instalar **Ubuntu** desde la Microsoft Store y crear el usuario y la contraseña cuando lo pida.
3. Descargar e instalar **Docker Desktop**: <https://www.docker.com/products/docker-desktop/>
4. **Abrir Docker Desktop** y dejarlo abierto (si está cerrado, los comandos `docker` fallan).
5. Comprobar en la terminal:

   ```bash
   docker --version
   ```

## 4. El Dockerfile, línea por línea

Está en la raíz del proyecto y se llama `Dockerfile` (sin extensión):

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

Donde:

| Instrucción | Qué hace |
| --- | --- |
| `FROM node:24-alpine` | Imagen base: **Node.js 24** sobre Alpine Linux, una distribución muy ligera. El proyecto pide Node `^22.12.0` o `>=24` (campo `engines` de `package.json`), así que Node 24 cumple. |
| `WORKDIR /app` | Crea la carpeta `/app` **dentro del contenedor** y trabaja ahí. Los comandos siguientes se ejecutan en esa carpeta. |
| `COPY package*.json ./` | Copia `package.json` y `package-lock.json` de nuestra computadora al contenedor. El `*` hace que tome los dos archivos. |
| `RUN npm install` | Instala las dependencias (React, Vite, etc.) **dentro del contenedor**, durante la construcción de la imagen. |
| `COPY . .` | Copia el resto del proyecto (`src/`, `public/`, `index.html`, `vite.config.js`...). Lo que está en `.dockerignore` **no** se copia. |
| `RUN npm run build` | Ejecuta el build de producción dentro del contenedor. Sirve de comprobación: si el código tiene un error, la imagen **no se construye**. |
| `EXPOSE 5173` | Indica que el contenedor escucha en el puerto 5173. **No abre** el puerto: es documentación. El puerto se publica con `-p` en `docker run`. |
| `CMD [...]` | Comando que se ejecuta **al arrancar el contenedor**: `npm run dev` con `--host 0.0.0.0` y `--port 5173`. |

Tres detalles que suelen preguntar:

- **¿Por qué se copia primero `package*.json` y después todo lo demás?** Docker guarda cada instrucción como una
  **capa** y la reutiliza si nada cambió. Si solo cambiamos código en `src/`, la capa de `npm install` se toma de la
  caché y la imagen se reconstruye en segundos.
- **¿Por qué `--host 0.0.0.0`?** Vite solo escucha en `localhost` por defecto. Dentro de un contenedor, `localhost`
  es **el propio contenedor**, así que desde nuestra computadora no se podría entrar. Con `0.0.0.0` escucha en todas
  las interfaces de red.
- **Diferencia entre `RUN` y `CMD`:** `RUN` se ejecuta **al construir la imagen** (una vez). `CMD` se ejecuta **cada
  vez que arranca un contenedor**.

## 5. El archivo .dockerignore

Le dice a Docker qué archivos y carpetas **no** debe copiar al construir la imagen. Como indica la Guía 1, se copió
el contenido de `.gitignore` y se eliminaron estas líneas:

```text
dist/
dist-ssr/
*.local
```

Lo más importante que se queda fuera es **`node_modules/`**: pesa cientos de MB y contiene archivos preparados para
Windows que no sirven en el Linux del contenedor. Por eso las dependencias se instalan dentro con `RUN npm install`.

Además se agregaron `.git`, `docs/` y `README.md`, porque no hacen falta para ejecutar la app y así la imagen pesa
menos.

## 6. Construir la imagen

1. Abrir **Docker Desktop**.
2. Abrir una terminal **en la carpeta del proyecto** (donde está el `Dockerfile`).
3. Ejecutar:

   ```bash
   docker build -t mayor-o-menor .
   ```

   - `-t mayor-o-menor` le pone nombre (*tag*) a la imagen.
   - El punto final (`.`) significa "usa el Dockerfile de esta carpeta".

4. Verificar que la imagen existe:

   ```bash
   docker images
   ```

## 7. Ejecutar el contenedor

```bash
docker run -it --rm -p 5173:5173 mayor-o-menor
```

Donde:

| Parte | Qué significa |
| --- | --- |
| `docker run` | Crea y arranca un contenedor a partir de una imagen. |
| `-it` | Modo interactivo: vemos la salida de Vite en la terminal y podemos detenerlo con `Ctrl + C`. |
| `--rm` | Borra el contenedor al detenerlo (no quedan contenedores viejos acumulados). |
| `-p 5173:5173` | Publica el puerto: **el de la izquierda es el de tu computadora** y **el de la derecha el del contenedor**. |
| `mayor-o-menor` | La imagen que se va a ejecutar. |

Después:

1. Abrir <http://localhost:5173>. Debe aparecer la pantalla de carga y luego la primera carta.
2. En **Docker Desktop → Containers** aparece el contenedor con el puerto `5173:5173`.
3. Para detenerlo: `Ctrl + C` en la terminal.

> Si el puerto 5173 está ocupado, se cambia **solo el número de la izquierda**:
> `docker run -it --rm -p 8080:5173 mayor-o-menor` y se abre <http://localhost:8080>.
> (Es lo que pasó en la Guía 1 con el puerto `7173:5173`.)

La app necesita **internet en el navegador** (la API y las imágenes de las cartas vienen de `deckofcardsapi.com`).
El contenedor solo entrega los archivos de la app; quien pide las cartas es el navegador.

## 8. Subir la imagen a Docker Hub

Sigue la Guía 2. En los comandos, cambia `tu_usuario` por **tu nombre de usuario de Docker Hub**.

1. Crear una cuenta en <https://hub.docker.com> y revisar cuál es el nombre de usuario.
2. Construir la imagen con el usuario y la versión en el nombre:

   ```bash
   docker build -t tu_usuario/mayor-o-menor:v1 .
   ```

3. Iniciar sesión desde la terminal:

   ```bash
   docker login
   ```

4. Verificar que la imagen se creó:

   ```bash
   docker images
   ```

5. Subir la imagen:

   ```bash
   docker push tu_usuario/mayor-o-menor:v1
   ```

6. Entrar a Docker Hub: en **Repositories** debe aparecer `tu_usuario/mayor-o-menor` con el tag `v1`.

El nombre completo tiene tres partes: `usuario` / `nombre_imagen` : `tag`. El **tag** es la versión.

## 9. Probar en otra computadora

Esta es la prueba de que Docker funciona: en la otra computadora **no** hace falta instalar Node, ni clonar el
repositorio, ni ejecutar `npm install`. Solo se necesita Docker Desktop abierto.

```bash
docker pull tu_usuario/mayor-o-menor:v1
```

```bash
docker run -it --rm -p 5173:5173 tu_usuario/mayor-o-menor:v1
```

Y se abre <http://localhost:5173>. (Ejercicio 1 de la Guía 2: descargarla con `pull` y pedirle a un compañero que
también la descargue.)

## 10. Crear una versión nueva (v2)

Ejercicio 2 de la Guía 2:

1. Hacer un cambio visible en el proyecto (por ejemplo, un texto o un color).
2. Construir con el tag nuevo:

   ```bash
   docker build -t tu_usuario/mayor-o-menor:v2 .
   ```

3. Subirla:

   ```bash
   docker push tu_usuario/mayor-o-menor:v2
   ```

4. En la otra computadora:

   ```bash
   docker pull tu_usuario/mayor-o-menor:v2
   ```

   ```bash
   docker run -it --rm -p 5173:5173 tu_usuario/mayor-o-menor:v2
   ```

En Docker Hub quedan las dos versiones (`v1` y `v2`) y se puede ejecutar cualquiera de las dos. Eso es el
**versionado de imágenes**.

## 11. Capturas para la entrega

Guárdalas en `docs/capturas/`. Deben ser de **tu** computadora.

- [ ] `docker --version` y Docker Desktop abierto.
- [ ] El `Dockerfile` y el `.dockerignore` abiertos en Visual Studio Code.
- [ ] `docker build -t mayor-o-menor .` terminando sin errores.
- [ ] `docker images` con la imagen creada.
- [ ] `docker run -it --rm -p 5173:5173 mayor-o-menor` con la salida de Vite.
- [ ] Docker Desktop → **Containers** con el contenedor en ejecución y el puerto `5173:5173`.
- [ ] El juego abierto en <http://localhost:5173>.
- [ ] `docker login` y `docker push` terminando sin errores.
- [ ] El repositorio de la imagen en Docker Hub, con sus tags.
- [ ] `docker pull` y `docker run` en **otra computadora**, con el juego abierto.

## 12. Problemas comunes

| Problema | Causa probable | Solución |
| --- | --- | --- |
| `docker: command not found` o "docker no se reconoce" | Docker Desktop no está instalado | Seguir la [sección 3](#3-requisitos-una-vez-por-computadora) y abrir una terminal nueva. |
| `error during connect` / `Cannot connect to the Docker daemon` | Docker Desktop está cerrado | Abrir Docker Desktop y esperar a que termine de iniciar. |
| `port is already allocated` | El puerto 5173 ya está en uso (otro contenedor o `npm run dev`) | Detener el otro proceso, o usar otro puerto: `-p 8080:5173`. |
| La página no abre en `localhost:5173` | Falta `-p 5173:5173` o falta `--host 0.0.0.0` en el `CMD` | Revisar el comando `docker run` y el `Dockerfile`. |
| `denied: requested access to the resource is denied` al hacer `push` | No se hizo `docker login` o el nombre de usuario no coincide | Ejecutar `docker login` y revisar que la imagen se llame `tu_usuario/mayor-o-menor`. |
| "No se pudo conectar con la API. Revisa tu internet." | El **navegador** no tiene internet o la red bloquea `deckofcardsapi.com` | No es un problema de Docker. Probar con otra red y presionar **Reintentar**. |
| Cambié el código y no se ve el cambio | La imagen ya estaba construida con el código viejo | Volver a ejecutar `docker build` y luego `docker run`. |
| El build tarda mucho la primera vez | Se descarga la imagen base y se instalan las dependencias | Es normal. Las siguientes veces usa la caché y es más rápido. |

## 13. Preguntas que pueden hacernos

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Qué es Docker? | Una plataforma para empaquetar una app con sus dependencias en contenedores y ejecutarla igual en cualquier computadora. |
| ¿Diferencia entre imagen y contenedor? | La imagen es la plantilla (no cambia); el contenedor es la imagen en ejecución. De una imagen se pueden crear muchos contenedores. |
| ¿Diferencia entre Docker y una máquina virtual? | La máquina virtual trae un sistema operativo completo; el contenedor comparte el kernel del sistema anfitrión. Por eso es más ligero y arranca en segundos. |
| ¿Para qué sirve el Dockerfile? | Es la receta con las instrucciones para construir la imagen. |
| ¿Por qué `node:24-alpine`? | Trae Node 24 (el proyecto pide 22.12 o superior) y Alpine es una distribución de Linux muy pequeña, así la imagen pesa menos. |
| ¿Para qué sirve el `.dockerignore`? | Para no copiar a la imagen lo que no hace falta, sobre todo `node_modules`. |
| ¿Por qué `node_modules` no se copia? | Pesa mucho y trae archivos de Windows que no sirven en Linux. Se instala dentro con `npm install`. |
| ¿`EXPOSE` abre el puerto? | No. Solo documenta el puerto. El que lo publica es `-p 5173:5173` en `docker run`. |
| ¿Qué significa `-p 5173:5173`? | Puerto de la computadora : puerto del contenedor. |
| ¿Por qué `--host 0.0.0.0`? | Porque Vite solo escucha en `localhost` y, dentro del contenedor, eso no se alcanza desde afuera. |
| ¿Diferencia entre `RUN` y `CMD`? | `RUN` se ejecuta al construir la imagen; `CMD` al arrancar el contenedor. |
| ¿Qué es Docker Hub? | Un repositorio en la nube para guardar y compartir imágenes, como GitHub pero para imágenes. |
| ¿Diferencia entre `push` y `pull`? | `push` sube una imagen a Docker Hub; `pull` la descarga. |
| ¿Para qué sirven los tags (`v1`, `v2`)? | Para manejar versiones de la misma imagen. |
| ¿La app necesita internet si corre en Docker? | Sí, pero lo necesita el **navegador** (para la API de cartas), no el contenedor. |
| ¿Por qué no hay `docker-compose` ni base de datos? | La app es solo frontend: un único contenedor es suficiente. |
| ¿Se podría mejorar para producción? | Sí: con un build en dos etapas y nginx sirviendo la carpeta `dist/`, la imagen final sería mucho más pequeña (opción 1 de `GUIA_PARA_DOCKERIZAR.md`). Se eligió el método de la guía de clase porque es más simple de construir y de explicar. |
