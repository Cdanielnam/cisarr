# Documentación por integrante — "Mayor o Menor"

> **Cómo usar este documento**
> 1. Cada integrante completa **su** sección (Persona 1, 2, 3 o 4). Steven las junta en el documento final.
> 2. Todo lo que está entre `[corchetes]` lo escribes tú: nombre, tu aporte, tus capturas.
> 3. Las **capturas deben ser tuyas** (de tu computadora, corriendo la app). No uses las de otra persona.
> 4. Si algo no lo entiendes, pregúntalo antes de entregar: el profesor puede preguntarte sobre tu parte.

## Datos generales del proyecto (los pone Steven una sola vez)

| Dato | Valor |
| --- | --- |
| Proyecto | **Mayor o Menor**: juego de cartas con React + Vite que consume la API Deck of Cards |
| Repositorio | https://github.com/AdrianRosa21/mayor_o_menor |
| Tecnologías | React 19, Vite 8, JavaScript, CSS puro, Vitest, ESLint |
| API | https://deckofcardsapi.com (pública, sin clave) |
| Versiones probadas | Node v22.22.0 y npm 10.9.4 (mínimo Node 22.12) |
| Cómo correrlo | `git clone https://github.com/AdrianRosa21/mayor_o_menor.git`, `cd mayor_o_menor`, `npm install`, `npm run dev` y abrir http://localhost:5173 |
| Herramientas de apoyo | `[Escribir según lo que indique el profesor. Ejemplo: "Se usó un asistente de IA (Claude) como apoyo para generar la base del código; después cada integrante estudió, probó y explicó su parte."]` |

División del trabajo:

| Persona | Integrante | Parte |
| --- | --- | --- |
| 1 | `[Nombre]` | Interfaz: componentes y diseño |
| 2 | `[Nombre]` | Lógica del juego: estado y reglas |
| 3 | `[Nombre]` | Datos: API, funciones y pruebas |
| 4 | `[Nombre]` | Entrega: Docker, documentación y GitHub |

---

# PERSONA 1 — Interfaz (componentes y diseño)

**Integrante:** `[Nombre]`

## 1. Responsabilidad

Que el juego **se vea bien y sea fácil de usar**: los componentes de React, los estilos CSS, las animaciones, el
diseño adaptable (celular, laptop y proyector) y la accesibilidad.

## 2. Archivos de mi parte

- `src/components/*.jsx` y `src/components/*.css` (12 componentes)
- `src/App.jsx` y `src/App.css`
- `src/estilos/variables.css` y `src/estilos/base.css`
- `src/main.jsx`, `index.html`

## 3. Qué hace mi parte (explicación sencilla)

- **12 componentes funcionales**, cada uno con una sola tarea: `Header`, `Marcador`, `Mesa`, `Carta`, `Botones`,
  `Mensaje`, `Probabilidad`, `Historial`, `PantallaFinal`, `Cargando`, `ErrorApi` y `Celebracion`.
- Los componentes **solo reciben datos por props** y **nunca llaman a la API**. Cuando el usuario hace algo, avisan
  con una función que también llega por props (las que empiezan con `al...`, como `alElegir`).
- `App.jsx` **solo arma la pantalla**: llama a `useJuego()` y reparte los datos a cada componente.
- **Volteo 3D de la carta:** se hace con CSS (`perspective`, `rotateY` y `backface-visibility`). Cada carta nueva
  recibe una `key` distinta, así React la vuelve a crear y la animación se repite.
- **Confeti de récord:** hecho solo con CSS. Cada pieza recibe su posición y color con variables CSS (`--izquierda`,
  `--color`, etc.).
- **Diseño adaptable:** se usan unidades `rem`, `clamp()` y una columna en celular y dos en pantallas anchas.
- **Accesibilidad:** `aria-label` en los botones, `alt` en las imágenes, mensajes que lee el lector de pantalla
  (`role="status"`), ventana de Game over con `role="dialog"`, foco visible con teclado, contraste AA y animaciones
  reducidas si el usuario lo pide.

## 4. Código clave

```css
/* Carta.css: el volteo 3D se activa cuando la imagen termina de cargar */
.carta--animada.carta--descubierta .carta__giro {
  animation: carta-voltear 0.7s cubic-bezier(0.2, 0.7, 0.2, 1) both;
}

@keyframes carta-voltear {
  from {
    transform: rotateY(180deg) translateY(-0.8rem) scale(0.96);
  }
  to {
    transform: rotateY(0) translateY(0) scale(1);
  }
}
```

```jsx
// App.jsx: App solo reparte datos; no tiene lógica
<Marcador
  puntos={juego.puntos}
  vidas={juego.vidas}
  vidasIniciales={juego.vidasIniciales}
  racha={juego.racha}
  record={juego.record}
  recordSuperado={juego.numeroCelebracion > 0}
/>
```

## 5. Cómo se verificó

- `npm run lint` termina sin errores ni advertencias.
- `npm run build` termina sin errores.
- El contraste del texto cumple el nivel AA de accesibilidad (mínimo 4.5:1).
- La app se revisó en pantallas de 360, 390, 1024, 1366, 1440 y 1920 píxeles de ancho, sin desbordes horizontales.

## 6. Evidencias que debo adjuntar (todas hechas por mí)

- [ ] **Captura de la pantalla principal en computadora** (`npm run dev`, http://localhost:5173).
- [ ] **Captura en modo celular:** `F12` → ícono de celular (modo responsive) → elegir un celular.
- [ ] **Captura del Game over** (pierde las 3 vidas) y de la **celebración** (2 aciertos seguidos en una partida
      nueva).
- [ ] **Captura del foco visible:** presiona `Tab` varias veces y captura el contorno dorado en un botón.
- [ ] **Mi cambio de prueba (antes y después):** en `src/estilos/variables.css` cambia el color `--dorado` por otro
      (por ejemplo `#6cb6ff`), guarda, captura cómo cambió toda la interfaz y vuelve a dejar el valor original.

## 7. Mi aporte personal

`[Escribe con tus palabras qué estudiaste, qué probaste y qué cambiaste en tu parte.]`

## 8. Preguntas que pueden hacerme

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Por qué los componentes no llaman a la API? | Para que solo dibujen. La lógica queda en un solo lugar (`useJuego`) y los componentes se pueden reutilizar y probar más fácil. |
| ¿Cómo se hace el volteo 3D? | Con CSS: `perspective` en la carta, `rotateY` de 180° a 0° en una animación y `backface-visibility: hidden` para ocultar la cara de atrás. |
| ¿Para qué sirve la `key`? | Al cambiarla, React vuelve a crear el componente y la animación se repite con cada carta nueva. |
| ¿Cómo se adapta a celular y proyector? | Con unidades `rem`, `clamp()` y media queries: una columna en celular y dos en pantallas anchas. |

---

# PERSONA 2 — Lógica del juego (estado y reglas)

**Integrante:** `[Nombre]`

## 1. Responsabilidad

Que el juego **funcione según las reglas**: puntos, vidas, racha, récord, game over, atajos de teclado y la
conexión entre la API y la pantalla.

## 2. Archivos de mi parte

- `src/hooks/useJuego.js` (el custom hook con todo el estado y la lógica)

## 3. Qué hace mi parte (explicación sencilla)

- `useJuego` es un **custom hook**: una función propia (su nombre empieza con `use`) que agrupa `useState` y
  `useEffect`. Tiene **19 estados** (`useState`), **3 efectos** (`useEffect`) y 4 funciones con `useCallback`.
- **`useState`** guarda lo que cambia: mazo, carta actual, puntos, vidas, racha, récord, historial, mensaje, errores.
  Cuando uno cambia, React vuelve a dibujar la pantalla.
- **Los 3 efectos (`useEffect`):**
  1. **Crear el mazo** al abrir la app y cada vez que cambia `numeroPartida` (Jugar de nuevo / Reintentar).
  2. **Guardar el récord** en `localStorage` cada vez que cambia, dentro de un `try/catch`.
  3. **Atajos de teclado:** `↑` = Mayor, `↓` = Menor y `Enter` = Jugar de nuevo. Al terminar, quita el listener.
- **Reglas:** acierto = +1 punto y +1 racha; fallo = −1 vida y racha en 0; empate = no cambia nada. Empieza con
  3 vidas y al llegar a 0 aparece el Game over.
- **Mazo agotado:** si `restantes <= 0`, la siguiente jugada crea un mazo nuevo sin perder el progreso.
- **Botones protegidos:** `puedeJugar` es falso mientras se espera a la API, así no hay doble clic.
- **Reintentar:** si la API falla, se guarda qué falló (`error`) y el botón repite esa misma acción.
- **Variable `cancelado`:** en el efecto 1 evita usar una respuesta "vieja" si el efecto se vuelve a ejecutar.

## 4. Código clave

```js
// Reglas del juego dentro de jugar()
const nuevoPuntaje = resultado === 'acierto' ? puntos + 1 : puntos;
const nuevasVidas = resultado === 'fallo' ? vidas - 1 : vidas;
let nuevaRacha = racha;
if (resultado === 'acierto') nuevaRacha = racha + 1;
if (resultado === 'fallo') nuevaRacha = 0;
```

```js
// Efecto 2: guardar el récord con try/catch
useEffect(() => {
  try {
    localStorage.setItem(CLAVE_RECORD, String(record));
  } catch {
    // Sin localStorage (modo privado, bloqueado...) el juego sigue; solo no se guarda
  }
}, [record]);
```

## 5. Cómo se verificó

Se probó el flujo completo en un navegador real, con la API simulada: aciertos, fallos, empate, game over, reinicio
(el récord se conserva), récord guardado y recuperado al recargar, botones deshabilitados con doble clic, mazo
agotado, error de la API con **Reintentar** y atajos de teclado.

## 6. Evidencias que debo adjuntar (todas hechas por mí)

- [ ] **Captura del marcador** después de un acierto, un fallo y un empate (muestra cómo cambian puntos, vidas y
      racha).
- [ ] **Captura del récord en `localStorage`:** `F12` → pestaña **Application** → **Local Storage** → clave
      `mayorOMenor.record`.
- [ ] **Captura de "Sacando carta…" con los botones deshabilitados:** `F12` → **Network** → velocidad **Slow 3G** y
      juega una carta.
- [ ] **Captura de los atajos:** una captura de la barra de atajos en pantalla y otra después de usar `↑` o `↓`.
- [ ] **Mi cambio de prueba (antes y después):** en `useJuego.js` cambia `VIDAS_INICIALES` de `3` a `5`, captura que
      ahora aparecen 5 corazones y vuelve a dejarlo en `3`.

## 7. Mi aporte personal

`[Escribe con tus palabras qué estudiaste, qué probaste y qué cambiaste en tu parte.]`

## 8. Preguntas que pueden hacerme

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Qué es un custom hook? | Una función propia que empieza con `use` y agrupa `useState` y `useEffect` para reutilizar o separar la lógica. |
| ¿Para qué sirve el arreglo del final de `useEffect`? | Son las dependencias: el efecto se vuelve a ejecutar solo cuando alguno de esos valores cambia. `[record]` guarda el récord cuando cambia. |
| ¿Qué pasa si `localStorage` no está disponible? | El `try/catch` evita que se rompa: el juego sigue funcionando, solo no se guarda el récord. |
| ¿Cómo evitan el doble clic? | `puedeJugar` es falso mientras se espera a la API y los botones se deshabilitan. |
| ¿Qué pasa si el mazo se acaba? | En la siguiente jugada se crea un mazo nuevo y se conserva el progreso. |

---

# PERSONA 3 — Datos (API, funciones y pruebas)

**Integrante:** `[Nombre]`

## 1. Responsabilidad

La **conexión con la API Deck of Cards**, las **funciones que calculan** (valor de carta, comparación,
probabilidades) y las **pruebas unitarias** que comprueban que están correctas.

## 2. Archivos de mi parte

- `src/services/deckApi.js` (todas las llamadas `fetch`)
- `src/utils/cartas.js` (funciones puras)
- `src/utils/cartas.test.js` (23 pruebas con Vitest)

## 3. Qué hace mi parte (explicación sencilla)

- **Dos endpoints** (GET, sin clave):
  - Crear mazo barajado: `https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1`
  - Sacar carta: `https://deckofcardsapi.com/api/deck/{deck_id}/draw/?count=1`
- `deckApi.js` valida la respuesta: lanza un error si el estado HTTP no es correcto, si la API responde
  `success: false` o si tarda **más de 10 segundos**. La interfaz usa ese error para mostrar "No se pudo conectar con
  la API" con el botón **Reintentar**.
- Traduce la carta de la API (`code`, `value`, `suit`, `image`) a nombres en español: `codigo`, `valor`, `palo`,
  `imagen`.
- `cartas.js` tiene **funciones puras** (sin React ni internet): valor numérico (2 a 10, J=11, Q=12, K=13, As=14),
  comparación, evaluación de la jugada, **probabilidades** y nombres en español.
- **Probabilidad:** un mazo tiene 4 cartas de cada valor. Se restan las que ya salieron y se cuentan cuántas de las
  que quedan son mayores, menores o iguales. Ejemplo: con un Rey de corazones en mesa y 51 cartas en el mazo, quedan
  4 ases (8 %), 3 reyes (6 %) y 44 cartas menores (86 %).
- **23 pruebas en 5 grupos** (`obtenerValorNumerico`, `compararCartas`, `evaluarJugada`, `calcularProbabilidades` y
  funciones de presentación).

## 4. Código clave

```js
// deckApi.js: hace la petición y valida la respuesta
async function pedirJson(url) {
  const respuesta = await fetch(url, { signal: AbortSignal.timeout(TIEMPO_MAXIMO_MS) });

  if (!respuesta.ok) {
    throw new Error(`La API respondió con el estado ${respuesta.status}`);
  }

  const datos = await respuesta.json();
  // La API puede responder 200 con success:false (por ejemplo, si no quedan cartas)
  if (!datos.success) {
    throw new Error(datos.error ?? 'La API no pudo completar la petición');
  }
  return datos;
}
```

```js
// cartas.js: compara la carta nueva con la actual
export function compararCartas(cartaActual, cartaNueva) {
  const valorActual = obtenerValorNumerico(cartaActual.valor);
  const valorNuevo = obtenerValorNumerico(cartaNueva.valor);

  if (valorNuevo > valorActual) return 'mayor';
  if (valorNuevo < valorActual) return 'menor';
  return 'igual';
}
```

## 5. Cómo se verificó

- `npm test` muestra **23 de 23 pruebas en verde**.
- `npm run lint` y `npm run build` terminan sin errores.
- La interfaz se probó con respuestas simuladas de la API (éxito, error HTTP y mazo agotado).

> **Pendiente importante:** el entorno donde se desarrolló bloqueaba `deckofcardsapi.com`, así que la prueba con la
> **API real** debe hacerla esta persona con `curl` o en el navegador y pegar aquí el resultado.

## 6. Evidencias que debo adjuntar (todas hechas por mí)

- [ ] **Captura de los dos `curl`** con su respuesta real:
      `curl "https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count=1"` y, con el `deck_id` que te devuelva,
      `curl "https://deckofcardsapi.com/api/deck/<deck_id>/draw/?count=1"`.
- [ ] **Captura de la pestaña Network** (`F12`) con las dos peticiones a `deckofcardsapi.com` al abrir el juego.
- [ ] **Captura de `npm test`** con las 23 pruebas pasando.
- [ ] **Captura del error de la API:** `F12` → **Network** → **Offline** → recarga la página y muestra el mensaje con
      el botón **Reintentar**.
- [ ] **Mi cambio de prueba (antes y después):** en `src/utils/cartas.test.js` cambia un número esperado (por
      ejemplo, que el As valga `15`), ejecuta `npm test`, captura que la prueba **falla** y vuelve a dejarlo correcto.

## 7. Mi aporte personal

`[Escribe con tus palabras qué estudiaste, qué probaste y qué cambiaste en tu parte.]`

## 8. Preguntas que pueden hacerme

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Por qué separan `services` y `utils`? | `services` habla con internet y `utils` tiene funciones puras. Así se puede cambiar de API sin tocar las reglas y probar las funciones sin red. |
| ¿Qué es una función pura? | Una función que, con los mismos datos de entrada, siempre da el mismo resultado y no depende de React ni de internet. |
| ¿Cómo se calcula la probabilidad? | Un mazo tiene 4 cartas de cada valor; se restan las que ya salieron y se cuentan las mayores, menores e iguales entre las que quedan. |
| ¿Qué pasa si la API falla o tarda mucho? | Pasados 10 segundos o ante cualquier error se lanza una excepción y la pantalla muestra el mensaje con **Reintentar**. |
| ¿Por qué hacer pruebas? | Para asegurar que las reglas (valores, comparación, probabilidades) sigan correctas cuando se cambie el código. |

---

# PERSONA 4 — Entrega (Docker, documentación y GitHub)

**Integrante:** `[Nombre]`

## 1. Responsabilidad

Que la app **se pueda instalar, construir y ejecutar en cualquier computadora**: la dockerización, la documentación,
el repositorio de GitHub y la comprobación final.

## 2. Archivos de mi parte

- `Dockerfile` y `.dockerignore` (en la raíz del proyecto)
- `docs/GUIA_DOCKER.md` (paso a paso de la dockerización y de Docker Hub)
- `README.md` y `docs/GUIA_PARA_DOCKERIZAR.md`
- `package.json` y `package-lock.json`
- El repositorio de GitHub (ramas y Pull Request)

## 3. Qué hace mi parte (explicación sencilla)

- La app es un **frontend estático**: sin backend y sin base de datos. `npm run build` genera la carpeta `dist/`
  (unos 254 kB) y cualquier servidor web puede servirla.
- **Datos para Docker:**
  - Node necesario para construirla: **22.12 o superior** (probado con v22.22.0).
  - Puertos: **5173** (`npm run dev`), **4173** (`npm run preview`) y normalmente **80** si se sirve con nginx.
  - **No usa variables de entorno.**
  - Necesita internet **en el navegador del usuario** (API e imágenes), no en el contenedor.
  - No copiar a la imagen: `node_modules`, `dist` local, `.git`, `.env` y archivos del editor.
- `package-lock.json` guarda las versiones exactas; `npm ci` instala exactamente esas versiones.
- La guía `docs/GUIA_PARA_DOCKERIZAR.md` compara 5 formas de servir la app (nginx, otro servidor estático, `serve`,
  `preview` y modo desarrollo) con ventajas y desventajas.
- **Opción de Docker elegida:** la **opción 5** de esa guía (una sola etapa con `npm run dev -- --host`), que es el
  método de la Guía 1 de clase. La imagen parte de `node:24-alpine`, instala las dependencias, copia el código, hace
  el build como comprobación y arranca Vite en el puerto **5173**. Se eligió porque es el método que vimos en clase,
  tiene un solo archivo corto y todos podemos explicarlo. Su desventaja es que la imagen pesa más que con nginx.
- **Cómo se ejecuta:** `docker build -t mayor-o-menor .` y luego `docker run -it --rm -p 5173:5173 mayor-o-menor`.
  Se abre en http://localhost:5173.
- **Docker Hub:** la imagen se sube con `docker push cdaniel0207/mayor-o-menor:v1` y en otra computadora se descarga con
  `docker pull`, sin instalar Node ni clonar el repositorio. Todo el paso a paso está en `docs/GUIA_DOCKER.md`.

## 4. Código clave

```json
// package.json: scripts y versión de Node requerida
"scripts": {
  "dev": "vite",
  "build": "vite build",
  "preview": "vite preview",
  "lint": "eslint . --max-warnings 0",
  "test": "vitest run"
},
"engines": { "node": "^22.12.0 || >=24.0.0" }
```

```dockerfile
# Dockerfile
FROM node:24-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

EXPOSE 5173

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
```

## 5. Cómo se verificó

Desde una instalación limpia (sin `node_modules`): `npm ci` sin errores, `npm run lint` sin errores ni advertencias,
`npm test` con 23 de 23 pruebas y `npm run build` sin errores.

## 6. Evidencias que debo adjuntar (todas hechas por mí)

- [ ] **Captura de la terminal** con `npm test`, `npm run lint` y `npm run build` terminando sin errores.
- [ ] **Captura del repositorio en GitHub** con los archivos y la lista de commits.
- [ ] **Captura del Pull Request** hacia `main` (cuando esté creado).
- [ ] **Captura de Docker:** `docker build`, `docker ps` con el contenedor en ejecución y el juego abierto en el
      navegador en el puerto que expongas.
- [ ] **Checklist** de la sección 9 de `docs/GUIA_PARA_DOCKERIZAR.md` marcado con lo que comprobaste.
- [ ] **Mi cambio de prueba:** el commit con tu Dockerfile (o el cambio que hayas hecho) en GitHub.

## 7. Mi aporte personal

<!-- TODO(human): reemplaza la línea de abajo con 3 a 5 oraciones propias: qué instalaste (WSL, Docker Desktop),
     qué comandos ejecutaste, qué error te salió y cómo lo resolviste, y qué probaste en otra computadora. -->
`[Escribe con tus palabras qué estudiaste, qué probaste y qué hiciste en tu parte.]`

## 8. Preguntas que pueden hacerme

| Pregunta | Respuesta corta |
| --- | --- |
| ¿Por qué no hay backend ni base de datos? | La app es solo frontend: toda la lógica corre en el navegador y los datos vienen de una API pública. |
| ¿Qué genera `npm run build`? | La carpeta `dist/` con HTML, CSS y JS optimizados, que cualquier servidor web puede servir. |
| ¿Para qué sirve `package-lock.json`? | Para instalar exactamente las mismas versiones en todas las computadoras (`npm ci`). |
| ¿Por qué `node_modules` no va en la imagen? | Pesa mucho y puede traer binarios de otro sistema operativo; dentro del contenedor se reinstala. |
| ¿Por qué necesita internet si está en Docker? | Porque las peticiones a la API y las imágenes las hace el navegador del usuario, no el contenedor. |
