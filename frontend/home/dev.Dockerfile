FROM node:20.0.0


WORKDIR /app

COPY package*.json ./

RUN npm install 
#--legacy-peer-deps

COPY . .

EXPOSE 3000

ENV NUXT_HOST=0.0.0.0

ENV NUXT_PORT=3000



ENTRYPOINT [ "npm","run","dev" ]