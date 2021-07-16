-- 1 up
create table if not exists posts (
    post_id serial primary key,
    user_id foreign key(users.user_id) not null,
    folder_id foreign key(folders.folder_id),
    title varchar(127) not null,
    created datetime not null,
    modified datetime not null,
    content text
);

-- 1 down
drop table if exists posts;
