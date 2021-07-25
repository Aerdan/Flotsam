-- 1 up
create table if not exists user_permissions (
    user_perm_id serial primary key,
    user_id foreign key(users.user_id),
    can_view_site boolean default true,
    can_add_post boolean default true,
    can_add_folder boolean default true,
    can_add_contact boolean default true,
    can_add_user boolean default false,
    can_view_users boolean default false,
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

-- 2 up
create table if not exists post_permissions (
    post_perm_id serial primary key,
    user_id foreign key (users.user_id),
    post_id foreign key (posts.post_id),
    can_view boolean default true,
    can_modify boolean default false
);

-- 3 up
create table if not exists folder_permissions (
    folder_perm_id serial primary key,
    user_id foreign key (users.user_id),
    folder_id foreign key (folders.folder_id),
    can_view boolean default true,
    can_modify boolean default false
);

-- 4 up
create table if not exists contact_permissions (
    contact_perm_id serial primary key,
    user_id foreign key(users.user_id),
    target_user_id foreign key(users.user_id),
    can_view boolean default false
);

-- 1 down
drop table if exists user_permissions;

-- 2 down
drop table if exists post_permissions;

-- 3 down
drop table if exists folder_permissions;

-- 4 down
drop table if exists contact_permissions;
