from diagrams import Cluster, Edge

from diagrams.onprem.compute import Server
from diagrams.onprem.database import PostgreSQL


with Cluster('Clustering & organization storage'):
    clustore = Server('clustore')
    db = PostgreSQL('database')
    hasura = Server('hasura')
    clustore >> [db, hasura]
    hasura >> Edge(label='perm & event-trigger') >> clustore
