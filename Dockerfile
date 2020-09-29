# ----------------------------------------------------------------------
# - DOCKERFILE
# - AUTOR: Brian Suarez | Eduardo Franco | Jhon Celemin | Wilman Ortiz
# - FECHA: 28-Septiembre-2020
# - DESCRIPCION: Dockerfile que permite la creacion del
# -              contenedor con el servicio Spring Cloud Eureka
# -----------------------------------------------------------------------

# escape=\ (backslash)
# Imagen base del Docker Registry para compilar nuestra servicio de Spring Cloud Eureka
# Build Stage
FROM maven:3.6.3-jdk-11-slim AS builder
WORKDIR /build/
COPY pom.xml .
COPY ./src ./src
RUN mvn clean package -Dmaven.test.skip=true

# Run Stage
FROM adoptopenjdk:11-jre-hotspot

# Parametrizacion del nombre del archivo que genera spring boot
ARG JAR_FILE=discovery-server.jar
ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_REVISION

ENV APP_HOME="/app" \
	HTTP_PORT=9091

# Informacion de la persona que mantiene la imagen
LABEL org.opencontainers.image.created=$BUILD_DATE \
	  org.opencontainers.image.authors="Brian Suarez | Eduardo Franco | Jhon Celemin | Wilman Ortiz Navarro " \
	  org.opencontainers.image.url="https://gitlab.com/bcamilo/server-eureka/-/blob/master/master/Dockerfile" \
	  org.opencontainers.image.documentation="" \
	  org.opencontainers.image.source="https://gitlab.com/bcamilo/server-eureka/-/blob/master/master/Dockerfile" \
	  org.opencontainers.image.version=$BUILD_VERSION \
	  org.opencontainers.image.revision=$BUILD_REVISION \
	  org.opencontainers.image.vendor="Pontificia Universidad Javeriana | https://www.javeriana.edu.co/" \
	  org.opencontainers.image.licenses="" \
	  org.opencontainers.image.title="Spring Cloud Eureka" \
	  org.opencontainers.image.description="El siguiente servicio gestionar toda el registro de los microservicios"

# Creando directorios de la aplicacion y de carga temporal de los archivos
RUN mkdir $APP_HOME

# Puerto de exposicion del servicio
EXPOSE $HTTP_PORT

# Copiando el compilado desde builder
COPY --from=builder /build/target/$JAR_FILE $APP_HOME/

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar ${APP_HOME}/discovery-server.jar"]