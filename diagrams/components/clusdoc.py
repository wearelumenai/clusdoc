from diagrams import Cluster

from diagrams.onprem.client import User, Client

with Cluster('Documentation'):
    clusdoc = Client('clusdoc')
