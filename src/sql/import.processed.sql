LOAD DATA
  INFILE 'D:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\processed.csv'
  INTO TABLE events
  FIELDS
    TERMINATED BY ','
    ENCLOSED BY '"'
    ESCAPED BY '\"'
  LINES
    TERMINATED BY '\n'
  IGNORE 1 LINES
;

