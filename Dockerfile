FROM goodguide/base-oracle-java-7

RUN mkdir /opt/confluence \
 && cd /opt/confluence \
 && curl -L http://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-5.5.0.tar.gz \
  | tar -xz --strip-components=1

RUN mkdir -p /opt/confluence/confluence/WEB-INF/classes/ \
 && echo "confluence.home=/data" > /opt/confluence/confluence/WEB-INF/classes/confluence-init.properties

WORKDIR /opt/confluence
VOLUME /data

EXPOSE 8090

ENV JAVA_OPTS -Xms512m -Xmx2g -Djava.awt.headless=true

# Prime the cache and temp dirs as much as possible
RUN /opt/confluence/bin/start-confluence.sh \
 && sleep 10 \
 && curl http://localhost:8090/

CMD ["bin/start-confluence.sh", "-fg"]
