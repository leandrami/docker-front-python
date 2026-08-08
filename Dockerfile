#definindo a primeira imagem (com NODE) baixando o sistema operacional linux, ja com o node 20 instalado
FROM node:20.18-alpine AS build

#cria uma pasta e entra na mesma para que o sistema fique organizado, pois as prox instruções acontecerão nela
WORKDIR /app

#copia para dentro da pasta /app as bibliotecas do node q o projeto precisará
COPY /package.json  

#instala na pasta as bibliotecas q foram copiadas anteriormente
RUN npm install

# copia todos os arquivos do projeto para dentro da pasta
COPY . .

#gera a versão final(na criação da imagem) de produção do projeto (p dist/), compilando o código com o Vite
RUN npm run build

#nova imagem apenas com o nginx q serve os arquivos ao front
FROM nginx:alpine

# copia apenas a pasta "dist" para a pasta padrão do nginx
COPY --from=build/app/dist /usr/share/nginx/html

#copia a configuração personalizada do Nginx (arquivo nginx.conf)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# mostra a porta q o Nginx usará
EXPOSE 80
