CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
	email VARCHAR(100) NOT NULL UNIQUE COMMENT "Почта",
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT "Телефон",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'Таблица пользователей';


CREATE TABLE profiles (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
    user_id INT UNSIGNED UNIQUE NOT NULL COMMENT "Ссылка на пользователя", 
	first_name VARCHAR(100) NOT NULL COMMENT "Имя пользователя",
	last_name VARCHAR(100) NOT NULL COMMENT "Фамилия пользователя",
    birth_date DATE COMMENT "Дата рождения",    
    country VARCHAR(100) COMMENT "Страна проживания",
    city VARCHAR(100) COMMENT "Город проживания",
    `status` ENUM('ONLINE', 'OFFLINE', 'INACTIVE') COMMENT "Текущий статус",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Таблица профилей пользователей';

-- Связываем поле "user_id" таблицы "profiles" с полем "id" таблицы "users" c помощью внешнего ключа
ALTER TABLE profiles ADD CONSTRAINT fk_profiles_user_id FOREIGN KEY (user_id) REFERENCES users(id);

CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
	from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на отправителя сообщения",
	to_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя сообщения",
    message_header VARCHAR(255) COMMENT "Заголовок сообщения",
    message_body TEXT NOT NULL COMMENT "Текст сообщения",
    is_delivered BOOLEAN NOT NULL COMMENT "Признак доставки",
    was_edited BOOLEAN NOT NULL COMMENT "Признак правки заголовка или тела сообщения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT 'Таблица сообщений пользователей';

ALTER TABLE messages ADD CONSTRAINT fk_messages_from_user_id FOREIGN KEY (from_user_id) REFERENCES users(id);
ALTER TABLE messages ADD CONSTRAINT fk_messages_to_user_id FOREIGN KEY (to_user_id) REFERENCES users(id);


CREATE TABLE friendship (
    user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
    friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
    friendship_status ENUM('FRIENDSHIP', 'FOLLOWING', 'BLOCKED') COMMENT "Cтатус (текущее состояние) отношений",
	requested_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время отправления приглашения дружить",
	confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
	PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ"
) COMMENT 'Таблица дружбы пользователей';

ALTER TABLE friendship ADD CONSTRAINT fk_friendship_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE friendship ADD CONSTRAINT fk_friendship_friend_id FOREIGN KEY (friend_id) REFERENCES users(id);

-- Таблица групп

CREATE TABLE communities (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор сроки",
  name VARCHAR(150) NOT NULL UNIQUE COMMENT "Название группы",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Группы";

-- Таблица связи пользователей и групп

CREATE TABLE communities_users (
  community_id INT UNSIGNED NOT NULL COMMENT "Ссылка на группу",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки", 
  PRIMARY KEY (community_id, user_id) COMMENT "Составной первичный ключ"
) COMMENT "Участники групп, связь между пользователями и группами";

ALTER TABLE communities_users ADD CONSTRAINT fk_cu_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE communities_users ADD CONSTRAINT fk_cu_community_id FOREIGN KEY (community_id) REFERENCES communities(id);


CREATE TABLE entity_types (
  `name` varchar(100) NOT NULL PRIMARY KEY COMMENT 'Имя сущности'
) COMMENT 'Справочная таблица с перечнем сущностей, которым можно поставить лайк';

CREATE TABLE likes (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    from_user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя лайкнувшего пост",
    entity_name VARCHAR(128) NOT NULL COMMENT "Ссылка на медиа",
    created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Таблица лайков';

ALTER TABLE likes ADD CONSTRAINT fk_likes_entity_name FOREIGN KEY (entity_name) REFERENCES entity_types(`name`);


CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  user_id INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на идентификатор пользователя который опубликовал пост',
  community_id INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на дентификатор пользователя который опубликовал пост',
  post_content TEXT COMMENT 'Текст произвольной длины',
  visibility VARCHAR(100) NOT NULL COMMENT 'Ссылка на вариант видимости поста',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время публикации поста',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Посты пользователей и групп';


CREATE TABLE visibility (
  `value` VARCHAR(100) NOT NULL PRIMARY KEY COMMENT 'Тип видимости'
) COMMENT 'Справочник вариантов видимости объектов на странице';

ALTER TABLE posts ADD CONSTRAINT fk_post_user_id FOREIGN KEY (user_id) REFERENCES users(id);
ALTER TABLE posts ADD CONSTRAINT fk_post_community_id FOREIGN KEY (community_id) REFERENCES communities(id);
ALTER TABLE posts ADD CONSTRAINT fk_post_visibility_id FOREIGN KEY (visibility) REFERENCES visibility(`value`);


CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  media_type VARCHAR(100) NOT NULL COMMENT 'Ссылка на тип контента',
  link VARCHAR(1000) NOT NULL COMMENT 'Ссылка на файл',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Медиа';


CREATE TABLE media_types (
  `name` VARCHAR(100) NOT NULL PRIMARY KEY COMMENT 'Тип медиайла'
) COMMENT 'Тип медиа контента';

ALTER TABLE media ADD CONSTRAINT fk_media_type_id FOREIGN KEY (media_type) REFERENCES media_types(`name`);


CREATE TABLE posts_media (
  post_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на идентификатор поста',
  media_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на идентификатор медиа',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (post_id, media_id)
) COMMENT 'Связь постов и медиа';

ALTER TABLE posts_media ADD CONSTRAINT fk_pm_media_id FOREIGN KEY (media_id) REFERENCES media(id);
ALTER TABLE posts_media ADD CONSTRAINT fk_pm_post_id FOREIGN KEY (post_id) REFERENCES posts(id);


CREATE TABLE messages_media (
  message_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор сообшения',
  media_id int unsigned NOT NULL COMMENT 'Ссылка на идентификатор медиа',
  created_at datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (message_id, media_id)
) COMMENT 'Связь сообщений и медиа';

ALTER TABLE messages_media ADD CONSTRAINT fk_mm_media_id FOREIGN KEY (media_id) REFERENCES media (id);
ALTER TABLE messages_media ADD CONSTRAINT fk_mm_message_id FOREIGN KEY (message_id) REFERENCES messages (id);

