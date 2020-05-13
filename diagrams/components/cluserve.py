from diagrams import Cluster
from diagrams.onprem.compute import Server, Nomad


with Cluster('Clustering'):
    cluserve = Server('cluserve')
    cluscale = Server('cluscale')
    distclus = Nomad('distclus')

    cluserve >> [distclus, cluscale]
