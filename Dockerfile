# FROM tomcat:latest
# FROM maven:3.8-jdk-11 AS build
# RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
# COPY /webapp/target/*.war /usr/local/tomcat/webapps

# FROM maven:3.8-jdk-11 AS build

# WORKDIR /project

# COPY ./webapp/ /project

# RUN mvn clean package

# FROM openjdk:11-jre-slim

# WORKDIR /app

# COPY --from=build /project/target/helloworld-1.0-SNAPSHOT.jar ./

# CMD ["java", "-jar", "./helloworld-1.0-SNAPSHOT.jar"]
# Use an official Maven image to compile the application
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Download the dependencies
RUN mvn dependency:go-offline

# Copy the source code to the container
#COPY src ./src

# Compile the application
RUN mvn package -DskipTests

# Use an official OpenJDK image as the base image for the runtime
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/myapp.jar .

# Specify the entry point for the container
ENTRYPOINT ["java", "-jar", "myapp.jar"]
