from diagrams import Cluster, Edge

from diagrams.onprem.compute import Server, Nomad


with Cluster('Authentication'):
    clusauth = Server('clusauth')
    vouch = Nomad('vouch-proxy')
    sso = Server('Auth provider (Auth0, ...)')

    clusauth >> vouch >> sso
