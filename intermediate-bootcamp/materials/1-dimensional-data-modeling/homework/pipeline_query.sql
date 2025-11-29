-- 2. **Cumulative table generation query:** Write a query that populates the `actors` table one year at a time.

WITH last_year AS (
    SELECT 
        actor_name,
        actor_id,
        films,
        quality_class,
        is_actve
    FROM actors
    WHERE current_year = 1970
), this_year AS (
    SELECT 
        Actor,
        ActorId,
        Film,
        Year,
        votes,
        Rating,
        FilmID
    FROM actor_films
    WHERE Year = 1998
)
INSERT INTO actors (actor_name, actor_id, films, quality_class, is_actve, current_year)
SELECT
    COALESCE(ly.actor_name, ty.Actor) as actor_name,
    COALESCE(ly.actor_id, ty.ActorId) as actor_id,
    COALESCE(ly.films, ARRAY[]::film_record[]) || 
    CASE 
        WHEN ty.Year IS NOT NULL THEN
            ARRAY[ROW(
                ty.Film,
                ty.votes,
                ty.Rating,
                ty.FilmID
            )::film_record]
        ELSE ARRAY[]::film_record[] 
    END as films,
    CASE
        WHEN ty.Year IS NOT NULL THEN
            (CASE 
                WHEN ty.Rating > 8 THEN 'star'::quality_class
                WHEN ty.Rating > 7 AND ty.Rating <= 8 THEN 'good'::quality_class
                WHEN ty.Rating > 6 AND ty.Rating <= 7 THEN 'average'::quality_class
                ELSE 'bad'::quality_class 
            END)
        ELSE ly.quality_class
    END as quality_class,
    ty.Year IS NOT NULL as is_active,
    -- CASE
    --     WHEN ty.Year IS NOT NULL THEN TRUE
    --     ELSE COALESCE(ly.is_actve, FALSE)
    -- END as is_actve,
    1998 as current_year
FROM last_year ly
FULL OUTER JOIN this_year ty
    ON ly.actor_name = ty.Actor AND ly.actor_id = ty.ActorId