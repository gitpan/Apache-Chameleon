# SQL script to create themes
CREATE TABLE Theme (
    theme_id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    owner_id INT(11) NOT NULL,
    header VARCHAR(100),
    footer VARCHAR(100),
    config VARCHAR(100),
    description TEXT,
    PRIMARY KEY (theme_id)
);
