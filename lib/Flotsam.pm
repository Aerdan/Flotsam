package Flotsam;
use Mojo::Base 'Mojolicious', -signatures;

use Flotsam::Model::User;
use Flotsam::Model::Post;
use Flotsam::Model::Folder;
use Flotsam::Model::Permission;

# This method will run once at server start
sub startup ($self) {
    # Load configuration from config file
    my $config = $self->plugin('NotYAMLConfig');

    # Configure the application
    $self->secrets($config->{secrets});

    # Models
    $self->helper(pg          => sub { state $pg = Mojo::Pg->new(shift->config('pg')) });
    $self->helper(users       => sub { state $users = Flotsam::Model::User->new() });
    $self->helper(posts       => sub { state $posts = Flotsam::Model::Post->new() });
    $self->helper(folders     => sub { state $folders = Flotsam::Model::Folder->new() });
    $self->helper(permissions => sub { state $permissions = Flotsam::Model::Permission->new() });

    # Database setup
    foreach my $fname (qw(user.sql post.sql folder.sql permission.sql)) {
        my $path = $self->home->child('migrations', $fname);
        my ($base, $ext) = split /\./, $fname, 2;
        $self->pg->auto_migrate(1)->migrations->name($base)->from_file($path);
    }

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('Example#welcome');
}

1;
