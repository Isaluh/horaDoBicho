FROM openjdk:17-slim-bullseye

COPY target/horaDoBicho-0.0.1-SNAPSHOT.jar /usr/app/horaDoBicho.jar

WORKDIR /usr/app

EXPOSE 8080

CMD ["java", "-jar", "horaDoBicho.jar"]
