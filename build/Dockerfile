FROM gohugoio/hugo AS base

FROM scratch AS dev

WORKDIR /website

COPY --from=base /hugo /hugo

COPY ./ /website/

ENTRYPOINT ["/hugo", "server", "--renderToDisk", "--bind", "0.0.0.0"]

FROM alpine AS build

WORKDIR /website

COPY --from=base /hugo /hugo

COPY ./ /website/

RUN /hugo

FROM nginx:alpine AS prod

COPY --from=build /website/public /usr/share/nginx/html
