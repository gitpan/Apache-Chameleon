# SQL script to create documents
CREATE TABLE Documents (
     document_id INT(11) NOT NULL AUTO_INCREMENT,
     path VARCHAR(40) NOT NULL,
     title VARCHAR(100) DEFAULT "Untitled Document",
     version INT(11) NOT NULL, # version control, keep every copy?
     author_id INT(11) NOT NULL, # author user_id
     locker_id INT(11), # user_id of locker
     created DATETIME,
     type VARCHAR(40), # parsed or not and other stuff?
     worldread INT(1),
     worldwrite INT(1),
     contents TEXT,
     PRIMARY KEY (document_id)
);
