-- 1 up
create table if not exists users (
    user_id serial primary key,
    display_name varchar(127),
    email varchar(127),
    email_ok boolean,
    mfa varchar(127),
    mfa_ok boolean
);

-- 1 down
drop table if exists users;