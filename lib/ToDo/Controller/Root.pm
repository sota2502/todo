package ToDo::Controller::Root;
use Moose;
use namespace::autoclean;
use Digest::SHA1;
use List::MoreUtils qw/any/;

BEGIN { extends 'Catalyst::Controller' }

our @UNREQUIRED_LOGIN = qw/
    register
    login
    logout
/;


#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

ToDo::Controller::Root - Root Controller for ToDo

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    my @tasks = $c->model('ToDoDB::Task')->search(
        { user_id => $c->user->get('user_id') },
        { order_by => { -desc => 'updated_at' } },
    );

    $c->stash->{task_list} = \@tasks;
}

sub register :Local {
    my ( $self, $c ) = @_;

    my $email    = $c->req->param('email') || q{};
    my $password = $c->req->param('password') || q{};

    if ( $email && $password ) {
        if ( $self->_register($c, $email, $password) ) {
            $c->res->body('Successed register');
            return 1;
        }

        $c->stash->{error} = 'Failed register';
    }

    $c->stash->{email} = $email;
}


sub _register {
    my ($self, $c, $email, $password) = @_;

    unless ( $email && $password ) {
        $c->stash->{error} = 'Input email and password';
        return 0;
    }

    my $model = $c->model('ToDoDB::User');
    my $user = $model->find({email => $email});
    if ( $user ) {
        $c->stash->{error} = 'Already exist';
        return 0;
    }

    my $encoded = Digest::SHA1::sha1_hex($password);
    my $row = $c->model('ToDoDB::User')->create({
        email    => $email,
        password => $encoded,
    });
    unless ( $row ) {
        $c->stash->{error} = 'Failed register';
        return 0;
    }

    return 1;
}

sub login :Local {
    my ($self, $c) = @_;
    my ($email, $password) = map { $c->request->params->{$_} } qw/email password/;


    if ( $email && $password ) {
        if ( $c->authenticate({email => $email, password => $password}) ) {
            $c->res->redirect($c->uri_for('/'));
            return 1;
        }

        $c->stash->{error} = 'Failed authentication';
    }
}

sub logout :Local {
    my ($self, $c) = @_;

    $c->logout;

    $c->res->redirect($c->uri_for('/'));
}

sub auto : Private {
    my ($self, $c) = @_;
    
    if ( any { $c->action->reverse eq $_ } @UNREQUIRED_LOGIN ) {
        return 1;
    }

    unless ( $c->user_exists ) {
        $c->res->redirect($c->uri_for('/login'));
        return 0;
    }

    $c->stash->{token} = $c->token;

    return 1;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

SotaNakamori

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
