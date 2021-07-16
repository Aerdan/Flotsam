-- 1 up
create table if not exists user_permissions (
    user_perm_id serial primary key,
    user_id foreign key(users.user_id),
    can_view_site boolean default true,
    can_view_users boolean default false,
    can_add_user boolean default false,
    can_modify_user boolean default false,
    can_verify_user boolean default false,
    can_reset_user_mfa boolean default false,
    can_delete_user boolean default false,
    can_delete_post boolean default false,
    can_delete_folder boolean default false,
    can_delete_contact boolean default false,
    can_disable_user boolean default false,
    can_disable_post boolean default false,
    can_disable_folder boolean default false,
    can_disable_contact boolean default false
);

-- 1 down
drop table if exists user_permissions;