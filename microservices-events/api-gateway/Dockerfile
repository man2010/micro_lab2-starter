FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production
# Installer curl
RUN apk add --no-cache curl

COPY src ./src

EXPOSE 8000

CMD ["npm", "start"]