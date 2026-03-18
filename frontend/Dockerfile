FROM node:alpine-20 as base

WORKDIR /app

COPY package.json, package*.json ./

RUN npm ci && npm cache clean --force

COPY . .

RUN npm run build

FROM nginx:1.27-alpine as Production

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build /app/dist /usr/share/nginx/html

RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/log/nginx && \
    touch /var/run/nginx.pid && \
    chown -R nginx:nginx /var/run/nginx.pid

USER nginx

EXPOSE 8080

CMD ["nginx","-g","daemon off;"]


