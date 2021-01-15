version: "3.6"

services:
  db:
    container_name: database
    build: ./mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: php
      MYSQL_USER: phpmyadmin
      MYSQL_PASSWORD: 531486b2bf646636a6a1bba61e78ec4a4a54efbd
      MYSQL_DATABASE: abstractwallet
    networks:
      - backend

  server:
    build: "./apache/"
    depends_on:
      - db
    networks:
      - backend
    ports:
      - 80:80
    volumes:
      - ./src/:/var/www/html/

  web:
    build:
      context: "./web"
      dockerfile: Dockerfile
    depends_on:
      - server
    networks:
      - frontend
    ports:
      - 3000:80

  php:
    build:
      context: "./src"
      dockerfile: Dockerfile
    depends_on:
      - db
    networks:
      - backend
    command: /tmp/wait-for-it.sh -t 0 database:3306 -- php-fpm

networks:
  frontend:
  backend:
