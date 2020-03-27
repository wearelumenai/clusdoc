FROM gohugoio/hugo:0.31.1 AS base

FROM scratch AS dev

WORKDIR /app/clusdoc

COPY --from=base /hugo /hugo

COPY . .

ENTRYPOINT ["/hugo", "server", "--renderToDisk", "--bind", "0.0.0.0"]

FROM alpine:3.11.3 AS build

WORKDIR /app/clusdoc

COPY --from=base /hugo /hugo

COPY . .

RUN /hugo

FROM nginx:1.17.8-alpine AS prod

COPY --from=build /app/clusdoc/public /usr/share/nginx/html
