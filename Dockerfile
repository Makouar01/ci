# Étape 1 : Build de l'application avec Maven
FROM maven:3.9.9-eclipse-temurin-21 AS builder

# Crée un dossier de travail
WORKDIR /app

# Copie le pom.xml et télécharge les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copie le code source
COPY src ./src

# Compile et package l’application
RUN mvn clean package -DskipTests

# Étape 2 : Image finale légère (runtime seulement)
FROM eclipse-temurin:21-jdk-jammy

# Répertoire de travail
WORKDIR /app

# Copie le JAR depuis l'étape builder
COPY --from=builder /app/target/*.jar app.jar

# Expose le port (par défaut Spring Boot : 8080)
EXPOSE 8090

# Démarre l’application
ENTRYPOINT ["java", "-jar", "app.jar"]
