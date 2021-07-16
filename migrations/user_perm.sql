-- 1 up
create table if not exists user_permissions (
    user_perm_id serial primary key,
    user_id foreign key(users.user_id),
    can_view_site boolean default true,
    can_view_users boolean default false,
    can_add boolean default false,
    can_modify boolean default false,
    can_email_ok boolean default false,
    can_mfa_reset boolean default false
);

-- 1 down
drop table if exists user_permissions;