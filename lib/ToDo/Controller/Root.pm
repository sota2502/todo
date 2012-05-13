package ToDo::Controller::Root;
use Moose;
use namespace::autoclean;
use Digest::SHA1;

BEGIN { extends 'Catalyst::Controller' }

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
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'index.tt';

    $c->stash->{email} = $c->req->param('email') || '';

    my $cnt = $c->session->{cnt} || 1;
    $c->stash->{count} = $cnt;
    $c->session->{cnt} = ++$cnt;

    # Hello World
    # $c->response->body( $c->welcome_message );
}

sub register :Local {
    my ( $self, $c ) = @_;

    my $email    = $c->req->param('email');
    my $password = $c->req->param('password');

    unless ( $self->_register($c, $email, $password) ) {
        # $c->stash->{error} = 'Failed register';
    }

    $c->stash->{email} = $email;

    $c->forward('index');
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

    unless ( $email && $password ) {
        $c->stash->{error} = 'Input email and password';
        $c->detach('index');
        return;
    }

    unless ( $c->authenticate({email => $email, password => $password}) ) {
        $c->stash->{error} = 'Failed authentication';
        $c->detach('index');
        return;
    }

    $c->response->body('Successed authentication');
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
