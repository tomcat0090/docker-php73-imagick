FROM centos

# common utils
RUN yum update -y && \
    yum install -y wget grep git ssh bash

# install php7
RUN yum install -y epel-release && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum -y install --enablerepo=remi-php73 php php-fpm php-mcrypt php-cli php-common php-devel php-gd php-mbstring php-mysqlnd php-opcache php-pdo php-pear php-pecl-apcu php-pecl-zip php-process php-xml php-intl php-redis && \
    yum clean all

# install httpd
RUN yum install -y httpd && \
    echo "<Directory /var/www/html>" >> /etc/httpd/conf/httpd.conf && \
    echo "AllowOverride All" >> /etc/httpd/conf/httpd.conf && \
    echo "</Directory>" >> /etc/httpd/conf/httpd.conf

# install imagick
RUN yum --enablerepo=remi install -y ImageMagick7 ImageMagick7-devel && \
    yum install -y gcc gcc-cpp gcc-c++ cpp make re2c icu libicu-devel && \
    pecl channel-update pecl.php.net && \
    pecl install imagick && \
    echo "extension=imagick.so" >> /etc/php.ini && \
    echo "pdo_mysql.default_socket=/var/run/mysqld/mysqld.sock" >> /etc/php.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

EXPOSE 80
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
