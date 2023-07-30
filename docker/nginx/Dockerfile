FROM node:14 as node-build
COPY ./src /application
WORKDIR /application
RUN apt-get update
RUN npm install \
    && npm run prod

FROM nginx:1.19.2
WORKDIR /application
RUN apt-get update
COPY ./docker/nginx/ecs/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY --from=node-build /application/public /application/public/
EXPOSE 80
