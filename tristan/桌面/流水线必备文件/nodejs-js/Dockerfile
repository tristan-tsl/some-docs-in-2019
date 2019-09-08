FROM nginx
WORKDIR /usr/share/nginx/html
COPY dist/ front/
RUN mv front/index.html index.html
EXPOSE 80