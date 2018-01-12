set -x SPARK_HOME /root/apache-spark
set -x PATH $PATH $SPARK_HOME/bin/
set -x PYSPARK_DRIVER_PYTHON jupyter
set -x PYSPARK_DRIVER_PYTHON_OPTS 'notebook --ip=0.0.0.0 --port=8080 --no-browser --allow-root'

set -x JAVA_HOME /usr/lib/jvm/jre-1.8.0-openjdk
set -x JRE_HOME /usr/lib/jvm/jre
