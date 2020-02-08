FROM tomcat:8-jre8
RUN rm -rf /usr/local/tomcat/webapps/*
copy target/*.war /usr/local/tomcat/webapps/
cmd ["catalina.sh","run"]
EXPOSE 8080

