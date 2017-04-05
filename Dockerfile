FROM ubuntu:14.04

MAINTAINER shim007
MAINTAINER xinlin28436@qq.com


WORKDIR /root/
RUN mkdir workspace
WORKDIR /root/workspace/
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y mariadb-server
RUN echo "[mysqld]"      >/etc/mysql/conf.d/docker.cnf
RUN echo "bind-address = 0.0.0.0"  >>/etc/mysql/conf.d/docker.cnf
RUN echo "innodb_flush_method = O_DSYNC" >>/etc/mysql/conf.d/docker.cnf
RUN echo "skip-name-resolve"    >>/etc/mysql/conf.d/docker.cnf
RUN echo "init_file = /etc/mysql/init" >>/etc/mysql/conf.d/docker.cnf
RUN echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'root';" >/etc/mysql/init

ADD resource/jre-8u121-linux-x64.tar.gz /root/workspace/
RUN ls -al /root/workspace/
#WORKDIR /root/workspace/
#RUN tar -xzvf jre-8u121-linux-x64.tar.gz
RUN mkdir /usr/jvm
RUN mv jre1.8.0_121 /usr/jvm
ENV JAVA_HOME /usr/jvm/
ENV JRE_HOME $JAVA_HOME/jre1.8.0_121/
ENV CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib

ADD resource/apache-tomcat-8.0.43.tar.gz /root/workspace/
#WORKDIR /root/workspace/
#RUN tar -xzvf apache-tomcat-8.0.43.tar.gz
RUN mkdir /usr/opt
RUN mv apache-tomcat-8.0.43 /usr/opt/tomcat
RUN chmod +x /usr/opt/tomcat/bin/startup.sh

RUN touch /var/log/messages

EXPOSE 8080 3306

WORKDIR /root/

ENTRYPOINT /usr/opt/tomcat/bin/startup.sh && service mysql start && tail -f /var/log/messages