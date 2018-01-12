FROM centos:latest
MAINTAINER Dushyant Khosla <dushyant.khosla@yahoo.com

COPY environment.yml environment.yml

# Install Dependencies
# —————————————————————————————————————————————

RUN yum -y install tmux \
                 bzip2 \
                 wget \
                 which \
                 curl

# Get and Install Conda
# —————————————————————————————————————————————

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh \
	&& bash miniconda.sh  -b -p /miniconda \
	&& rm miniconda.sh

ENV PATH="/miniconda/bin:${PATH}"
RUN conda env create -f environment.yml --quiet

# Install latest version of Git
# —————————————————————————————————————————————
RUN yum -y remove git \
	&& wget https://github.com/git/git/archive/v2.15.1.tar.gz -O git.tar.gz \
	&& tar -zxf git.tar.gz \
	&& rm -f git.tar.gz

WORKDIR git-2.15.1

RUN yum -y groupinstall "Development Tools"
RUN yum -y install zlib-devel \
                 perl-devel \
                 perl-CPAN \
                 curl-devel

RUN make configure \
	&& ./configure --prefix=/usr/local \
	&& make install \
	&& rm -rf /git-2.15.1/


# Get Spark
# —————————————————————————————————————————————
WORKDIR /root
RUN yum install -y java-1.8.0-openjdk.x86_64 --quiet \
	&& wget http://apache.redkiwi.nl/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz \
	&& tar xvf spark-2.2.1-bin-hadoop2.7.tgz \
	&& mv spark-2.2.1-bin-hadoop2.7 /root/apache-spark \
	&& rm spark-2.2.1-bin-hadoop2.7.tgz

ENV JAVA_HOME="/usr/lib/jvm/jre-1.8.0-openjdk"
ENV JRE_HOME="/usr/lib/jvm/jre"
ENV SPARK_HOME="/root/apache-spark"

ENV PATH="$SPARK_HOME/bin:${PATH}"
ENV PYSPARK_DRIVER_PYTHON="jupyter"
ENV PYSPARK_DRIVER_PYTHON_OPTS="notebook --ip=0.0.0.0 --port=8080 --no-browser --allow-root"

# Get Fish and OMF
# —————————————————————————————————————————————
WORKDIR /etc/yum.repos.d/
RUN wget https://download.opensuse.org/repositories/shells:fish:release:2/CentOS_7/shells:fish:release:2.repo \
	&& yum install -y fish

# Clean up
# —————————————————————————————————————————————
RUN yum -y autoremove \
	&& yum clean all \
	&& rm -rf /var/cache/yum

# Activate the Environment
# —————————————————————————————————————————————
ENV PATH="/miniconda/envs/pmi-ds-env/bin/:${PATH}"

# Start Here
# —————————————————————————————————————————————
WORKDIR /home/
RUN git clone https://github.com/dushyantkhosla/ds-template-01.git
WORKDIR /home/ds-template-01

EXPOSE 8080
CMD /usr/bin/fish
