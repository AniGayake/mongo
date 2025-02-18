# Step 1: Use an official Maven image to build the project
FROM maven:3.8.6-openjdk-17-slim AS build

RUN apt-get update && apt-get install -y maven
# Set the working directory inside the container
WORKDIR /app

# Step 2: Copy the Maven project files (pom.xml, etc.) into the container
COPY pom.xml .

# Step 3: Download the dependencies (using Maven)
RUN mvn dependency:go-offline

# Step 4: Copy the entire project source code into the container
COPY src /app/src

# Step 5: Build the project (compile the Java code and package it)
RUN mvn clean package -DskipTests

# Step 6: Use a lighter base image for running the application
FROM openjdk:17-slim

# Set the working directory inside the container
WORKDIR /app

# Step 7: Copy the JAR file from the build image to the runtime image
COPY --from=build /app/target/your-app.jar /app/your-app.jar

# Step 8: Expose the port the application will run on (if needed)
EXPOSE 8080

# Step 9: Command to run the application
CMD ["java", "-jar", "your-app.jar"]
