FROM eclipse-temurin:17-jdk-jammy
# Create app directory
WORKDIR /app

# Copy jar
COPY target/urlshortner-0.0.1-SNAPSHOT.jar app.jar

# Expose port
EXPOSE 8080

# Run app
ENTRYPOINT ["java", "-jar", "app.jar"]