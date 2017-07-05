DROP TABLE IF EXISTS pairs;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS nouns;
DROP TABLE IF EXISTS adjectives;
DROP TABLE IF EXISTS requests;

CREATE TABLE pairs(
  id SERIAL4 PRIMARY KEY,
  digits VARCHAR(30) NOT NULL,
  time_stamp TIMESTAMP NOT NULL,
  adjective_1_id INTEGER NOT NULL,
  noun_1_id INTEGER NOT NULL,
  adjective_2_id INTEGER NOT NULL,
  noun_2_id INTEGER NOT NULL,
  access_count INTEGER
);

CREATE TABLE nouns(
  id SERIAL4 PRIMARY KEY,
  word VARCHAR(16) NOT NULL
);

CREATE TABLE adjectives(
  id SERIAL4 PRIMARY KEY,
  word VARCHAR(16) NOT NULL
);

CREATE TABLE requests(
  id SERIAL4 PRIMARY KEY,
  request_type VARCHAR(6),
  status VARCHAR(6) NOT NULL,
  pair_id INTEGER,
  digits VARCHAR(30) NOT NULL,
  email VARCHAR(300),
  message VARCHAR(5000),
  time_stamp TIMESTAMP NOT NULL
);

CREATE TABLE users(
  id SERIAL4 PRIMARY KEY,
  email VARCHAR(300),
  password_digest TEXT
);
