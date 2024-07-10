-- working w the above data:
-- Retrieve all users who have never posted a photo:

SELECT u.id, u.username
FROM users u
LEFT JOIN photos p ON u.id = p.user_id
WHERE p.id IS NULL;

-- Find the top 5 most liked photos:

SELECT p.id, p.image_url, COUNT(l.user_id) AS like_count
FROM photos p
LEFT JOIN likes l ON p.id = l.photo_id
GROUP BY p.id
ORDER BY like_count DESC
LIMIT 5;

--Get the number of comments each photo has received:

SELECT p.id, p.image_url, COUNT(c.id) AS comment_count
FROM photos p
LEFT JOIN comments c ON p.id = c.photo_id
GROUP BY p.id;

-- Find users who have commented on their own photos:

SELECT DISTINCT u.id, u.username
FROM users u
JOIN comments c ON u.id = c.user_id
JOIN photos p ON c.photo_id = p.id
WHERE u.id = p.user_id;

-- List the top 5 most followed users:

SELECT u.id, u.username, COUNT(f.follower_id) AS follower_count
FROM users u
LEFT JOIN follows f ON u.id = f.followee_id
GROUP BY u.id
ORDER BY follower_count DESC
LIMIT 5;

--Retrieve all photos tagged with a specific tag (e.g., 'sunset'):

SELECT p.id, p.image_url
FROM photos p
JOIN photo_tags pt ON p.id = pt.photo_id
JOIN tags t ON pt.tag_id = t.id
WHERE t.tag_name = 'sunset';

-- Find the average number of likes per photo:

SELECT AVG(like_count) AS avg_likes
FROM (
    SELECT COUNT(l.user_id) AS like_count
    FROM photos p
    LEFT JOIN likes l ON p.id = l.photo_id
    GROUP BY p.id
) subquery;

-- Get the list of users who follow a specific user (e.g., user with id 1):

SELECT u.id, u.username
FROM users u
JOIN follows f ON u.id = f.follower_id
WHERE f.followee_id = 1;

-- Find the user who has liked the most photos:

SELECT u.id, u.username, COUNT(l.photo_id) AS like_count
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id
ORDER BY like_count DESC
LIMIT 1;

-- Get the most recent comment for each photo:

SELECT p.id AS photo_id, p.image_url, c.id AS comment_id, c.comment_text, c.created_at
FROM photos p
JOIN comments c ON p.id = c.photo_id
WHERE c.created_at = (
    SELECT MAX(created_at)
    FROM comments
    WHERE photo_id = p.id
);

