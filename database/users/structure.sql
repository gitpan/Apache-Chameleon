# SQL script to create users
CREATE TABLE Users (
    user_id INT(11) NOT NULL AUTO_INCREMENT,
    username VARCHAR(40) NOT NULL,
    email VARCHAR(40) NOT NULL,
    realname VARCHAR(40),
    password VARCHAR(20) NOT NULL,
    status VARCHAR(40),
    created DATETIME,
    last_access DATETIME,
    last_ip_address VARCHAR(40),
    PRIMARY KEY (user_id),
    UNIQUE (username)
);
