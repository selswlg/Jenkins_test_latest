FROM openjdk:11
ENV APP_HOME=/user/app
WORKDIR $APP_HOME
COPY ./build/libs/*-SNAPSHOT.jar ./application.jar
EXPOSE 9999

CMD ["java", "-jar", "application.jar"]
