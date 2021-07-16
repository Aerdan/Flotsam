-- 1 up
create table if not exists users (
    user_id serial primary key,
    display_name varchar(127) not null,
    email varchar(127) unique not null,
    email_ok boolean default false,
    mfa varchar(127),
    mfa_ok boolean default false
);

-- 1 down
drop table if exists users;