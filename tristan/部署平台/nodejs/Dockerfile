FROM node:10.16.0
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm config set registry https://registry.npm.taobao.org
RUN npm install
COPY . .
EXPOSE 8080
ENV TZ=Asia/Shanghai
CMD [ "npm","run", "build" ]