FROM kmubigdata/ubuntu-hadoop
MAINTAINER kimjeongchul

USER root

# scala
RUN apt-get update
RUN apt-get install -y scala

# python
RUN apt-get install -y python
RUN apt-get install -y python3

# spark 2.4.0 without Hadoop
RUN wget https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz
RUN tar -xvzf spark-2.4.0-bin-without-hadoop.tgz -C /usr/local
RUN cd /usr/local && ln -s ./spark-2.4.0-bin-without-hadoop spark
RUN rm -f /spark-2.4.0-bin-without-hadoop.tgz

# ENV hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV LD_LIBRARY_PATH=/usr/local/hadoop/lib/native/:$LD_LIBRARY_PATH

# ENV spark
ENV SPARK_HOME /usr/local/spark
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

ADD spark-env.sh $SPARK_HOME/conf/spark-env.sh
ADD spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
ADD run-sparkshell.sh $SPARK_HOME/run-sparkshell.sh
RUN cp $HADOOP_HOME/etc/hadoop/workers $SPARK_HOME/conf/slaves

COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
RUN chmod +x /usr/local/spark/run-sparkshell.sh

#export yarn_conf_dir

ENTRYPOINT ["/etc/bootstrap.sh"]
