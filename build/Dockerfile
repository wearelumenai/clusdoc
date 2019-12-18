FROM gohugoio/hugo

WORKDIR /website

COPY ./ /website/

EXPOSE 1313

ENTRYPOINT ["/hugo", "server", "--renderToDisk"]
CMD [""]
