FROM openjdk:8 as build
#EXPOSE 5432
ENV WORKSPACE=/home/
COPY . ${WORKSPACE}
WORKDIR ${WORKSPACE}
#ENV POSTGRES_HOST=postgres
#ENV POSTGRES_USER=admin
#ENV POSTGRES_PASSWORD=admin
RUN apt-get update -y \
  && apt-get -y install maven \
  && apt-get update && apt-get install dos2unix \
  && mvn -version \
  && dos2unix mvnw && cd ${WORKSPACE}/ && mvn -N wrapper:wrapper && ./mvnw clean install -DskipTests
  #&& mvn -N wrapper:wrapper \
  #&& ./mvnw clean install -f ${WORKSPACE}/pom.xml \
FROM openjdk:8
WORKDIR /home
#RUN apt-get update \
#&& apt-get install postgresql -y
#RUN echo "listen_addresses = '5432'" >> /etc/postgresql/13/main/postgresql.conf
COPY --from=build /home/target/postgres-demo-0.0.1-SNAPSHOT.jar  /home/app.jar
ENV POSTGRES_HOST=postgres
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin
EXPOSE 5432
#RUN echo "#!/bin/sh \n service postgresql start \n java -jar /home/app.jar" > ./runProvarTests.sh
#RUN chmod +x ./runProvarTests.sh
#ENTRYPOINT ["./runProvarTests.sh"]
#CMD bash
ENTRYPOINT ["java", "-jar", "/home/app.jar"]