-- Twitch Data Exploration and Engagement Analysis

-- 1. Initial Data Inspection
SELECT * 
FROM video_play
LIMIT 20;

SELECT DISTINCT game 
FROM video_play;

SELECT * 
FROM chat
LIMIT 20;

SELECT DISTINCT channel 
FROM chat;


-- 2. Top Games by Viewership
SELECT game AS 'Game Title', COUNT(*) AS Count
FROM video_play 
GROUP BY game 
ORDER BY COUNT(*) DESC
LIMIT 10;

-- 3. Regional Popularity for Specific Titles
SELECT country, COUNT(*) AS 'LoL Streams'
FROM video_play
WHERE game = 'League of Legends'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;

SELECT country, COUNT(*) AS 'CS:GO'
FROM video_play
WHERE game = 'Counter-Strike: Global Offensive'
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 10;


-- 4. Player Platform Usage
SELECT player, COUNT(*) AS 'device'
FROM video_play
GROUP BY 1 
ORDER BY 2 DESC;

-- 5. Game Genre Categorization
-- categorized the most popular titles into specific genres like MOBA, FPS, and Survival using a CASE statement.
SELECT game, 
	CASE
		WHEN game = 'League of Legends' THEN 'MOBA'
		WHEN game = 'Dota 2' THEN 'MOBA'
		WHEN game = 'Heroes of the Storm' THEN 'MOBA'
		WHEN game = 'Counter-Strike: Global Offensive' THEN 'FPS'
		WHEN game = 'DayZ' THEN 'Survival'
		WHEN game = 'ARK: Survival Evolved' THEN 'Survival'
		ELSE 'Other'
	END AS 'genre',
	COUNT(*) AS 'counts'
FROM video_play
GROUP BY 1 
ORDER BY 3 DESC
LIMIT 10;
	

-- 6. Temporal Analysis (Global and Regional)
-- Determining viewership peaks across different time zones
SELECT strftime('%H', time) AS 'hour',
	COUNT(*) AS 'count'
FROM video_play
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at viewership specifically in the US 
SELECT strftime('%H', time) AS 'hour',
	COUNT(*) AS 'count'
FROM video_play
WHERE country = 'US'
GROUP BY 1
ORDER BY 2 DESC;

-- Looking at viewership specifcially in RU (Russia)
SELECT strftime('%H', time) AS 'hour',
	COUNT(*) AS 'count'
FROM video_play
WHERE country = 'RU'
GROUP BY 1
ORDER BY 2 DESC;


-- Join the chat and video_play columns on device_id 
SELECT * 
FROM video_play
JOIN chat
ON video_play.device_id = chat.device_id;

-- 7. Engagement Metrics (Joining Tables)
-- TOP 10 games with the highest engagement ratio
SELECT v.game, 
       COUNT(v.device_id) AS total_views, 
       COUNT(c.device_id) AS total_messages,
       CAST(COUNT(c.device_id) AS REAL) / COUNT(v.device_id) AS engagement_ratio
FROM video_play v
LEFT JOIN chat c ON v.device_id = c.device_id
GROUP BY 1
HAVING total_views > 100
ORDER BY engagement_ratio DESC
LIMIT 10;
	
-- Top 10 Games with the lowest engagement ratio
SELECT v.game, 
       COUNT(v.device_id) AS total_views, 
       COUNT(c.device_id) AS total_messages,
       CAST(COUNT(c.device_id) AS REAL) / COUNT(v.device_id) AS engagement_ratio
FROM video_play v
LEFT JOIN chat c ON v.device_id = c.device_id
GROUP BY 1
HAVING total_views > 100
ORDER BY engagement_ratio ASC
LIMIT 10;

-- 8. Peak Hour Social Heatmap Logic
-- Aggregating unique viewers and chatters for hourly comparisonSELECT strftime('%H', v.time) AS 'hour',
	   COUNT(DISTINCT v.device_id) AS 'viewers',
	   COUNT(DISTINCT c.device_id) AS 'chatters'
FROM video_play AS v
LEFT JOIN chat AS c
	ON v.device_id = c.device_id
GROUP BY 1;

