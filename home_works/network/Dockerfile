FROM node:latest

EXPOSE 3000/tcp

WORKDIR /etc/app

COPY ./nodejs-demo .

RUN npm install

CMD ["npm", "start"]