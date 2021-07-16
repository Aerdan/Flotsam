-- 1 up
create table if not exists contacts (
    contact_id serial primary key,
    user_id foreign key (users.user_id),
    platform varchar(255) not null,
    link varchar(512) not null,
    display_name varchar(255) not null,
    public boolean default true
);

-- 1 down
drop table if exists contacts;