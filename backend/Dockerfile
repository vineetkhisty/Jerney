FROM node:20-alpine as build

WORKDIR /app

COPY package.json package.json* ./

RUN npm install

COPY . . 

FROM node:20-alpine as production

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=build /app/node_modules ./node_modules

COPY src/ ./src/

USER appuser

EXPOSE 5000

CMD ["node", "src/index.js"]
