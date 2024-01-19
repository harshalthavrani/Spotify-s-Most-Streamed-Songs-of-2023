-- Let's see which artist has the most songs in the top streamed list of 2023?
SELECT TOP 1 
  [artist(s)_name],
  COUNT(*) as song_count
FROM [Spotify 2023 songs].[dbo].['spotify-2023$'] 
WHERE released_year = 2023
GROUP BY [artist(s)_name]
ORDER BY song_count DESC;

--Let's see what is the average number of streams for songs released in each month of 2023?
SELECT
[released_month]
, ROUND(AVG(streams),0) as avg_streams
FROM [Spotify 2023 songs].[dbo].['spotify-2023$'] 
WHERE released_year = 2023
GROUP BY released_month
ORDER BY released_month;

--Let's see which songs are with higher danceability percentages generally more popular (i.e. have more streams)?
SELECT 
  CASE
    WHEN [danceability_%] <= 25 THEN '0-25%'
    WHEN [danceability_%] <= 50 THEN '26-50%'
    WHEN [danceability_%] <= 75 THEN '51-75%'
    ELSE '76-100%'
  END AS danceability_group,
  AVG(CAST(streams AS BIGINT)) as avg_streams -- Assuming streams is a numeric field that can be cast to an INT or BIGINT
FROM 
  [Spotify 2023 songs].[dbo].['spotify-2023$']  -- Replace with your actual table name
GROUP BY 
  CASE
    WHEN [danceability_%] <= 25 THEN '0-25%'
    WHEN [danceability_%] <= 50 THEN '26-50%'
    WHEN [danceability_%] <= 75 THEN '51-75%'
    ELSE '76-100%'
  END
ORDER BY 
  avg_streams DESC;

-- Let's see what percentage of songs in the 'Top Spotify Songs 2023' were actually released in 2023?
WITH SongCounts AS 
(SELECT
COUNT(*) AS total_count,
SUM(CASE WHEN released_year = 2023 THEN 1 ELSE 0 END) AS count_2023
FROM [Spotify 2023 songs].[dbo].['spotify-2023$'])
SELECT
(count_2023 * 100.0 / total_count) AS percentage_released_in_2023
FROM SongCounts;
