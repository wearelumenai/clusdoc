# Clusdoc

The lady of the lake Documentation Website contains tutorials to use unsupervised online learning algorithms based on the Golang library distclus and his python interface disclut4py.

## Remarks

You might need to install:
- [make](http://www.gnu.org/software/make/) for using the Makefile
- [hugo](https://gohugo.io/getting-started/quick-start/) if you do not have docker
- [docker-compose](https://docs.docker.com/compose/install/) if you do not want to install hugo

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

## Dev with drafts

Every modification will modify the directory `public`

```bash
make doc-dev
```

## With docker

### production doc without drafts

Expose doc at http://localhost:1313

```bash
make docker
# or with specific args
args="--build" make docker
```

> Other commands are docker-(build|stop|down)

### hot-reload doc-generation in `public/` with drafts

Expose doc at http://localhost:1313

```bash
make docker-dev
# or with specific args
args="--build" make docker-dev
```

> Other commands are docker-dev-(build|stop|down)

Enjoy
