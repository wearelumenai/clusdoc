# generate platform architecture diagram on platform.png
from diagrams import Diagram, Edge

from diagrams.onprem.network import Nginx
from diagrams.onprem.client import User


def main():
    with Diagram(
        "Architecture of the platform: The lady of the lake",
        show=True,
        direction='LR',
        filename='static/media/platform'
    ):

        from components.clusfront import clusfront
        from components.clustore import clustore
        from components.cluserve import cluserve
        from components.clusauth import clusauth
        from components.clusdoc import clusdoc
        from components.grphclus import grphclus
        from components.evclus import evclus, cluschema

        user = User('user')

        # nginx = Nginx('nginx')

        # nginx >> [clusfront, clustore, cluserve, clusauth, clusdoc, grphclus, evclus]

        clusfront >> Edge(label='/clustore', style='dashed') >> clustore
        clusfront >> Edge(label='/cluserve', style='dashed') >> cluserve
        clusfront >> Edge(label='/clusauth', style='dashed') >> clusauth
        clusfront >> Edge(label='/clusdoc', style='dashed') >> clusdoc
        clusfront >> Edge(label='/grphclus', style='dashed') >> grphclus

        cluserve >> Edge(style='dashed') >> [clustore, clusauth]

        clustore >> Edge(style='dashed') >> clusauth

        evclus >> cluserve

        user >> [clusfront, cluschema, clusdoc, grphclus]

if __name__ == '__main__':
    main()
