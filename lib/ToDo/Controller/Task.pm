package ToDo::Controller::Task;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Date::Calc;

=head1 NAME

ToDo::Controller::Task - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched ToDo::Controller::Task in Task.');
}

sub add : Local {
    my ( $self, $c ) = @_;

    my $user = $c->user;
    return unless ( $user );

    my ($title, $description) = map { $c->req->param($_) } qw/title description/;
    return unless ( $title && $description );

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

sub auto : Private {
    my ($self, $c) = @_;

    unless ( $c->user_exists ) {
        $c->res->redirect($c->uri_for('/login'));
        return 0;
    }

    return 1;
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
