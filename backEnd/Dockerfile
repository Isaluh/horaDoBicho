# Stage 1 — build do projeto
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app

COPY . .

RUN chmod +x mvnw
RUN chmod -R +x .mvn

RUN ./mvnw -q clean package -DskipTests

# Stage 2 — imagem final
FROM eclipse-temurin:17-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
