-- 1 up
create table if not exists contact_permissions (
    contact_perm_id serial primary key,
    user_id foreign key(users.user_id),
    target_user_id foreign key(users.user_id),
    can_view boolean default false
);

-- 1 down
drop table if exists contact_permissions;