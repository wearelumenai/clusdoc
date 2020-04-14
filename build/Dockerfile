FROM gohugoio/hugo AS base

FROM scratch AS dev

WORKDIR /app/clusdoc

COPY . .

COPY --from=base /hugo /hugo

ENTRYPOINT ["/hugo", "server", "-p", "8004", "--renderToDisk", "--bind", "0.0.0.0"]

EXPOSE 8004

FROM nginx:alpine AS prod

WORKDIR /app/clusdoc

COPY . .

COPY --from=base /hugo /hugo

RUN /hugo && rm /hugo && mv /app/clusdoc/public/* /usr/share/nginx/html/

EXPOSE 80
