FROM centos:latest
MAINTAINER Dushyant Khosla <dushyant.khosla@yahoo.com

# === COPY FILES ===

COPY environment.yml /root/environment.yml
COPY start.sh /etc/profile.d/

# === SET ENVIRONMENT VARIABLES ===

ENV PATH="/miniconda/bin:${PATH}"
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8

ENV JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk"
ENV JRE_HOME="/usr/lib/jvm/jre"
ENV SPARK_HOME="/root/apache-spark"
ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PYSPARK_DRIVER_PYTHON="jupyter"
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip=0.0.0.0 --port=8080 --no-browser --allow-root"

# === INSTALL DEPENDENCIES ===

WORKDIR /root
RUN yum -y install bzip2 \
                   curl \
                   curl-devel \
                   perl-devel \
                   perl-CPAN \
                   tmux \
                   wget \
                   which \
                   zlib-devel \
	&& yum -y groupinstall "Development Tools" \
&& yum -y remove git \
	&& wget https://github.com/git/git/archive/v2.15.1.tar.gz -O git.tar.gz \
	&& tar -zxf git.tar.gz \
	&& rm -f git.tar.gz \
&& wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh \
	&& bash miniconda.sh  -b -p /miniconda \
	&& conda config --append channels conda-forge \
	&& conda create -y -n env_pyspark python=3 \
        && conda activate env_pyspark \
        && conda install -y -c conda-forge pandas==1.1.1 pyarrow==1.0.1 jupyterlab scikit-learn seaborn sidetable pyspark \
	&& conda clean -i -l -t -y \
	&& rm miniconda.sh \
&& yum install -y java-1.8.0-openjdk.x86_64 --quiet \
	&& wget http://dlcdn.apache.org/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz \
	&& tar xvf spark-2.2.1-bin-hadoop2.7.tgz \
	&& mv spark-2.2.1-bin-hadoop2.7 /root/apache-spark \
	&& rm spark-2.2.1-bin-hadoop2.7.tgz \
&& wget https://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo -P /etc/yum.repos.d/ \
	&& yum install -y fish \
&& yum -y autoremove \
  	&& yum clean all \
	&& rm -rf /var/cache/yum

WORKDIR /root/git-2.15.1
RUN make configure \
	&& ./configure --prefix=/usr/local \
	&& make install \
	&& rm -rf /git-2.15.1

# === INITIALIZE ===

WORKDIR /home/
EXPOSE 8080
CMD /usr/bin/bash
