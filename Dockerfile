FROM ezheidtmann/osrm

ENV OSM_PBF_URL http://download.geofabrik.de/north-america/us-west-latest.osm.pbf
ENV OSRM_FILENAME thedata

RUN echo 'disk=/data/stxxl,0,syscall' > /build/.stxxl

RUN mkdir /tmp-data && \
  curl $OSM_PBF_URL > /tmp-data/$OSRM_FILENAME.osm.pbf && \
  ./osrm-extract /tmp-data/$OSRM_FILENAME.osm.pbf && \
  ./osrm-prepare /tmp-data/$OSRM_FILENAME.osrm

RUN mkdir /built && mv \
  /tmp-data/$OSRM_FILENAME.osrm.names \
  /tmp-data/$OSRM_FILENAME.osrm.nodes \
  /tmp-data/$OSRM_FILENAME.osrm.edges \
  /tmp-data/$OSRM_FILENAME.osrm.geometry \
  /tmp-data/$OSRM_FILENAME.osrm.hsgr \
  /tmp-data/$OSRM_FILENAME.osrm.ramIndex \
  /tmp-data/$OSRM_FILENAME.osrm.fileIndex \
  /built/ && \
  rm -r /tmp-data

CMD ./osrm-routed /built/$OSRM_FILENAME.osrm
