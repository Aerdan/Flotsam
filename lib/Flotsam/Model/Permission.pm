#
# Flotsam::Model::Permission - permission system
# Copyright 2021 Síle Ekaterin Aman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package Flotsam::Model::Permission;

use Mojo::Base -base, -signatures;

has 'pg';

# Site-wide user permissions
sub user_can_view_site ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_view_site)], {user_id => $user_id})->hash->{can_view_site};
}

sub user_can_add_post ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_add_post)], {user_id => $user_id})->hash->{can_add_post};
}

sub user_can_add_folder ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_add_folder)], {user_id => $user_id})->hash->{can_add_folder};
}

sub user_can_add_contact ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_add_contact)], {user_id => $user_id})->hash->{can_add_contact};
}

sub user_can_add_user ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_add_user)], {user_id => $user_id})->hash->{can_add_user};
}

sub user_can_view_users ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_view_users)], {user_id => $user_id})->hash->{can_view_users};
}

sub user_can_modify_user ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_modify_user)], {user_id => $user_id})->hash->{can_modify_user};
}

sub user_can_verify_user ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_verify_user)], {user_id => $user_id})->hash->{can_verify_user};
}

sub user_can_reset_user_mfa ($self, $user_id) {
    return $self->pg->db->select('user_permissions', [qw(can_reset_user_mfa)], {user_id => $user_id})->hash->{can_reset_user_mfa};
}

sub user_can_delete_user ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_delete_user)], {user_id => $user_id})->hash->{can_delete_user};
}

sub user_can_delete_post ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_delete_post)], {user_id => $user_id})->hash->{can_delete_post};
}

sub user_can_delete_folder ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_delete_folder)], {user_id => $user_id})->hash->{can_delete_folder};
}

sub user_can_delete_contact ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_delete_contact)], {user_id => $user_id})->hash->{can_delete_contact};
}

sub user_can_disable_user ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_disable_user)], {user_id => $user_id})->hash->{can_disable_user};
}

sub user_can_disable_post ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_disable_post)], {user_id => $user_id})->hash->{can_disable_post};
}

sub user_can_disable_folder ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_disable_folder)], {user_id => $user_id})->hash->{can_disable_folder};
}

sub user_can_disable_contact ($self, $user_id) {
    return $self->pg->db->select('user_permisions', [qw(can_disable_contact)], {user_id => $user_id})->hash->{can_disable_contact};
}

# Permissions for individual posts
sub user_can_view_post ($self, $user_id, $post_id) {
    return $self->pg->db->select('post_permissions', [qw(can_view)], {user_id => $user_id, post_id => $post_id})->hash->{can_view};
}

sub user_can_modify_post ($self, $user_id, $post_id) {
    return $self->pg->db->select('post_permissions', [qw(can_modify)], {user_id => $user_id, post_id => $post_id})->hash->{can_modify};
}

# Permissions for individual folders
sub user_can_view_folder ($self, $user_id, $folder_id) {
    return $self->pg->db->select('folder_permissions', [qw(can_view)], {user_id => $user_id, folder_id => $folder_id})->hash->{can_view};
}

sub user_can_modify_folder ($self, $user_id, $folder_id) {
    return $self->pg->db->select('folder_permissions', [qw(can_modify)], {user_id => $user_id, folder_id => $folder_id})->hash->{can_modify};
}

# Permissions for contacts
sub user_can_view_contact ($self, $user_id, $contact_id, $target_user_id) {
    my $public = $self->pg->db->select('contacts', ['public'], {contact_id => $contact_id})->hash->{public};
    my $viewable = $self->pg->db->select('contact_permissions', ['can_view'], {
        user_id => $user_id,
        target_user_id => $target_user_id
    })->hash->{can_view};
    if (defined($viewable) && $viewable) {
        return $viewable;
    } elsif (defined($public) && $public) {
        return $public;
    } else {
        return 0;
    }
}

1;
