from diagrams import Cluster

from diagrams.onprem.compute import Server
from diagrams.onprem.inmemory import Redis
from diagrams.onprem.queue import RabbitMQ

with Cluster('Graph clustering'):
    grphclus = Server('grphclus-rest')
    grphclus_optimizer = Server('grphclus-optimizer')
    grphclus_pollster = Server('grphclus-pollster')

    inmemory = Redis('in memory')
    bus = RabbitMQ('edge inputs')

    grphclus_pollster >> bus
    grphclus_optimizer >> [grphclus_pollster, inmemory]

    grphclus >> inmemory
