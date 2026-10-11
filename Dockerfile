FROM nginx:alpine
RUN rm -f /usr/share/nginx/html/index.html /usr/share/nginx/html/50x.html
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY build/ /usr/share/nginx/html/
EXPOSE 80
