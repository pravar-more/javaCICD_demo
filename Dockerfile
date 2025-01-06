#FROM tomcat:latest
#RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
#COPY /webapp/target/*.war /usr/local/tomcat/webapps

FROM maven:3.8-jdk-11 AS build

WORKDIR /project

COPY ./webapp/ /project

RUN mvn clean package

FROM openjdk:11-jre-slim

WORKDIR /app

COPY --from=build /project/target/helloworld-1.0-SNAPSHOT.jar ./

CMD ["java", "-jar", "./helloworld-1.0-SNAPSHOT.jar"]
