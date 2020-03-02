CREATE DATABASE ngrok
USE ngrok

CREATE TABLE ngrok(
    pcname  VARCHAR(255) PRIMARY KEY,
    ngrok   VARCHAR(255) NOT NULL,
    VPN     VARCHAR(255) NOT NULL,
    protocol VARCHAR(255) NOT NULL,
    timestamp VARCHAR(255) NOT NULL
)