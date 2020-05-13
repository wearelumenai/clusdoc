from diagrams import Cluster

from diagrams.onprem.client import User, Client

with Cluster('Platform clustering visualization & management'):
    clusfront = Client('clusfront')

    # user = User('user')

    # user >> clusfront
