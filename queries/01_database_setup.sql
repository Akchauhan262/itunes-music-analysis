-- ============================================================
-- FILE: 01_database_setup.sql
-- PROJECT: Apple iTunes Music Store Analysis
-- PURPOSE: Create all tables with primary and foreign keys
-- ============================================================

-- Run these in order (foreign key dependencies matter)

CREATE TABLE media_type (
    media_type_id INTEGER PRIMARY KEY,
    name          TEXT
);

CREATE TABLE genre (
    genre_id INTEGER PRIMARY KEY,
    name     TEXT
);

CREATE TABLE artist (
    artist_id INTEGER PRIMARY KEY,
    name      TEXT
);

CREATE TABLE album (
    album_id  INTEGER PRIMARY KEY,
    title     TEXT,
    artist_id INTEGER,
    FOREIGN KEY (artist_id) REFERENCES artist(artist_id)
);

CREATE TABLE track (
    track_id      INTEGER PRIMARY KEY,
    name          TEXT,
    album_id      INTEGER,
    media_type_id INTEGER,
    genre_id      INTEGER,
    composer      TEXT,
    milliseconds  INTEGER,
    bytes         INTEGER,
    unit_price    REAL,
    FOREIGN KEY (album_id)      REFERENCES album(album_id),
    FOREIGN KEY (media_type_id) REFERENCES media_type(media_type_id),
    FOREIGN KEY (genre_id)      REFERENCES genre(genre_id)
);

CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    last_name   TEXT,
    first_name  TEXT,
    title       TEXT,
    reports_to  INTEGER,
    levels      TEXT,
    birthdate   TEXT,
    hire_date   TEXT,
    address     TEXT,
    city        TEXT,
    state       TEXT,
    country     TEXT,
    postal_code TEXT,
    phone       TEXT,
    fax         TEXT,
    email       TEXT
);

CREATE TABLE customer (
    customer_id    INTEGER PRIMARY KEY,
    first_name     TEXT,
    last_name      TEXT,
    company        TEXT,
    address        TEXT,
    city           TEXT,
    state          TEXT,
    country        TEXT,
    postal_code    TEXT,
    phone          TEXT,
    fax            TEXT,
    email          TEXT,
    support_rep_id INTEGER,
    FOREIGN KEY (support_rep_id) REFERENCES employee(employee_id)
);

CREATE TABLE invoice (
    invoice_id       INTEGER PRIMARY KEY,
    customer_id      INTEGER,
    invoice_date     TEXT,
    billing_address  TEXT,
    billing_city     TEXT,
    billing_state    TEXT,
    billing_country  TEXT,
    billing_postal_code TEXT,
    total            REAL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE invoice_line (
    invoice_line_id INTEGER PRIMARY KEY,
    invoice_id      INTEGER,
    track_id        INTEGER,
    unit_price      REAL,
    quantity        INTEGER,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (track_id)   REFERENCES track(track_id)
);

CREATE TABLE playlist (
    playlist_id INTEGER PRIMARY KEY,
    name        TEXT
);

CREATE TABLE playlist_track (
    playlist_id INTEGER,
    track_id    INTEGER,
    PRIMARY KEY (playlist_id, track_id),
    FOREIGN KEY (playlist_id) REFERENCES playlist(playlist_id),
    FOREIGN KEY (track_id)    REFERENCES track(track_id)
);

-- Verify all tables created successfully
SELECT name FROM sqlite_master WHERE type='table' ORDER BY name;
