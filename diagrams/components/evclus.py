from diagrams import Cluster, Edge

from diagrams.onprem.compute import Server
from diagrams.onprem.client import User, Client
from diagrams.oci.monitoring import Event

with Cluster('Event clustering', direction="TB"):
    evclus = Server('evclus')

    # user = User('user')
    cluschema = Client('cluschema')
    cluschema >> evclus
    # user >> cluschema >> evclus
