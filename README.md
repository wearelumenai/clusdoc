# Clusdoc

The lady of the lake Documentation Website contains tutorials to use unsupervised online learning algorithms based on the Golang library distclus and his python interface disclut4py.

## Remarks

You might need to install:
- [make](http://www.gnu.org/software/make/) for using the Makefile
- [hugo](https://gohugo.io/getting-started/quick-start/) if you do not have docker
- [docker-compose](https://docs.docker.com/compose/install/) if you do not want to install hugo

Each time you commit to master, the public folder will be published in the repo https://github.com/wearelumenai/wearelumenai.github.io

Once you choose a command, the documentation will be available at http://localhost:8004

## Build

```bash
make build
# or for docker
make docker-build 
```

## Usage

Expose documentation at http://localhost:8004

### Legacy

```bash
# production mode without drafts
make start
# dev mode with hot-reload and drafts
make dev
```

### With docker

```bash
# production mode
make docker-up
# dev mode with hot-reload and drafts
make docker-dev-up
# and with additional args
ARGS="--build -d" make docker-up # up prod container in rebuilding image and in detached mode
```

> Other commands are `docker-[dev-](build|stop|down|logs|restart|config|tty|cmd)`

Enjoy
