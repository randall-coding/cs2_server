
docker build . -t ghcr.io/randall-coding/cs2_server && \
docker push ghcr.io/randall-coding/cs2_server && \

acorn build -t cs2_server  && \

#acorn run -s cs2-server:cs2-server -v cs2-server,size=40Gi -n cs2-server-pro
# acorn run -s cs2-server:cs2-server -v home-steam,size=40Gi -n cs2-server-pro
acorn run -s cs2-server:cs2-server -n cs2-server-pro
