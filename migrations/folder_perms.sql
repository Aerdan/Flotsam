-- 1 up
create table if not exists folder_permissions (
    folder_perm_id serial primary key,
    user_id foreign key (users.user_id),
    folder_id foreign key (folders.folder_id),
    can_view boolean default true,
    can_modify boolean default false
);

-- 1 down
drop table if exists folder_permissions;