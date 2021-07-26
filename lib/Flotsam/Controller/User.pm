#
# Flotsam::Controller::User - interactables for the users table
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

package Flotsam::Controller::User;

use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojolicious::Sessions;

use Authen::TOTP;
use Imager::QRCode;

sub create ($self, $display, $email) {
    my $id = $self->users->add($display, $email);
    return $self->redirect_to('profile', user_id => $id);
}

sub verify ($self, $email, $code) {
    my $totp = Authen::TOTP->new($self->secrets);
    if (!$self->users->exists($email)) {
        return 0;
    }
    my $gen = $totp->generate_otp(user => $email, issuer => $self->config->{domain});
    if ($gen->validate_otp(otp => $code, tolerance => 30)) {
        if (!$self->users->is_mfa_ok($email)) {
            $self->users->add_mfa($email);
        }
        $self->session({email => $email, expiration => 86400});
        return 1;
    }
    return 0;
}

sub tombstone ($self, $id) {
    my $email = $self->session('email');

    unless (defined($email)) {
        $self->render('no_permission');
    }
    my $user_id = $self->users->exists_by_email($email);
    my $can_delete_user = $self->permissions->can_delete_user($user_id);
    if (($id == $user_id) || $can_delete_user) {
        $self->users->tombstone($id);
        # TODO - referer-based redirect
    }
}

sub show_profile ($self, $id) {
    my $email = $self->session('email');

    if (!defined($email)) {
        if ($self->users->is_public($id)) {
            $self->render(profile => $self->users->profile($id));
        } else {
            $self->render(no_user => $id);
        }
    } else {
        my $user_id = $self->users->exists_by_email($email);
        my $can_view_users = 0;
        if (defined($user_id)) {
            $can_view_users = $self->permissions->can_view_users($user_id);
        }
        if ($self->users->is_public(id) || $can_view_users) {
            $self->render(full_profile => $self->users->full_profile($id));
        } else {
            $self->render(no_user => $id);
        }
    }
}

sub update_profile ($self, $id, $display, $email, $bio) {
    my $stored_email = $self->session('email');
    unless (defined($stored_email)) {
        $self->redirect_to('no_permission');
        return;
    }
    my $user_id = $self->users->exists_by_email($email);
    my $can_modify_user = $self->permissions->can_modify_user($user_id);

    if (($user_id == $id) || $can_modify_user) {
        $self->users->update($id, $display, $email, $bio);
        $self->redirect_to(full_profile => $self->users->full_profile($id));
    } else {
        $self->redirect_to('no_permission');
    }
}

sub show_posts ($self, $id) {
    my $email = $self->session('email');

    if (!defined($email)) {
        if ($self->users->is_public($id)) {
            $self->render(posts => $self->posts->list_by_user($id));
        } else {
            $self->render(no_user => $id);
        }
    } else {
        if ($self->users->exists_by_email($email) == $id) {
            $self->render(posts => $self->posts->list_by_user($id));
        } elsif ($self->users->exists_by_id($id) && $self->users->is_public($id)) {
            $self->render(posts => $self->posts->list_by_user_public($id));
        } else {
            $self->render(no_user => $id);
        }
    }
}
