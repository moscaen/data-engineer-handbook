DROP TYPE IF EXISTS film_record;
CREATE TYPE film_record AS (
    Film TEXT,
    votes INTEGER,
    Rating REAL,
    FilmID TEXT
);

DROP TYPE IF EXISTS quality_class;
CREATE TYPE quality_class AS
    ENUM ('star','good','average','poor','bad');

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
    actor_name TEXT,
    actor_id TEXT,
    films film_record[],
    quality_class quality_class,
    is_actve BOOLEAN,
    current_year INTEGER
);