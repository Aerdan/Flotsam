#
# Flotsam::Model::User - interactables for the users table
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

package Flotsam::Model::User;

use Mojo::Base -base, -signatures;

has 'pg';

use Authen::TOTP;

sub add ($self, $display, $email) {
    return $self->pg->db->insert('users', {display_name => $display, email => $email}, {returning => 'user_id'})->hash->{user_id};
}

sub add_mfa ($self, $email) {
    return $self->pg->db->update('users', {mfa_ok => 1}, {email => $email}, {returning => 'user_id'})->hash->{user_id};
}

sub is_mfa_ok ($self, $email) {
    return $self->pg->db->select('users', [qw(mfa_ok)], {email => $email})->hash->{mfa_ok};
}

sub is_public ($self, $user_id) {
    return $self->pg->db->select('users', [qw(public)], {user_id => $user_id})->hash->{public};
}

sub exists_by_email ($self, $email) {
    my $user = $self->pg->db->select('users', [qw(user_id email)], {email => $email})->hash;

    if ($user->{email} eq $email)
        return $user->{user_id};
    }
    return undef;
}

sub exists_by_id ($self, $user_id) {
    my $user = $self->pg->db->select('users', [qw(user_id)], {user_id => $user_id})->hash;

    if ($user->{user_id} == $user_id) {
        return $user->{user_id};
    }
    return undef;
}

sub list ($self) {
    return $self->pg->db->select('users', [qw(id display_name email email_ok mfa_ok)])->hashes->array;
}

sub delete_by_id ($self, $user_id) {
    return $self->pg->db->delete('users', {user_id => $user_id});
}

sub get ($self, $id) {
    return $self->pg->db->select('users', [qw(id display_name email email_ok mfa_ok)], {user_id => $user_id})->hash;
}

sub profile ($self, $user_id) {
    return $self->pg->db->select('users', [qw(display_name bio)], {user_id => $user_id})->hash;
}

sub full_profile ($self, $id) {
    return $self->pg->db->select('users', [qw(display_name email email_ok mfa_ok bio)], {user_id => $user_id})->hash;
}

1;
