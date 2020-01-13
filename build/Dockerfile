FROM gohugoio/hugo AS base

FROM scratch AS dev

WORKDIR /app/clusdoc

COPY --from=base /hugo /hugo

COPY ./ /app/clusdoc/

ENTRYPOINT ["/hugo", "server", "--renderToDisk", "--bind", "0.0.0.0"]

FROM alpine AS build

WORKDIR /app/clusdoc

COPY --from=base /hugo /hugo

COPY ./ /app/clusdoc/

RUN /hugo

FROM nginx:alpine AS prod

COPY --from=build /app/clusdoc/public /usr/share/nginx/html
