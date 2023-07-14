USE vk;

-- 1. Подсчитать количество групп (сообществ), в которые вступил каждый пользователь.

SELECT u.id, u.firstname, u.lastname , count(*) 
FROM users AS u 
LEFT JOIN users_communities AS uc
ON u.id = uc.user_id 
GROUP BY u.id  
ORDER BY u.id;


-- 2. Подсчитать количество пользователей в каждом сообществе.

SELECT uc.community_id, c.name, count(*) 
FROM users_communities AS uc
JOIN communities c 
ON uc.community_id = c.id 
GROUP BY community_id  
ORDER BY community_id;


-- 3. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, 
-- который больше всех общался с выбранным пользователем (написал ему сообщений).

SELECT users.firstname, users.lastname 
FROM users  
WHERE users.id = 
	(SELECT m.from_user_id  -- , m.to_user_id, count(*) AS 'количество сообщений'  
	FROM messages m 
	JOIN users u ON u.id = 1
	WHERE m.to_user_id = u.id
	GROUP BY m.from_user_id
	ORDER BY count(*) DESC
	LIMIT 1);

	
-- 4*. Подсчитать общее количество лайков, которые получили пользователи младше 18 лет

SELECT sum(cl) AS 'кол-во лайков'
FROM (
	SELECT u.id, u.lastname, count(*) AS cl
	FROM users u
	
	JOIN profiles p 
	ON u.id = p.user_id AND TIMESTAMPDIFF(YEAR, birthday, NOW()) < 18 
	
	JOIN media m 
	ON u.id = m.user_id 
	
	JOIN likes l 
	ON m.id = l.media_id
	
	GROUP BY u.id
) AS ll;


-- 5*. Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT p.gender, count(*) AS count_of_likes 
FROM users u 

JOIN profiles p 
ON u.id = p.user_id

JOIN likes l 
ON u.id = l.user_id 

GROUP BY p.gender 

ORDER BY count_of_likes DESC
LIMIT 1;

