# SQL script to create user preferences
CREATE TABLE Preferences (
    pref_id INT(11) NOT NULL AUTO_INCREMENT,
    user_id INT(11) NOT NULL,
    description VARCHAR(50),
    type VARCHAR(40),
    selector VARCHAR(40),
    property VARCHAR(40),
    value VARCHAR(40),
    PRIMARY KEY (pref_id)
);
