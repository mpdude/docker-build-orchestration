FROM php:7.3-apache

# Run on a higher port number (allows running as a non root user)
RUN sed -i "s/80/1080/" /etc/apache2/ports.conf \
