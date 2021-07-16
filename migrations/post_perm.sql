-- 1 up
create table if not exists post_permissions (
    post_perm_id serial primary key,
    user_id foreign key (users.user_id),
    post_id foreign key (posts.post_id),
    can_view boolean default true,
    can_modify boolean default false
);

-- 1 down
drop table if exists post_permissions;