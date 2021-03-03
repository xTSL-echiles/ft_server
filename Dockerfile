FROM debian:buster
#nginx
RUN apt-get update  && apt -y install nginx 
#VIM and zip
RUN apt-get -y install vim wget openssl
RUN apt-get -y install unzip
#PHP
RUN apt-get -y install mariadb-server
RUN apt-get -y install php-cli php-fpm php-json php-pdo php-mysql php-zip php-gd php-mbstring php-curl php-xml php-pear php-bcmath
#PHPMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip
RUN unzip phpMyAdmin-5.1.0-all-languages.zip
RUN rm -f phpMyAdmin-5.1.0-all-languages.zip
RUN mv phpMyAdmin-5.1.0-all-languages /var/www/html/phpMyAdmin
#WORD PRESS
RUN		wget http://wordpress.org/latest.tar.gz && \
		tar -xzvf latest.tar.gz && rm -rf latest.tar.gz && \
		mv wordpress /var/www/html/
#bash file
COPY ./src/*.sh ./
##nginx conf
COPY ./src/nginx.conf etc/nginx/sites-available
COPY ./src/wp-config.php var/www/html/wordpress
RUN	rm -rf /var/www/html/wordpress/wp-config-sample.php
RUN rm -rf /etc/nginx/sites-enabled/default && \
	rm -rf /etc/nginx/sites-available/default
RUN	ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf
#SSL protocol
RUN openssl req -newkey rsa:4096 \
            -x509 \
            -sha256 \
            -days 365 \
            -nodes \
            -out /etc/ssl/echiles.crt \
            -keyout /etc/ssl/echiles.key \
            -subj "/C=RU/ST=Central/L=Moscow/O=21school/OU=ft_server/CN=www.echiles.com"
RUN bash mysql.sh
RUN	chown -R www-data:www-data /var/www/html/* 
CMD bash 1st.sh
EXPOSE 80 443
