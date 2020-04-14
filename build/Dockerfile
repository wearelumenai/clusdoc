FROM gohugoio/hugo AS base

FROM scratch AS dev

WORKDIR /app/clusdoc

COPY . .

COPY --from=base /hugo /hugo

ENTRYPOINT ["/hugo", "server", "-p", "8004", "--renderToDisk", "--bind", "0.0.0.0"]

EXPOSE 8004

FROM base AS build

RUN /hugo

FROM nginx:alpine AS prod

COPY --from=build /app/clusdoc/public /usr/share/nginx/html

EXPOSE 80
