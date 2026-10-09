# Mayor o Menor

Juego de cartas hecho con **React + Vite** que consume la API pública **[Deck of Cards](https://deckofcardsapi.com)**.
Sale una carta y el jugador adivina si la siguiente será **mayor** o **menor**. Proyecto para la exposición de
Bachillerato en Desarrollo de Software.

> La app ya está **dockerizada**: mira la [sección 13](#13-ejecutar-con-docker) y la guía paso a paso
> [`docs/GUIA_DOCKER.md`](docs/GUIA_DOCKER.md) y el guion de la exposición en [`docs/EXPOSICION_DOCKER.md`](docs/EXPOSICION_DOCKER.md). Los datos técnicos que se usaron para dockerizarla están en
> [`docs/GUIA_PARA_DOCKERIZAR.md`](docs/GUIA_PARA_DOCKERIZAR.md).

## Índice

1. [Descripción y funciones](#1-descripción-y-funciones)
2. [Tecnologías usadas](#2-tecnologías-usadas)
3. [Requisitos](#3-requisitos)
4. [Cómo correr la app (paso a paso)](#4-cómo-correr-la-app-paso-a-paso)
5. [Estructura de carpetas](#5-estructura-de-carpetas)
6. [Componentes](#6-componentes)
7. [Cómo funciona la app (flujo del juego)](#7-cómo-funciona-la-app-flujo-del-juego)
8. [useState, useEffect y el hook useJuego](#8-usestate-useeffect-y-el-hook-usejuego)
9. [La API que se usa](#9-la-api-que-se-usa)
10. [Decisiones técnicas](#10-decisiones-técnicas)
11. [Problemas comunes y soluciones](#11-problemas-comunes-y-soluciones)
12. [Capturas](#12-capturas)
13. [Ejecutar con Docker](#13-ejecutar-con-docker)

---

## 1. Descripción y funciones

### Reglas del juego

1. Al abrir la app se crea un mazo barajado y se muestra la primera carta.
2. Valores: del 2 al 10 valen su número; **J = 11, Q = 12, K = 13 y As = 14**.
3. Eliges **Mayor** o **Menor** y se saca la siguiente carta:
   - **Aciertas:** +1 punto y +1 de racha.
   - **Fallas:** −1 vida y la racha vuelve a 0.
   - **Empate** (mismo valor): no suma ni resta.
4. Empiezas con **3 vidas**. Al llegar a 0 aparece **Game over** con el puntaje final, la mejor racha de la partida y
   el botón **Jugar de nuevo** (crea un mazo nuevo y reinicia todo menos el récord).
5. Si el mazo se acaba, se crea uno nuevo automáticamente **sin perder el progreso**.
6. El **récord** (mejor racha histórica) se guarda en `localStorage`, así que sobrevive al recargar la página.

### Funciones extra

| Función | Descripción |
| --- | --- |
| Indicador de probabilidad | Calcula el % de que la siguiente carta sea mayor, menor o igual con las cartas que quedan en el mazo. Se puede ocultar. |
| Historial | Miniaturas de las últimas 8 jugadas, marcadas como acierto (✓), fallo (✗) o empate (=). |
| Carta anterior | Junto a la carta actual se ve la carta que salió antes. |
| Volteo 3D | Cada carta nueva llega boca abajo y se voltea con una animación CSS 3D. |
| Celebración | Confeti y letrero "¡Nuevo récord!" hechos solo con CSS al superar el récord. |
| Atajos de teclado | `↑` = Mayor, `↓` = Menor, `Enter` = Jugar de nuevo (indicados en pantalla). |
| Pantalla de carga | Se muestra mientras se crea el mazo. |
| Manejo de errores | Si la API falla: "No se pudo conectar con la API. Revisa tu internet." y botón **Reintentar**. |
| Botones protegidos | Se deshabilitan mientras se espera la respuesta de la API (evita el doble clic). |
| Imagen de respaldo | Si la imagen de una carta no carga, la carta se dibuja con texto y el juego sigue funcionando. |
| Accesibilidad | `aria-label`, `alt` en las imágenes, mensajes anunciados a lectores de pantalla, foco visible, contraste AA y respeto a "reducir movimiento". |
| Diseño responsive | Mesa verde estilo casino; se adapta a celular, laptop y proyector. |

## 2. Tecnologías usadas

| Tecnología | Para qué se usa |
| --- | --- |
| [React 19](https://react.dev) | Construir la interfaz con componentes funcionales y hooks. |
| [Vite 8](https://vite.dev) | Servidor de desarrollo rápido y generación del build de producción. |
| JavaScript (ES modules) | Lenguaje de toda la app (sin TypeScript). |
| CSS puro | Todos los estilos (sin Tailwind ni librerías de UI). |
| [Vitest](https://vitest.dev) | Pruebas unitarias de las funciones de `utils/`. |
| ESLint (+ plugins de React Hooks y React Refresh) | Revisar la calidad del código con `npm run lint`. Es la configuración estándar de Vite para React. |
| [Deck of Cards API](https://deckofcardsapi.com) | Crear el mazo, sacar cartas y mostrar las imágenes. No requiere clave. |
| Google Fonts (Inter y Playfair Display) | Tipografías. Si no cargan, el navegador usa fuentes de respaldo y todo funciona igual. |

No se usa TypeScript, React Router, Tailwind, Redux ni librerías de UI.

## 3. Requisitos

Versiones con las que se probó el proyecto:

| Herramienta | Versión probada |
| --- | --- |
| Node.js | **v22.22.0** |
| npm | **10.9.4** |

- Se necesita **Node 22.12 o superior** (también sirve Node 24). Está indicado en el campo `engines` de `package.json`.
  La herramienta de pruebas (Vitest 5) lo exige. Con una versión más vieja, `npm install` muestra una advertencia
  y las pruebas pueden fallar.
- Comprueba tus versiones con:

  ```bash
  node -v
  npm -v
  ```

- Necesitas **conexión a internet** al jugar (la API y las imágenes de las cartas vienen de `deckofcardsapi.com`).

## 4. Cómo correr la app (paso a paso)

### 4.1 Clonar e instalar

```bash
git clone https://github.com/adrianrosa21/mayor_o_menor.git
cd mayor_o_menor
npm install
```

> Si el código todavía no está en la rama `main`, cambia a la rama correcta con `git checkout <nombre-de-la-rama>`
> antes de instalar.

`npm install` descarga las dependencias de `package.json` a la carpeta `node_modules/` (usa el archivo
`package-lock.json` para instalar exactamente las mismas versiones en todos los equipos).

### 4.2 Comandos disponibles

| Comando | Qué hace | Puerto / resultado |
| --- | --- | --- |
| `npm run dev` | Inicia el servidor de **desarrollo**. Recarga la página sola cuando cambias el código. | <http://localhost:5173> |
| `npm run build` | Genera la versión de **producción** (código minimizado y optimizado). | Crea la carpeta `dist/` |
| `npm run preview` | Sirve la carpeta `dist/` para probar el build antes de publicarlo. Primero ejecuta `npm run build`. | <http://localhost:4173> |
| `npm test` | Ejecuta **una vez** las pruebas unitarias con Vitest. | Muestra cuántas pasaron |
| `npm run test:watch` | Pruebas en modo vigilancia (se repiten al guardar un archivo). | — |
| `npm run lint` | Revisa el código con ESLint. Debe terminar sin errores ni advertencias. | — |

Para jugar, ejecuta `npm run dev` y abre <http://localhost:5173> en el navegador. Para detener el servidor,
presiona `Ctrl + C` en la terminal.

## 5. Estructura de carpetas

```text
mayor_o_menor/
├── index.html                  # Página base: carga fuentes y el script src/main.jsx
├── package.json                # Dependencias, scripts (dev, build, test, lint) y versión de Node requerida
├── package-lock.json           # Versiones exactas de las dependencias (hay que subirlo a Git)
├── vite.config.js              # Configuración de Vite (plugin de React) y de Vitest
├── eslint.config.js            # Reglas de ESLint
├── .gitignore                  # Archivos que Git ignora (node_modules, dist...)
├── Dockerfile                  # Instrucciones para construir la imagen de Docker
├── .dockerignore               # Archivos que Docker NO copia a la imagen (node_modules...)
├── README.md                   # Este documento
├── docs/
│   ├── GUIA_DOCKER.md          # Paso a paso de la dockerización y de Docker Hub
│   ├── EXPOSICION_DOCKER.md    # Guion de la exposición y documentación de la Persona 4 (rúbrica #11)
│   ├── GUIA_PARA_DOCKERIZAR.md # Información para quien va a dockerizar la app
│   └── capturas/               # Aquí van las imágenes para el informe
├── public/
│   └── favicon.svg             # Ícono de la pestaña del navegador
└── src/
    ├── main.jsx                # Punto de entrada: monta <App /> en la página
    ├── App.jsx                 # Arma la pantalla juntando los componentes (sin lógica)
    ├── App.css                 # Distribución general: una columna en celular, dos en pantallas anchas
    ├── estilos/
    │   ├── variables.css       # Colores, tipografías y medidas reutilizables
    │   └── base.css            # Reset, fondo de fieltro, foco visible y estilos globales
    ├── hooks/
    │   └── useJuego.js         # Custom hook: TODO el estado y la lógica del juego
    ├── services/
    │   └── deckApi.js          # Todas las llamadas fetch a la API Deck of Cards
    ├── utils/
    │   ├── cartas.js           # Funciones puras: valor de carta, comparación, probabilidades, nombres
    │   └── cartas.test.js      # 23 pruebas unitarias de cartas.js con Vitest
    └── components/             # Un componente por archivo .jsx, con su .css
        ├── Header.jsx          # Título y recordatorio del orden de las cartas
        ├── Marcador.jsx        # Puntos, vidas, racha y récord
        ├── Mesa.jsx            # Mesa de fieltro: mazo, carta actual y carta anterior
        ├── Carta.jsx           # Una carta con volteo 3D y respaldo si falla la imagen
        ├── Botones.jsx         # Botones Mayor / Menor con sus atajos de teclado
        ├── Mensaje.jsx         # Mensaje del resultado de cada jugada
        ├── Probabilidad.jsx    # Panel de probabilidades (se puede ocultar)
        ├── Historial.jsx       # Miniaturas de las últimas jugadas
        ├── PantallaFinal.jsx   # Ventana de "Game over"
        ├── Cargando.jsx        # Pantalla de carga mientras se crea el mazo
        ├── ErrorApi.jsx        # Mensaje de error de la API y botón Reintentar
        └── Celebracion.jsx     # Confeti y letrero de nuevo récord (solo CSS)
```

## 6. Componentes

Hay **12 componentes funcionales**, cada uno con una sola responsabilidad. Los componentes **solo reciben datos por
props** y **nunca llaman a la API**; cuando el usuario hace algo, avisan con una función que viene por props
(las que empiezan con `al...`).

| Componente | Qué hace | Props que recibe |
| --- | --- | --- |
| `Header` | Muestra el título y un recordatorio del orden de las cartas. | Ninguna |
| `Marcador` | Muestra puntos, vidas (corazones), racha y récord. | `puntos`, `vidas`, `vidasIniciales`, `racha`, `record`, `recordSuperado` |
| `Mesa` | Mesa de fieltro con el mazo (cuántas cartas quedan), la carta actual y la carta anterior. | `carta`, `cartaAnterior`, `restantes`, `claveCarta`, `esperando` |
| `Carta` | Dibuja una carta. Con `animada` llega boca abajo y se voltea en 3D. Si la imagen falla, se dibuja con texto. | `carta`, `animada`, `tamano` (`normal`, `media` o `mini`) |
| `Botones` | Botones Mayor y Menor con su atajo. Se deshabilitan mientras se espera a la API. | `deshabilitado`, `cargando`, `alElegir` |
| `Mensaje` | Muestra el resultado de la jugada (acierto, fallo, empate, récord). Lo leen los lectores de pantalla. | `mensaje` (`{ tipo, texto }`) |
| `Probabilidad` | Barras con el % de mayor, menor e igual. Tiene un botón para ocultarlo. | `probabilidades`, `visible`, `alAlternar` |
| `Historial` | Miniaturas de las últimas jugadas con ✓, ✗ o =. | `jugadas` |
| `PantallaFinal` | Ventana de "Game over" con puntaje, mejor racha, récord y botón **Jugar de nuevo**. | `puntos`, `mejorRacha`, `record`, `superoRecord`, `alReiniciar` |
| `Cargando` | Pantalla de carga con los cuatro palos animados. | `texto` (opcional) |
| `ErrorApi` | Mensaje "No se pudo conectar con la API. Revisa tu internet." y botón **Reintentar**. | `alReintentar` |
| `Celebracion` | Confeti y letrero "¡Nuevo récord!" con animaciones CSS. | Ninguna |

## 7. Cómo funciona la app (flujo del juego)

1. **Se abre la app.** `main.jsx` monta `<App />`. `App` llama a `useJuego()` y muestra la pantalla de **Cargando**.
2. **Se crea el mazo.** Un `useEffect` dentro de `useJuego` llama a `crearMazo()` y luego a `sacarCarta()` (ambas en
   `services/deckApi.js`). Con la respuesta se guardan el mazo y la primera carta, y se muestra la mesa.
   Si algo falla, se muestra **ErrorApi** con el botón **Reintentar**.
3. **El jugador elige** Mayor o Menor (con el mouse, tocando o con `↑` / `↓`). Se llama a `jugar(eleccion)`.
4. **Se espera a la API.** Los botones se deshabilitan y aparece "Sacando carta…". Si el mazo estaba vacío, primero
   se crea uno nuevo.
5. **Se evalúa la jugada** con `evaluarJugada()` (en `utils/cartas.js`): acierto, fallo o empate.
6. **Se actualiza el estado:** puntos, vidas, racha, mejor racha, carta actual y anterior, historial y mensaje.
   Si la racha supera el récord, se actualiza el récord y aparece la **Celebración**.
7. **React vuelve a dibujar** la pantalla con los datos nuevos: la carta nueva se voltea, el marcador y las
   probabilidades cambian y el historial suma una miniatura.
8. **Se repiten los pasos 3 a 7** hasta que las vidas llegan a 0.
9. **Game over:** aparece **PantallaFinal** con el puntaje final, la mejor racha de la partida y el récord.
10. **Jugar de nuevo** (botón o `Enter`) reinicia puntos, vidas, racha e historial, pero **conserva el récord**, y
    vuelve al paso 1 creando un mazo nuevo.

El récord se guarda en `localStorage` cada vez que cambia y se lee al abrir la app.

## 8. useState, useEffect y el hook useJuego

### useState: la memoria del componente

`useState` guarda un dato que **cambia con el tiempo**. Cuando se actualiza, React vuelve a dibujar la pantalla.

```js
const [vidas, setVidas] = useState(3);   // vidas vale 3 al empezar
setVidas(vidas - 1);                     // al fallar, la pantalla se actualiza sola
```

En este proyecto hay estados para el mazo (`idMazo`, `restantes`, `cartaActual`, `cartaAnterior`), el marcador
(`puntos`, `vidas`, `racha`, `mejorRacha`, `record`), lo que se ve (`historial`, `mensaje`,
`mostrarProbabilidad`) y la comunicación con la API (`cargandoMazo`, `cargandoCarta`, `error`).

### useEffect: hacer algo cuando ocurre un cambio

`useEffect` ejecuta código **después de dibujar la pantalla**, y se vuelve a ejecutar cuando cambia algo de su lista
de dependencias (el arreglo del final). Sirve para cosas "de afuera" de React: pedir datos, guardar en
`localStorage`, escuchar el teclado.

`useJuego` tiene **tres efectos**:

| Efecto | Dependencias | Qué hace |
| --- | --- | --- |
| 1. Crear el mazo | `[numeroPartida]` | Al abrir la app y cada vez que cambia `numeroPartida` (Jugar de nuevo / Reintentar): crea el mazo y saca la primera carta. |
| 2. Guardar el récord | `[record]` | Cada vez que cambia el récord lo guarda en `localStorage`, dentro de un `try/catch`. |
| 3. Atajos de teclado | `[juegoTerminado, puedeJugar, ...]` | Escucha `↑`, `↓` y `Enter`. Al terminar, **quita** el listener (función de limpieza). |

```js
// Efecto 2 (resumen): guarda el récord cada vez que cambia
useEffect(() => {
  try {
    localStorage.setItem('mayorOMenor.record', String(record));
  } catch {
    // Sin localStorage el juego sigue funcionando; solo no se guarda
  }
}, [record]);
```

> **Detalle importante:** en el efecto 1 hay una variable `cancelado`. La función de limpieza la pone en `true`, y
> así se ignora una respuesta "vieja" si el efecto se vuelve a ejecutar antes de que termine la petición.

### useJuego: un custom hook

Un **custom hook** es una función propia cuyo nombre empieza con `use` y que agrupa `useState` y `useEffect`.
`useJuego` reúne **todo el estado y la lógica del juego** y devuelve lo que la pantalla necesita:

```js
// En App.jsx
const juego = useJuego();            // datos y acciones del juego
<Marcador puntos={juego.puntos} ... />
<Botones alElegir={juego.jugar} ... />
```

Así `App.jsx` solo arma la pantalla, los componentes solo dibujan, y la lógica se puede leer y explicar en un solo
archivo.

## 9. La API que se usa

Se usan **dos endpoints**, ambos con `GET` y sin clave. Están en `src/services/deckApi.js`.

| Para qué | Endpoint |
| --- | --- |
| Crear un mazo barajado | `https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1` |
| Sacar una carta | `https://deckofcardsapi.com/api/deck/{deck_id}/draw/?count=1` |

Puedes probarlos desde la terminal:

```bash
curl "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"
curl "https://deckofcardsapi.com/api/deck/<deck_id>/draw/?count=1"   # cambia <deck_id> por el que te devolvió el primero
```

### Ejemplo de respuesta: crear el mazo

```json
{
  "success": true,
  "deck_id": "3p40paa87x90",
  "remaining": 52,
  "shuffled": true
}
```

### Ejemplo de respuesta: sacar una carta

```json
{
  "success": true,
  "deck_id": "3p40paa87x90",
  "cards": [
    {
      "code": "6H",
      "image": "https://deckofcardsapi.com/static/img/6H.png",
      "images": {
        "svg": "https://deckofcardsapi.com/static/img/6H.svg",
        "png": "https://deckofcardsapi.com/static/img/6H.png"
      },
      "value": "6",
      "suit": "HEARTS"
    }
  ],
  "remaining": 51
}
```

> **Nota:** estos ejemplos siguen el formato de la documentación pública de la API. Los valores (`deck_id`, la carta)
> cambian en cada petición. Para tu informe, ejecuta los `curl` y pega aquí la respuesta real que obtengas.

Campos que usa la app:

| Campo | Qué es | Dónde se usa |
| --- | --- | --- |
| `deck_id` | Identificador del mazo | Para sacar cartas del mismo mazo |
| `remaining` | Cartas que quedan en el mazo | Saber cuándo crear un mazo nuevo y mostrar cuántas quedan |
| `cards[0].value` | `"2"`…`"10"`, `"JACK"`, `"QUEEN"`, `"KING"`, `"ACE"` | Calcular el valor numérico (J=11 … As=14) |
| `cards[0].suit` | `"HEARTS"`, `"DIAMONDS"`, `"CLUBS"`, `"SPADES"` | Nombre y símbolo del palo |
| `cards[0].image` | URL de la imagen de la carta | Mostrar la carta |
| `success` | `true` si la API pudo responder | Si es `false`, se muestra el error |

`deckApi.js` traduce la carta de la API a un objeto con nombres en español: `{ codigo, valor, palo, imagen }`.
Si la respuesta no es válida, la petición falla o tarda más de 10 segundos, se lanza un error y la interfaz muestra
el mensaje con el botón **Reintentar**.

## 10. Decisiones técnicas

| Decisión | Justificación |
| --- | --- |
| **Separar `services/`, `utils/` y `hooks/`** | Cada carpeta tiene una sola tarea: `services` habla con internet, `utils` tiene funciones puras (sin React ni red) y `hooks` guarda el estado y las reglas. Así cada parte se entiende, se prueba y se cambia sin tocar las demás (por ejemplo, cambiar de API solo afecta a `deckApi.js`). |
| **Los componentes solo reciben props** | Son fáciles de reutilizar y de explicar: dibujan lo que reciben y avisan con funciones. Nunca llaman a la API. |
| **Un custom hook (`useJuego`)** | Concentra la lógica en un solo lugar. `App.jsx` queda corto y legible. |
| **CSS puro con variables** | La rúbrica pide solo React, Vite y CSS. Las variables (`variables.css`) dan consistencia de colores y tamaños. Se usa un `.css` por componente para saber dónde está cada estilo. Las unidades `rem` hacen que todo escale en celular, laptop y proyector. |
| **Agregar pruebas con Vitest** | Las reglas del juego (valores, comparación, probabilidades) deben ser correctas. Probarlas con `npm test` evita errores al cambiar el código. Vitest se integra con Vite y no necesita configuración extra. |
| **Calcular la probabilidad en la app** | Un mazo tiene 4 cartas de cada valor. Restando las que ya salieron se sabe exactamente qué queda. La API no entrega esta información, y así no hay peticiones extra. |
| **Crear el mazo nuevo solo cuando hace falta** | Si el mazo se acaba, se renueva en la siguiente jugada (no antes). Si esa petición falla, el botón **Reintentar** la repite sin perder el progreso. |
| **`key` para repetir animaciones** | Al cambiar la `key` de un componente, React lo vuelve a crear y la animación CSS se repite (volteo de carta, subida de números). |
| **Imagen de respaldo en `Carta`** | Si las imágenes de la API fallan, la carta se dibuja con texto y el juego sigue funcionando. |
| **Sin variables de entorno ni backend** | Es una aplicación estática: toda la lógica corre en el navegador. Esto simplifica mucho la publicación y la dockerización. |
| **Accesibilidad desde el inicio** | `aria-label`, `alt`, regiones que se anuncian (`role="status"`), foco visible, contraste AA y animaciones reducidas si el usuario lo pide. |

## 11. Problemas comunes y soluciones

| Problema | Causa probable | Solución |
| --- | --- | --- |
| `npm install` muestra `EBADENGINE` o las pruebas no arrancan | Tu versión de Node es vieja | Instala Node 22.12 o superior (por ejemplo con [nvm](https://github.com/nvm-sh/nvm): `nvm install 22`) y revisa con `node -v`. |
| `vite: command not found` o `Cannot find module` | Faltan las dependencias | Ejecuta `npm install` en la carpeta del proyecto (donde está `package.json`). |
| `npm run dev` dice que el puerto 5173 está ocupado | Hay otro programa (u otro Vite) usándolo | Vite usa el siguiente puerto libre y lo muestra en la terminal. O elige uno: `npm run dev -- --port 3000`. |
| Aparece "No se pudo conectar con la API. Revisa tu internet." | Sin internet, red del colegio con filtros, VPN o bloqueador de anuncios | Revisa tu conexión, prueba con otra red, desactiva el bloqueador para el sitio y comprueba la API con `curl` (sección 9). Luego presiona **Reintentar**. |
| Las cartas aparecen "dibujadas" con texto en vez de imágenes | El navegador no pudo cargar las imágenes de `deckofcardsapi.com` | Es el modo de respaldo: el juego funciona igual. Revisa la conexión o los bloqueadores. |
| El récord no se guarda | Navegación privada o `localStorage` bloqueado | El juego sigue funcionando, solo que el récord no se conserva al recargar. Usa una ventana normal. |
| En `npm run dev` se crean **dos** mazos al abrir la app | `React.StrictMode` ejecuta los efectos dos veces **solo en desarrollo** | Es normal. La app descarta la respuesta repetida. No ocurre en `npm run build` / `preview`. |
| Los cambios de estilo no se ven | Caché del navegador | Recarga con `Ctrl + F5` (o `Cmd + Shift + R`). |
| No puedo abrir la app desde otro dispositivo (celular, contenedor) | Vite solo escucha en `localhost` | Usa `npm run dev -- --host` (o `npm run preview -- --host`). |
| Las fuentes se ven distintas | Sin internet no cargan las de Google Fonts | Se usan fuentes de respaldo (Georgia / del sistema). Todo funciona igual. |
| `npm test` se queda esperando | Se usó `npm run test:watch` | Usa `npm test` (corre una vez). Para salir del modo vigilancia presiona `q`. |
| `npm ci` falla por el `package-lock.json` | El lock no coincide con `package.json` | Ejecuta `npm install` y sube el `package-lock.json` actualizado a Git. |

## 12. Capturas

Guarda las imágenes en `docs/capturas/` y quita los comentarios `<!-- -->` para que se vean en este documento.

### 12.1 Pantalla de carga

<!-- ![Pantalla de carga](docs/capturas/01-carga.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Pantalla "Barajando el mazo…". Archivo sugerido: `docs/capturas/01-carga.png`

### 12.2 Pantalla principal en computadora

<!-- ![Pantalla principal](docs/capturas/02-juego-escritorio.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Mesa con la carta actual, marcador, probabilidades e historial.
> Archivo sugerido: `docs/capturas/02-juego-escritorio.png`

### 12.3 Pantalla principal en celular

<!-- ![Vista en celular](docs/capturas/03-juego-celular.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Vista responsive (puedes usar las herramientas de desarrollador del navegador, tecla `F12`).
> Archivo sugerido: `docs/capturas/03-juego-celular.png`

### 12.4 Acierto y fallo

<!-- ![Acierto y fallo](docs/capturas/04-acierto-fallo.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** El mensaje de acierto y el de fallo, con el historial marcado con ✓ y ✗.
> Archivo sugerido: `docs/capturas/04-acierto-fallo.png`

### 12.5 Celebración por nuevo récord

<!-- ![Nuevo récord](docs/capturas/05-record.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Confeti y letrero "¡Nuevo récord!". Haz 2 aciertos seguidos en una partida nueva.
> Archivo sugerido: `docs/capturas/05-record.png`

### 12.6 Game over

<!-- ![Game over](docs/capturas/06-game-over.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Pantalla final con puntaje, mejor racha y récord.
> Archivo sugerido: `docs/capturas/06-game-over.png`

### 12.7 Error de la API

<!-- ![Error de la API](docs/capturas/07-error-api.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** Mensaje de error con el botón **Reintentar**. Para provocarlo: en las herramientas
> de desarrollador (`F12`) → pestaña **Network** → elige **Offline** y recarga la página.
> Archivo sugerido: `docs/capturas/07-error-api.png`

### 12.8 Pruebas, lint y build

<!-- ![Resultados en la terminal](docs/capturas/08-terminal.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** La terminal con `npm test`, `npm run lint` y `npm run build` terminando sin errores.
> Archivo sugerido: `docs/capturas/08-terminal.png`

### 12.9 Respuesta real de la API (curl)

<!-- ![Respuesta de la API](docs/capturas/09-curl-api.png) -->
> 📸 **[ESPACIO PARA CAPTURA]** El resultado de los dos `curl` de la sección 9, o la pestaña **Network** del navegador.
> Archivo sugerido: `docs/capturas/09-curl-api.png`

## 13. Ejecutar con Docker

Con Docker **no hace falta instalar Node ni ejecutar `npm install`**: todo va dentro de la imagen. Solo se necesita
tener [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y abierto.

```bash
git clone https://github.com/Cdanielnam/cisarr.git
cd cisarr
docker build -t mayor-o-menor .
docker run -it --rm -p 5173:5173 mayor-o-menor
```

Después abre <http://localhost:5173>. Para detener el contenedor presiona `Ctrl + C`.

| Comando | Qué hace |
| --- | --- |
| `docker build -t mayor-o-menor .` | Construye la imagen siguiendo el `Dockerfile` y le pone el nombre `mayor-o-menor`. |
| `docker run -it --rm -p 5173:5173 mayor-o-menor` | Arranca un contenedor y publica el puerto 5173 del contenedor en el 5173 de tu computadora. |
| `docker images` | Lista las imágenes que tienes. |
| `docker ps` | Lista los contenedores en ejecución. |

Archivos de Docker (en la raíz del proyecto):

| Archivo | Para qué sirve |
| --- | --- |
| `Dockerfile` | La "receta" de la imagen: Node 24 (Alpine), instala dependencias, copia el código, hace el build y arranca Vite en el puerto 5173. |
| `.dockerignore` | Lo que **no** se copia a la imagen: `node_modules`, registros, archivos del editor, `.git` y la documentación. |

### Sin clonar el repositorio (desde Docker Hub)

La imagen está publicada en <https://hub.docker.com/r/cdaniel0207/mayor-o-menor>. Solo se necesita Docker Desktop:

```bash
docker pull cdaniel0207/mayor-o-menor:v1
docker run -it --rm -p 5173:5173 cdaniel0207/mayor-o-menor:v1
```

La explicación línea por línea, cómo subir la imagen a **Docker Hub** (`docker push` / `docker pull`), las capturas
para la entrega y las preguntas frecuentes están en [`docs/GUIA_DOCKER.md`](docs/GUIA_DOCKER.md).
