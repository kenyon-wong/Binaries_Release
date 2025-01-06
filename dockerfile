# Build stage
FROM node:alpine AS build

RUN apk add --no-cache python3 git && ln -sf python3 /usr/bin/python

COPY . /app
WORKDIR /app

RUN npm ci && npm prune && npm run build

# Final stage
FROM node:alpine

ENV LANG en_US.UTF-8

WORKDIR /app

COPY --from=build /app/node_modules /app/node_modules
COPY --from=build /app/build /app/build

EXPOSE 3000
CMD ["node", "index.js"]
