-- 1 up
create table if not exists folders (
    folder_id serial primary key,
    user_id foreign key (users.user_id) not null,
    title varchar(127) not null,
    blurb text not null,
    created date not null,
    modified date not null,
    about text
);

-- 1 down
drop table if exists folders;