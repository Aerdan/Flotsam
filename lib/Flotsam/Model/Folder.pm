#
# Flotsam::Model::Folder - interactables for the folders table
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

package Flotsam::Model::Folder;

use Mojo::Base -base, -signatures;

has 'pg';

sub add ($self, $user_id, $title, $blurb, $about) {
    return $self->pg->db->insert('folders', {
        user_id  => $user_id,
        title    => $title,
        blurb    => $blurb,
        about    => $about,
        created  => 'now()',
        modified => 'now()',
    }, {returning => 'folder_id'})->hash->{folder_id};
}

sub list_by_user ($self, $user_id) {
    return $self->pg->db->select('folders', [qw(folder_id title blurb created modified)], {user_id => $user_id})->hashes->array;
}

sub delete ($self, $folder_id) {
    return $self->pg->db->delete('folders', {folder_id => $folder_id});
}

sub get ($self, $folder_id) {
    return $self->pg->db->select('folders', [qw(title blurb created modified about)], {folder_id => $folder_id})->hash;
}

1;
