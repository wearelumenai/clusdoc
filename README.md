# TLOTL-Website

The lady of the lake Documentation

## Remarks

You might need to install:
- [docker-compose](https://docs.docker.com/compose/install/)
- [make](http://www.gnu.org/software/make/)

Each time you commit to master, the public folder will be published in the repo https://github.com/wearelumenai/wearelumenai.github.io

Once you choose a command, the documentation will be available at http://localhost:1313

## See documentation without drafts (default)

If you modify the documentation, the result will be published in the directory `public` and the webpage will be updated (hot-reload).

```bash
make doc
```

## Build

Generate files without drafts in the directory `public`

```bash
make build
```

## See documentation with drafts

Every modification will modify the directory `public`

```bash
make doc-drafts
```

## With docker

Hot-reload, doc-generation in `public` and no drafts

```bash
make docker
```

Hot-reload, doc-generation in `public` and drafts

```bash
make docker-drafts
```

Enjoy
