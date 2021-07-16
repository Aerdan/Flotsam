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

sub user_add ($self, $display, $email) {
    return $self->pg->db->insert('users', {display_name => $display, email => $email}, {returning => 'user_id'})->hash->{user_id};
}

sub user_exists ($self, $user_id) {
    my $ret = 0;
    if ($self->pg->db->select('users', [qw(user_id)], {user_id => $user_id})->hash->{user_id} == $user_id) {
        $ret = 1;
    }
    return $ret;
}

sub user_list ($self) {
    return $self->pg->db->select('users', [qw(user_id display_name email email_ok mfa_ok)])->hashes->array;
}

sub user_delete_by_id ($self, $user_id) {
    return $self->pg->db->delete('users', {user_id => $user_id});
}

sub user_get ($self, $user_id) {
    return $self->pg->db->select('users', [qw(user_id display_name email email_ok mfa_ok)], {user_id => $user_id})->hash;
}

1;
