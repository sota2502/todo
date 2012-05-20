package ToDo::Controller::Task;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Encode;
use Date::Calc;

=head1 NAME

ToDo::Controller::Task - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(1) {
    my ( $self, $c ) = @_;

    my $args = $c->req->args;
    if ( $args->[0] eq 'all' ) {
        $c->detach('all');
        return 1;
    } elsif ( $args->[0] =~ /\A\d+\z/ ) {
        $c->detach('view');
        return 1;
    }

    $c->res->body('Not Found');
    $c->res->status(404);
}

sub all : Private {
    my ($self, $c) = @_;

    my @tasks = $c->model('ToDoDB::Task')->search(
        { user_id => $c->user->get('user_id') },
        { order_by => { -desc => 'updated_at' } },
    );

    my @task_list = map { __object_to_plain($_) } @tasks;

    $c->stash->{task_list} = \@task_list;
    $c->stash->{template} = 'list_main.tt';
}

sub view : Private {
    my ($self, $c) = @_;

    my $task_id = $c->req->args->[0];
    my $entry = $c->model('ToDoDB::Task')->find($task_id);
    unless ( $entry ) {
        $c->res->body('Not Found');
        $c->res->status(404);
        return 0;
    }

    $c->stash->{entry}    = __object_to_plain($entry);
    $c->stash->{template} = 'view_main.tt';
}

sub json : Local {
    my ($self, $c) = @_;

    my @tasks = $c->model('ToDoDB::Task')->search(
        { user_id => $c->user->get('user_id') },
        { order_by => { -desc => 'updated_at' } },
    );

    my @task_list = map { __object_to_plain($_) } @tasks;

    $c->stash->{task_list} = \@task_list;
    $c->forward('ToDo::View::JSON');
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

sub __object_to_plain {
    my $entry = shift;

    return {
        task_id => $entry->task_id,
        title   => $entry->title,
        description => $entry->description || q{},
        status      => $entry->status,
        created_at  => ( $entry->created_at ) ? $entry->created_at->datetime : '',
        updated_at  => ( $entry->updated_at ) ? $entry->updated_at->datetime : '',
    };
}


=head1 AUTHOR

Souta Nakamori

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
