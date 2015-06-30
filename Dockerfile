FROM ezheidtmann/osrm

ENV OSM_PBF_URL http://download.geofabrik.de/north-america/us-west-latest.osm.pbf
ENV OSRM_FILENAME thedata

RUN echo 'disk=/data/stxxl,0,syscall' > /build/.stxxl

RUN curl $OSM_PBF_URL > /data/$OSRM_FILENAME.osm.pbf && \
  ./osrm-extract /data/$OSRM_FILENAME.osm.pbf && \
  ./osrm-prepare /data/$OSRM_FILENAME.osrm && \
  mkdir /built && mv \
  /data/$OSRM_FILENAME.osrm.names \
  /data/$OSRM_FILENAME.osrm.nodes \
  /data/$OSRM_FILENAME.osrm.edges \
  /data/$OSRM_FILENAME.osrm.geometry \
  /data/$OSRM_FILENAME.osrm.hsgr \
  /data/$OSRM_FILENAME.osrm.ramIndex \
  /data/$OSRM_FILENAME.osrm.fileIndex \
  /built/

CMD ./osrm-routed /built/$OSRM_FILENAME.osrm
