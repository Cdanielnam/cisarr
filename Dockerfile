# Imagen base: Node.js 24 sobre Alpine Linux (ligera)
FROM node:24-alpine

# Carpeta de trabajo dentro del contenedor
WORKDIR /app

# Primero solo package.json y package-lock.json (aprovecha la caché de capas)
COPY package*.json ./

# Instala las dependencias dentro del contenedor
RUN npm install

# Copia el resto del proyecto (menos lo que está en .dockerignore)
COPY . .

# Comprueba que el proyecto compila para producción
RUN npm run build

# Puerto en el que escucha Vite
EXPOSE 5173

# Comando que se ejecuta al arrancar el contenedor
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0", "--port", "5173"]
