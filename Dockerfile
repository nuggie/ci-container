FROM amazonlinux:2

# change WORKDIR to /root
WORKDIR /root

# add files direcotry
ADD ./files /root/install_files
RUN chmod -R 700 /root/install_files

# activate epel repository
RUN amazon-linux-extras install epel
# install php7.2
RUN amazon-linux-extras install php7.2
# install docker
RUN amazon-linux-extras install docker

# activate remirepo
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y yum-utils && \
    yum-config-manager --enable remi-php72

# install php extensions
RUN yum install -y php-dom

# install composer
RUN yum install -y unzip wget
RUN /root/install_files/composer_install.sh

# add composer bin directory to path
ENV PATH="${PATH}:/root/.composer/vendor/bin"

# configuration of composer
RUN composer config --global disable-tls true && \
composer config --global secure-http false
RUN mv /root/install_files/composer.json /root/.composer/composer.json

# install phpqa tools via composer
RUN composer global install

# install sonar-scanner-cli
ENV SONAR_SCANNER_VERSION 3.2.0.1227-linux
RUN wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
unzip -q sonar-scanner-cli-${SONAR_SCANNER_VERSION}.zip && \
ln -s sonar-scanner-${SONAR_SCANNER_VERSION}/bin/sonar-scanner /usr/bin/sonar-scanner


