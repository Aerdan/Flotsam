#
# Flotsam::Model::Post - interactables for the posts table
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

package Flotsam::Model::Post;

use Mojo::Base -base, -signatures;

has 'pg';

sub post_add($self, $user_id, $folder_id, $title, $content) {
    my %post = (
        user_id => $user_id,
        title => $title,
        created => 'now()',
        modified => 'now()',
        content => $content;
    );
    if (defined($folder_id)) {
        $post{folder_id} = $folder_id;
    }
    return $self->pg->db->insert('posts', \%post, { returning => 'post_id'})->hash->{post_id};
}

sub post_list_by_user($self, $user_id) {
    return $self->pg->db->select('posts', [qw(post_id user_id folder_id title created modified)], {user_id => $user_id})->hashes->array;
}
sub post_list_by_folder($self, $folder_id) {
    return $self->pg->db->select('posts', [qw(post_id user_id title created modified)], {folder_id => $folder_id})->hashes->array;
}

sub post_delete($self, $post_id) {
    return $self->pg->db->delete('posts', {post_id => $post_id});
}

sub post_get($self, $post_id) {
    return $self->pg->db->select('posts', [qw(user_id title folder_id title created modified content)], {post_id => $post_id})->hash;
}

1;
