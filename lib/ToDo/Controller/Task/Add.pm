package ToDo::Controller::Task::Add;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Date::Calc;

our $TITLE_LENGTH       = 40;
our $DESCRIPTION_LENGTH = 1000;

=head1 NAME

ToDo::Controller::Task::Add - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my $mode = $c->req->param('mode') || 'main';
    $c->detach($mode);
}

sub main :Private {
    my ( $self, $c ) = @_;

    $c->stash->{title}       = $c->req->param('title');
    $c->stash->{description} = $c->req->param('description');

    $c->stash->{template} = 'add_main.tt';
}

sub commit: Private {
    my ( $self, $c ) = @_;

    my $user = $c->user;
    return unless ( $user );

    # validation
    $c->form(
        title       => ['NOT_BLANK', ['LENGTH', 1, $TITLE_LENGTH]],
        description => [['LENGTH', 0, $DESCRIPTION_LENGTH]],
    );

    if ( $c->form->has_error ) {
        $c->stash->{error} = $c->form;
        $c->detach('main');
        return 0;
    }

    my $title       = $c->req->param('title');
    my $description = $c->req->param('description');

    my $row = $c->model('ToDoDB::Task')->create({
        user_id => $user->user_id,
        title => $title,
        description => $description,
        status      => 0,
        created_at  => now(),
        updated_at  => now(),
    });

    $c->res->redirect($c->uri_for('/'));
}

sub now {
    return sprintf "%04d%02d%02d%02d%02d%02d", Date::Calc::Today_and_Now;
}

=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
